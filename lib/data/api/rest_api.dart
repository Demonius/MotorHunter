import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:motor_hunter/data/api/models/offer_model.dart';
import 'package:motor_hunter/managers/shared_pref_manager.dart';

import '../clients/api_clients.dart';
import 'models/user_model.dart';

class Apis {
  static const String login = "supplier/login";
  static const String offers = "offer/get";
  static const String offer = "offer/getOne";
  static const String create = "offer/create";
  static const String update = "offer/update";

  static final BaseOptions baseOptions =
      BaseOptions(contentType: "application/json", followRedirects: true, connectTimeout: 9000, receiveTimeout: 9000);
  static final Dio dio = Dio(baseOptions);
  final client = ApiClient(dio);
  final SharedPrefManager prefManager = SharedPrefManager();

  Future<User> loginUser(String email, String password) => client.authenticateUser(email, password).then((User user) {
        prefManager.setStateAuthUser(true);
        prefManager.setUserId(user.id);
        return user;
      });

  Future<List<Offer>> getOffers() => prefManager.getCurrentUserId().then((int userId) => client.getListOffers(userId));

  Future<Offer> getOffer(int offerId) => prefManager.getCurrentUserId().then((int userId) => client.getOffer(offerId, userId));

  Future<CreatedOffer> createOffer(String filePath) {
    Uri uri = Uri.file(filePath);
    File file = File.fromUri(uri);
    return prefManager.getCurrentUserId().then((int userId) => client.createOffer(userId, file));
  }
}

class ApisMock {
  static const Duration duration = Duration(seconds: 2);
  final SharedPrefManager prefManager = SharedPrefManager();

  Future<User> loginUser(String email, String password) => Future.delayed(const Duration(seconds: 2), () {
        return Future<User>.value(User(id: 1, roleId: 1, name: "UserMock", email: email, avatar: "", status: 1));
      }).then((User user) {
        prefManager.setStateAuthUser(true);
        prefManager.setUserId(user.id);
        return user;
      });

  Future<List<String>> getErrorListOffers() => Future.error("Error loading order");

  Future<List<Offer>> getListOffers() => Future.delayed(duration, () {
        List<Offer> listOffer = List.generate(
            3, (index) => Offer(id: 100, status: "new", comment: "index => $index", isRequestedMedia: false, hasMedia: false, price: index * 2.0));
        return Future<List<Offer>>.value(listOffer);
      });

  Future<CreatedOffer> createOffer(String filePath) {
    Uri uri = Uri.file(filePath);
    File file = File.fromUri(uri);
    return Future<CreatedOffer>.value(
        CreatedOffer(isActive: true, image: "", offerStatusId: 3, apiStatusId: 1, comment: "new offer", userId: 1, id: 12));
  }
}
