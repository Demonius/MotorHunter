import 'package:json_annotation/json_annotation.dart';

import '../object/offer_model.dart';

part 'offer_model_response.g.dart';

@JsonSerializable()
class OfferResponse {
  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "image", defaultValue: null)
  String? image;

  @JsonKey(name: "license_plate")
  String? licensePlate;

  @JsonKey(name: "created_at", fromJson: _stringToDateTime)
  DateTime createdAt;

  @JsonKey(name: "is_requested_media", defaultValue: 0, fromJson: _intToBool, toJson: _boolToInt)
  bool isRequestedMedia;

  @JsonKey(name: "manager_comment")
  String? managerComment;

  @JsonKey(name: "supplier_comment")
  String? supplierComment;

  @JsonKey(name: "photos", defaultValue: null)
  List<String>? photos;

  @JsonKey(name: "video", defaultValue: null)
  String? video;

  @JsonKey(name: "offer_price", defaultValue: 0.0, fromJson: _stringToDouble, toJson: _doubleToString)
  double? price;

  @JsonKey(name: "api_status_id", defaultValue: 0)
  int apiStatusId;

  @JsonKey(name: "mobile_status")
  int mobileStatus;

  @JsonKey(name: "mobile_status_text")
  String statusMessage;

  @JsonKey(name: "currency")
  String? currency;

  @JsonKey(name: "ui_state", defaultValue: 0, fromJson: _convertToUiState, toJson: _convertFromUiState)
  UiState uiState;

  @JsonKey(name: "color_border")
  String? borderColor;

  OfferResponse(
      {required this.id,
      this.image,
      this.licensePlate,
      required this.createdAt,
      this.managerComment,
      this.supplierComment,
      required this.isRequestedMedia,
      this.photos,
      this.video,
      this.price,
      required this.apiStatusId,
      required this.mobileStatus,
      required this.statusMessage,
      this.currency,
      required this.uiState,
      this.borderColor});

  factory OfferResponse.fromJson(Map<String, dynamic> json) => _$OfferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfferResponseToJson(this);

  static bool _intToBool(int value) => value == 1;

  static bool _stringToBool(String value) => value == "1";

  static int _boolToInt(bool value) => value ? 1 : 0;

  static String _boolToString(bool value) => value ? "1" : "0";

  static double _stringToDouble(String value) => double.tryParse(value) ?? 0.0;

  static String _doubleToString(double? value) => value.toString() ?? "";

  static DateTime _stringToDateTime(String date) => DateTime.parse(date);

  static UiState _convertToUiState(int? state) {
    switch (state) {
      case 1:
        return UiState.notActive;
      case 2:
        return UiState.borderColor;
      default:
        return UiState.basic;
    }
  }

  static int _convertFromUiState(UiState state) {
    switch (state) {
      case UiState.basic:
        return 0;
      case UiState.notActive:
        return 1;
      case UiState.borderColor:
        return 2;
    }
  }
}

@JsonSerializable()
class CreatedOffer {
  // @JsonKey(name: "isActive", fromJson: OfferResponse._intToBool, toJson: OfferResponse._boolToInt)
  // bool isActive;
  // @JsonKey(name: "image")
  // String image;
  // @JsonKey(name: "offer_status_id")
  // int offerStatusId;
  // @JsonKey(name: "api_status_id")
  // int apiStatusId;
  // @JsonKey(name: "supplier_comment", defaultValue: "")
  // String? comment;
  // @JsonKey(name: "supplier_id")
  // int userId;
  // @JsonKey(name: "id")
  // int id;

  @JsonKey(name: "offer_id")
  int offerId;

  CreatedOffer({
    required this.offerId,
    // required this.image,
    // required this.offerStatusId,
    // required this.apiStatusId,
    // this.comment,
    // required this.userId,
    // required this.id
  });

  factory CreatedOffer.fromJson(Map<String, dynamic> json) => _$CreatedOfferFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedOfferToJson(this);
}
