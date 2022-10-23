import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:motor_hunter/base/widgets.dart';
import 'package:motor_hunter/data/api/models/response/offer_model_response.dart';
import 'package:motor_hunter/data/api/rest_api.dart';
import 'package:motor_hunter/data/clients/mappers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';

import '../base/styles.dart';
import '../constants/dimen_constants.dart';
import '../constants/string_constants.dart';
import '../data/api/models/object/offer_model.dart';

class OrderPage extends StatefulWidget {
  final Offer order;

  const OrderPage({Key? key, required this.order}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderPage();
}

class _OrderPage extends State<OrderPage> {
  late Offer order;
  late VideoPlayerController _controller;
  late Future initVideoPlayerController;

  TextEditingController controllerPrice = TextEditingController();

  final double paddingMessage = 30.0;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  String description = "";
  double price = 0.0;
  bool isApproveLoad = false;
  bool isReloadList = false;
  late bool isVisibleApproveButton;

  @override
  void initState() {
    order = widget.order;
    super.initState();
    price = order.price ?? 0.0;
    _controller = VideoPlayerController.network(order.video ?? "");
    initVideoPlayerController = _controller.initialize();
    isVisibleApproveButton = order.idStatus == 4;
    _controller.addListener(() {
      setState(() {});
    });
  }

  void _onRefresh() {
    Apis().getOffer(order.id).then((OfferResponse offer) {
      offer.id = order.id;
      setState(() {
        order = Mappers().mapOffers(offer);
      });
      _refreshController.refreshCompleted();
    }).catchError((error) {
      print(error);
      _refreshController.refreshFailed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onBackPressed() {
    return Navigator.of(context).pop(isReloadList);
  }

  Future<bool> _returnActionAfterBack() {
    Navigator.of(context).pop(isReloadList);
    return Future(() => false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _returnActionAfterBack,
        child: Scaffold(
            appBar: AppBar(
                title: const Text(StringResources.appName),
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      _onBackPressed();
                    })),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: setOfferData(),
            )));
  }

  void _onDescriptionTextChange(String text) {
    description = text;
  }

  void _onPriceTextChange(String text) {
    if (text.isEmpty) return;
    order.price = double.parse(text);
  }

  void _onClickApprovePrice() {
    TextButton cancelButton = TextButton(
      style: TextButton.styleFrom(primary: Colors.black),
      onPressed: () {
        if (isApproveLoad) return;
        Navigator.pop(context);
      },
      child: const Text(StringResources.cancel),
    );

    TextButton declineButton = TextButton(
      style: TextButton.styleFrom(primary: primaryColor),
      onPressed: () {
        if (isApproveLoad) return;
        if (description.isEmpty) {
          showErrorSnackBar(context, StringResources.errorEmptyDescription);
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();
        Apis().approveOfferPrice(order.id, false, description).then((value) {
          Navigator.pop(context);
          _onRefresh();
          isReloadList = true;
          setState(() {
            isApproveLoad = true;
            isVisibleApproveButton = false;
          });
        }).catchError((error) {
          showErrorSnackBar(context, error.toString());
          setState(() {
            isApproveLoad = false;
          });
        });
      },
      child: const Text(StringResources.decline),
    );

    TextButton approveButton = TextButton(
      style: styleAdditionalButton(),
      onPressed: () {
        if (isApproveLoad) return;

        if (price != order.price) {
          showErrorSnackBar(context, StringResources.errorPriceApprove);
          return;
        }
        FocusManager.instance.primaryFocus?.unfocus();
        Apis().approveOfferPrice(order.id, true, description).then((value) {
          Navigator.pop(context);
          _onRefresh();
          isReloadList = true;
          setState(() {
            isApproveLoad = true;
            isVisibleApproveButton = false;
          });
        }).catchError((error) {
          showErrorSnackBar(context, error.toString());
          setState(() {
            isApproveLoad = false;
          });
        });
      },
      child: const Text(StringResources.approve),
    );
    controllerPrice.text = price.toString();

    AlertDialog approveDialog = AlertDialog(
      title: const Text(StringResources.titleDialogPriceApprove),
      content: SingleChildScrollView(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(StringResources.descriptionDialogPriceApprove),
          const SizedBox(
            height: 8.0,
          ),
          TextField(
            controller: controllerPrice,
            keyboardType: TextInputType.number,
            onChanged: _onPriceTextChange,
            obscureText: false,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(
              height: 120.0,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 7,
                onChanged: _onDescriptionTextChange,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(hintText: StringResources.textHintDescription, helperText: StringResources.textHelperPassword),
              )),
          Visibility(
              visible: isApproveLoad,
              child: const CupertinoActivityIndicator(
                color: Colors.white,
                radius: 12.0,
              ))
        ],
      )),
      actions: [cancelButton, declineButton, approveButton],
    );

    showDialog(context: context, builder: (BuildContext context) => approveDialog);
  }

  Widget setOfferData() => SmartRefresher(
      enablePullDown: true,
      header: const WaterDropHeader(
        waterDropColor: primaryColor,
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      child: ListView(
        children: [
          createWidgetTitleValue("Comment order:", order.managerComment ?? "No comment"),
          // const SizedBox(
          //   height: 8.0,
          // ),
          createDivider(),
          createWidgetTitleValue("Status order:", order.messageStatus, colorBorder: order.colorBorder),
          createDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Price order:",
                    style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold),
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(format('{:.2f}', order.price ?? 0.0)),
                  Visibility(visible: isVisibleApproveButton, child: const SizedBox(width: 8.0)),
                  Visibility(
                      visible: isVisibleApproveButton,
                      child: TextButton(
                          style: stylePrimaryButton(100.0, DoubleConstants.minButtonHeight),
                          onPressed: _onClickApprovePrice,
                          child: const Text(StringResources.textApproveButton)))
                ],
              )
            ],
          ),
          createDivider(),
          createWidgetTitleValue("Manager comment", order.managerComment ?? "No comment"),
          createDivider(),
          createWidgetTitleValue("Supplier comment", order.supplierComment ?? "No comment"),
          createPhotosWidget(),
          Align(alignment: Alignment.topCenter, child: createVideoWidget()),
          // const Padding(padding: EdgeInsets.only(left: 12.0, bottom: 4.0, top: 12.0), child: Text("Messages")),
          // getWidgetListMessage(),
        ],
      ));

  Widget createDivider() => const Padding(
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
      child: Divider(
        height: 2,
        color: Colors.black54,
      ));

  Widget createPhotosWidget() {
    if (order.photos != null && order.photos?.isNotEmpty == true) {
      return SizedBox(
        height: 100.0,
        child: ListView.builder(
            padding: const EdgeInsets.all(2.0),
            itemCount: order.photos!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => imageFromExternal(order.photos![index])),
      );
    } else {
      return Container();
    }
  }

  Widget createVideoWidget() {
    if (order.video?.isNotEmpty == true) {
      return FutureBuilder(
        future: initVideoPlayerController,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return SizedBox(
                  height: 100.0,
                  child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: showErrorScreen("Video not loaded")));
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: SizedBox(
                      height: 100.0,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 100.0, child: VideoPlayer(_controller)),
                          VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                          ),
                          Row(
                            children: [
                              FloatingActionButton.small(
                                onPressed: () {
                                  _controller.play();
                                },
                                child: const Icon(Icons.play_arrow),
                              ),
                              FloatingActionButton.small(
                                onPressed: () {
                                  _controller.pause();
                                },
                                child: const Icon(Icons.pause),
                              ),
                            ],
                          )
                        ],
                      )),
                ),
              );
            }
          } else {
            return SizedBox(
                height: 100.0,
                child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Center(
                      child: CupertinoActivityIndicator(
                        color: primaryColor,
                      ),
                    )));
          }
        },
      );
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
