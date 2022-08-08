import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../api/models/offer_model.dart';
import '../api/models/user_model.dart';
import '../api/rest_api.dart';

part 'api_clients.g.dart';

@RestApi(baseUrl: "https://api.motor-hunter.com/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @FormUrlEncoded()
  @POST(Apis.login)
  Future<User> authenticateUser(@Field('email') String email, @Field("password") String password);

  @FormUrlEncoded()
  @POST(Apis.offers)
  Future<List<Offer>> getListOffers(@Field("suppler_id") int userId);

  @FormUrlEncoded()
  @POST(Apis.offer)
  Future<Offer> getOffer(@Field("offer_id") int offerId, @Field("supplier_id") int userId);

  @MultiPart()
  @POST(Apis.create)
  Future<CreatedOffer> createOffer(@Part(name: "supplier_id") int userId,
      @Part(name: "license_plate") File uploadFile);
}
