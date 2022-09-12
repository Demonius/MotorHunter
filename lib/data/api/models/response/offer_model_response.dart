import 'package:json_annotation/json_annotation.dart';
import 'package:motor_hunter/data/api/models/response/error_model.dart';

part 'offer_model_response.g.dart';
/**
    {
    "id": 81,
    "image": "https://api.motor-hunter.com/images/offers/offer_1653653350.jpg",
    "license_plate": "ya55fbe",
    "created_at": "2022-05-27T12:09:10.000000Z",
    "offer_price": "299.00",
    "api_status_id": 15,
    "manager_comment": null,
    "supplier_comment": null,
    "is_requested_media": 0,
    "photos": "[\"\\/images\\/offers\\/offer_image_upload_16612569870.jpg\"]",
    "video": "/images/offers/offer_video_1657632604.mp4"
    "mobile_status": 5,
    "mobile_status_text": "Placed for sale"
    }
 */

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

  @JsonKey(name: "is_requested_media", fromJson: _intToBool, toJson: _boolToInt)
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

  @JsonKey(name: "api_status_id")
  int apiStatusId;

  @JsonKey(name: "mobile_status")
  int mobileStatus;

  @JsonKey(name: "mobile_status_text")
  String statusMessage;

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
      required this.statusMessage});

  factory OfferResponse.fromJson(Map<String, dynamic> json) => _$OfferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OfferResponseToJson(this);

  static bool _intToBool(int value) => value == 1;

  static bool _stringToBool(String value) => value == "1";

  static int _boolToInt(bool value) => value ? 1 : 0;

  static String _boolToString(bool value) => value ? "1" : "0";

  static double _stringToDouble(String value) => double.tryParse(value) ?? 0.0;

  static String _doubleToString(double? value) => value.toString() ?? "";

  static DateTime _stringToDateTime(String date) => DateTime.parse(date);
}

/**
    {
    "is_active": 1,
    "image": "/images/offers/offer_1659102225.jpg",
    "offer_status_id": 1,
    "api_status_id": 5,
    "supplier_comment": null,
    "supplier_id": "21",
    "updated_at": "2022-07-29T13:43:45.000000Z",
    "created_at": "2022-07-29T13:43:45.000000Z",
    "id": 98
    }
 */
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
