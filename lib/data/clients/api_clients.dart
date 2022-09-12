import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

import '../api/models/response/approve_offer.dart';
import '../api/models/response/offer_model_response.dart';
import '../api/models/response/user_model.dart';
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
  Future<List<OfferResponse>> getListOffers(@Field("suppler_id") int userId);

  @FormUrlEncoded()
  @POST(Apis.offer)
  Future<OfferResponse> getOffer(@Field("offer_id") int offerId, @Field("supplier_id") int userId);

  @MultiPart()
  @POST(Apis.create)
  Future<CreatedOffer> createOffer(
      @Part(name: "supplier_id") int userId, @Part(name: "license_plate") File uploadFile, @Part(name: "supplier_comment") String description);

  @FormUrlEncoded()
  @POST(Apis.price_approve)
  Future<ApproveOffer> approveOfferPrice(@Field("offer_id") int offerId, @Field("approve") int approve, @Field("supplier_comment") String comment);
}
