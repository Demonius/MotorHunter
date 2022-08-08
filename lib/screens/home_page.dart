import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motor_hunter/constants/string_constants.dart';
import 'package:motor_hunter/screens/login_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/styles.dart';
import '../base/widgets.dart';
import '../data/api/models/offer_model.dart';
import '../data/api/rest_api.dart';
import '../managers/shared_pref_manager.dart';
import 'order_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  late Future<List<Offer>> itemsFuture;
  late List<Offer> items = List.empty(growable: true);
  late bool isVisibleFab;
  bool hasEmptyOrder = false;
  bool hasError = false;
  late String errorMessage;
  bool isInitializationState = false;

  final ImagePicker _picker = ImagePicker();

  final RefreshController _refreshController = RefreshController(initialRefresh: true);

  void _addNewOffer() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    final Uint8List? photoRaw = await photo?.readAsBytes();
    print("photo path => ${photo?.path} plus photoRaw => ${photoRaw?.isNotEmpty}");
    if (photo == null) return;

    final CreatedOffer offer = await ApisMock().createOffer(photo.path);
  }

  void _logout() {
    TextButton cancelButton = TextButton(
      style: styleAdditionalButton(),
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(StringResources.cancel),
    );

    TextButton exitButton = TextButton(
      style: styleSecondaryButton(),
      onPressed: () {
        SharedPrefManager().setStateAuthUser(false);
        Navigator.pop(context);
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (_) => const AuthPage()));
      },
      child: const Text(StringResources.exit),
    );

    AlertDialog alertDialog = AlertDialog(
      title: const Text(StringResources.titleAlertLogout),
      content: const Text(StringResources.messageAlertLogout),
      actions: [cancelButton, exitButton],
    );

    showDialog(context: context, builder: (BuildContext context) => alertDialog);
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    isVisibleFab = false;
    isInitializationState = true;
  }

  void _onLoading() {
    itemsFuture = ApisMock().getListOffers();
    itemsFuture.then((value) {
      setState(() {
        items.addAll(value);
        isVisibleFab = true;
        _refreshController.loadComplete();
        if (value.isEmpty) {
          _refreshController.loadNoData();
        }
      });
    }).catchError((error) {
      errorMessage = error.toString();
      _refreshController.loadFailed();
    });
  }

  void _onRefresh() {
    setState(() {
      items.clear();
      isVisibleFab = false;
      hasError = false;
      hasEmptyOrder = false;
    });
    itemsFuture = ApisMock().getListOffers();
    itemsFuture.then((value) {
      setState(() {
        hasEmptyOrder = value.isEmpty;
        items.addAll(value);
        isVisibleFab = true;
      });
      _refreshController.refreshCompleted();

      if (isInitializationState) {
        FlutterNativeSplash.remove();
        isInitializationState = false;
      }
    }).catchError((error) {
      setState(() {
        hasError = true;
        errorMessage = error.toString();
      });
      _refreshController.refreshFailed();
      if (isInitializationState) {
        FlutterNativeSplash.remove();
        isInitializationState = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget actionExit = Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: GestureDetector(
          onTap: _logout,
          child: const Icon(
            Icons.logout,
            size: 26.0,
          ),
        ));

    return Scaffold(
        appBar: defaultAppBar(actions: [actionExit]),
        floatingActionButton: Visibility(visible: isVisibleFab, child: addFloatingActionButton("AddNewCar", _addNewOffer)),
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return SmartRefresher(
            enablePullDown: true,
            header: const WaterDropHeader(
              waterDropColor: primaryColor,
            ),
            footer: CustomFooter(
              builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = const Text(StringResources.ordersLoaded);
                } else if (mode == LoadStatus.loading) {
                  body = const CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Center(child: Text(errorMessage));
                } else if (mode == LoadStatus.canLoading) {
                  body = const Text("release to load more");
                } else {
                  body = const Text(StringResources.messageEmptyOrder);
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView.builder(
              itemBuilder: (c, i) => showElementList(i),
              itemExtent: (hasError || hasEmptyOrder) ? constraints.maxHeight : 50.0,
              itemCount: (hasError || hasEmptyOrder) ? 1 : items.length,
            ),
          );
        }));
  }

  Widget showElementList(int index) {
    if (hasError) {
      return showErrorScreen(errorMessage);
    } else if (hasEmptyOrder) {
      return showEmptyScreen();
    } else {
      return GestureDetector(
        child: createCardOffer(items[index]),
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (_) => OrderPage(order: items[index])));
        },
      );
    }
  }

  Widget createCardOffer(Offer offer) {
    return Card(
        child: Column(
      children: [
        createWidgetTitleValue("Status:", offer.status),
        const SizedBox(
          height: 5.0,
        ),
        createWidgetTitleValue("Comment:", offer.comment)
      ],
    ));
  }

  Widget showErrorScreen(String error) {
    return Center(
      child: Text(error),
    );
  }

  Widget showEmptyScreen() {
    return const Center(
      child: Text(StringResources.messageEmptyOrder),
    );
  }
}
