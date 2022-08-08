import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motor_hunter/base/widgets.dart';
import 'package:motor_hunter/data/api/rest_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/styles.dart';
import '../data/api/models/offer_model.dart';

class OrderPage extends StatefulWidget {
  final Offer order;

  const OrderPage({Key? key, required this.order}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderPage(order);
}

class _OrderPage extends State<OrderPage> {
  Offer order;

  _OrderPage(this.order);

  final double paddingMessage = 30.0;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
  }

  void _onRefresh() {
    Apis().getOffer(order.id).then((Offer offer) {
      setState(() {
        order = offer;
      });
      _refreshController.refreshCompleted();
    }).catchError((error) {
      _refreshController.refreshCompleted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar(),
      body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(children: [
            createWidgetTitleValue("Comment order:", order.comment),
            const SizedBox(
              height: 10.0,
            ),
            createWidgetTitleValue("Status order:", order.status),
            const SizedBox(
              height: 10.0,
            ),
            createWidgetTitleValue("Price order:", order.price.toString()),
            createPhotosWidget(),
            createVideoWidget(),
            const Padding(
                padding: EdgeInsets.only(left: 12.0, bottom: 4.0, top: 12.0),
                child: Text(
                  "Messages",
                )),
            getWidgetListMessage(),
          ])),
    );
  }

  Widget createPhotosWidget() {
    if (order.hasMedia && order.photos != null && order.photos?.isNotEmpty == true) {
      return const Text("Photos");
    } else {
      return Container();
    }
  }

  Widget createVideoWidget() {
    if (order.hasMedia && order.video?.isNotEmpty == true) {
      return const Text("Video");
    } else {
      return Container();
    }
  }

  Widget getWidgetListMessage() => Expanded(
          child: SmartRefresher(
        enablePullDown: true,
        header: const WaterDropHeader(
          waterDropColor: primaryColor,
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            bool isPositionDivTwo = index % 2 == 0;
            return Padding(
                padding: EdgeInsets.only(left: isPositionDivTwo ? 0.0 : paddingMessage, right: isPositionDivTwo ? paddingMessage : 0.0),
                child: Card(
                  color: isPositionDivTwo ? Colors.brown : Colors.deepOrange,
                  child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                          padding: const EdgeInsets.all(4.0),
                          alignment: isPositionDivTwo ? Alignment.centerLeft : Alignment.centerRight,
                          child: Text(
                            "message text => $index",
                            style: const TextStyle(color: Colors.white),
                          ))),
                ));
          },
          itemExtent: 40.0,
          itemCount: 5,
        ),
      ));
}
