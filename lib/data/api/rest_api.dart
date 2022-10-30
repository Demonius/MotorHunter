import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:motor_hunter/data/api/models/response/offer_model_response.dart';
import 'package:motor_hunter/data/clients/mappers.dart';
import 'package:motor_hunter/managers/shared_pref_manager.dart';

import '../clients/api_clients.dart';
import 'models/object/offer_model.dart';
import 'models/response/approve_offer.dart';
import 'models/response/user_model.dart';

const String AUTH_BEREAR = "Authorization";

class Apis {
  static const String login = "supplier/login";
  static const String offers = "offer/get";
  static const String offer = "offer/getOne";
  static const String create = "offer/create";
  static const String update = "offer/update";
  static const String price_approve = "offer/approve";

  static const int timeout = 90000;

  static late BaseOptions baseOptions;
  static late Dio dio;
  static late ApiClient client;
  static SharedPrefManager prefManager = SharedPrefManager();

  static void initBaseService() async {
    baseOptions = BaseOptions(contentType: "application/json", followRedirects: true, connectTimeout: timeout, receiveTimeout: timeout);
    dio = Dio(baseOptions);
    dio.interceptors.add(DioLoggingInterceptor(level: Level.body, compact: false));
    dio.interceptors.add(MotorHunterInterceptor());
    client = ApiClient(dio);
  }

  Future<User> loginUser(String email, String password) {
    return client.authenticateUser(email, password).then((User user) {
      var stringBufferAuthorization = StringBuffer();
      stringBufferAuthorization.write(user.tokenType);
      stringBufferAuthorization.write(" ");
      stringBufferAuthorization.write(user.token);
      var barear = stringBufferAuthorization.toString();
      prefManager.saveAuthorization(barear);
      prefManager.setStateAuthUser(true);
      prefManager.setUserId(user.id);
      return user;
    });
  }

  Future<List<Offer>> getListOffers() {
    return prefManager.getCurrentUserId().then((int userId) =>
        client.getListOffers(userId).then((List<OfferResponse> value) => value.map((offerResponse) => Mappers().mapOffers(offerResponse)).toList()));
  }

  Future<OfferResponse> getOffer(int offerId) => prefManager.getCurrentUserId().then((int userId) => client.getOffer(offerId, userId));

  Future<CreatedOffer> createOffer(String filePath, String description) {
    Uri uri = Uri.file(filePath);
    File file = File.fromUri(uri);
    return prefManager.getCurrentUserId().then((int userId) => client.createOffer(userId, file, description));
  }

  Future<ApproveOffer> approveOfferPrice(int offerId, String newPrice, String comment) => client.approveOfferPrice(offerId, newPrice, comment);
}

class MotorHunterInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    SharedPrefManager prefManager = SharedPrefManager();
    String auth = await prefManager.getAuthorization();

    options.headers.addAll({AUTH_BEREAR: auth});

    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}
