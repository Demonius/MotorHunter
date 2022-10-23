import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motor_hunter/base/dialog_with_photo.dart';
import 'package:motor_hunter/constants/app_constants.dart';
import 'package:motor_hunter/constants/string_constants.dart';
import 'package:motor_hunter/data/api/models/response/error_model.dart';
import 'package:motor_hunter/screens/login_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../base/styles.dart';
import '../base/widgets.dart';
import '../data/api/models/object/offer_model.dart';
import '../data/api/rest_api.dart';
import '../data/clients/mappers.dart';
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

  late Timer timerUpdate;
  final Duration durationUpdate = const Duration(seconds: AppConstants.intervalUpdate);

  int endOfTime = AppConstants.intervalUpdateData;

  void _addNewOffer() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;

    showApplyDialogCreteOffer(photo);
  }

  void showApplyDialogCreteOffer(XFile photo) async {
    String title = StringResources.titleDialogCreateOffer;
    String description = StringResources.messageDialogCreateOffer;
    bool stateApproveResult = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => DialogWithPhoto(title: title, description: description, pathPhoto: photo.path));
    if (stateApproveResult) {
      _onRefresh();
    }
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
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timerUpdate.cancel();
  }

  void startTimer() {
    timerUpdate = Timer.periodic(durationUpdate, (timer) {
      setState(() {
        endOfTime = AppConstants.intervalUpdateData - timer.tick;
      });
      if (timer.tick == AppConstants.intervalUpdateData) {
        timer.cancel();
        setState(() {
          endOfTime = AppConstants.intervalUpdateData;
        });
        _refreshController.requestRefresh();
        startTimer();
      }
    });
  }

  void _onLoading() {
    itemsFuture = Apis().getListOffers();
    itemsFuture.then((value) {
      setState(() {
        items.addAll(value);
        isVisibleFab = true;
        _refreshController.loadComplete();
        if (value.isEmpty) {
          _refreshController.loadNoData();
        }
        startTimer();
      });
    }).catchError((error) {
      catchErrorListOffer(error);
      _refreshController.loadFailed();
    });
  }

  void catchErrorListOffer(DioError error) {
    ErrorModel errorModel = Mappers().mapErrorState(error);
    setState(() {
      hasError = true;
      errorMessage = errorModel.message ?? "";
    });
  }

  void _onRefresh() {
    setState(() {
      hasError = false;
      hasEmptyOrder = false;
      isVisibleFab = false;
    });
    itemsFuture = Apis().getListOffers();
    itemsFuture.then((value) {
      setState(() {
        hasEmptyOrder = value.isEmpty;
        items.clear();
        items.addAll(value);
        isVisibleFab = true;
      });
      _refreshController.refreshCompleted();

      if (isInitializationState) {
        FlutterNativeSplash.remove();
        isInitializationState = false;
      }
    }).catchError((error) {
      catchErrorListOffer(error);
      _refreshController.refreshFailed();
      if (isInitializationState) {
        FlutterNativeSplash.remove();
        isInitializationState = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget actionExit =
        Padding(padding: const EdgeInsets.only(right: 20.0), child: GestureDetector(onTap: _logout, child: const Icon(Icons.logout, size: 26.0)));

    return Scaffold(
        appBar: defaultAppBar(actions: [actionExit]),
        floatingActionButton: Visibility(visible: isVisibleFab, child: addFloatingActionButton("AddNewCar", _addNewOffer)),
        body: Stack(children: [
          Align(
              alignment: Alignment.topRight,
              child: Padding(padding: const EdgeInsets.only(top: 4.0, right: 8.0), child: Text("refresh after $endOfTime s"))),
          Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
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
                    itemExtent: (hasError || hasEmptyOrder) ? constraints.maxHeight : 100.0,
                    itemCount: (hasError || hasEmptyOrder) ? 1 : items.length,
                  ),
                );
              }))
        ]));
  }

  Widget showElementList(int index) {
    if (hasError) {
      return showErrorScreen(errorMessage);
    } else if (hasEmptyOrder) {
      return showEmptyScreen();
    } else {
      return GestureDetector(
        child: createCardOffer(items[index]),
        onTap: () async {
          List<int> listNotOpenId = List.generate(3, (index) {
            switch (index) {
              case 0:
                return 3;
              case 1:
                return 6;
              default:
                return 8;
            }
          });

          if (!listNotOpenId.contains(items[index].idStatus) && items[index].uiState != UiState.notActive) {
            var result = await Navigator.push(context, CupertinoPageRoute(builder: (_) => OrderPage(order: items[index])));
            if (result) {
              _onRefresh();
            }
          }
        },
      );
    }
  }

  Widget createCardOffer(Offer offer) {
    Color borderColor = offer.colorBorder == null ? Colors.transparent : Color(offer.colorBorder!);

    bool isEnabled = offer.uiState != UiState.notActive;
    return Card(
        child: Container(
            decoration: BoxDecoration(border: Border.all(color: borderColor, width: 2), borderRadius: const BorderRadius.all(Radius.circular(4.0))),
            padding: const EdgeInsets.all(4.0),
            child: Row(children: [
              imageFromExternal(offer.image, height: 90.0, isEnabled: isEnabled),
              const SizedBox(width: 12.0),
              Expanded(
                  child: Opacity(
                      opacity: isEnabled ? 1.0 : 0.5,
                      child: Column(
                        children: [
                          createWidgetTitleValue("License plate:", offer.licensePlate),
                          const SizedBox(height: 5.0),
                          createWidgetTitleValue("Status:", offer.messageStatus, colorBorder: offer.colorBorder),
                          const SizedBox(height: 5.0),
                          const Spacer(),
                          Align(alignment: Alignment.bottomRight, child: Text(Mappers().convertDateToString(offer.createdAt)))
                        ],
                      )))
            ])));
  }

  Widget showEmptyScreen() {
    return showTextWithIcon(
        const Icon(
          Icons.hourglass_empty,
          color: primaryColor,
          size: 50.0,
        ),
        StringResources.messageEmptyOrder);
  }
}
