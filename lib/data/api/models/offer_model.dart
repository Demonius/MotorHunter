import 'package:json_annotation/json_annotation.dart';

part 'offer_model.g.dart';
/**
    {
    "status": "reserved",
    "comment": "give new photo pls",
    "is_requested_media": "1",
    "has_media": 1,
    "photos": "[\"\\/images\\/offers\\/offer_image_upload_16576338970.jpg\",\"\\/images\\/offers\\/offer_image_upload_16576338971.jpg\"]",
    "video": "/images/offers/offer_video_1657633897.mp4",
    "price": "210.00"
    }
 */

@JsonSerializable()
class Offer {
  @JsonKey(name: "id")
  int id;

  @JsonKey(name: "status")
  String status;

  @JsonKey(name: "comment")
  String comment;

  @JsonKey(name: "is_requested_media", fromJson: _stringToBool, toJson: _boolToString)
  bool isRequestedMedia;

  @JsonKey(name: "has_media", fromJson: _intToBool, toJson: _boolToInt)
  bool hasMedia;

  @JsonKey(name: "photos", defaultValue: null)
  List<String>? photos;

  @JsonKey(name: "video", defaultValue: null)
  String? video;

  @JsonKey(name: "price", defaultValue: 0.0, fromJson: _stringToDouble, toJson: _doubleToString)
  double? price;

  Offer(
      {required this.id,
      required this.status,
      required this.comment,
      required this.isRequestedMedia,
      required this.hasMedia,
      this.photos,
      this.video,
      this.price});

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);

  static bool _intToBool(int value) => value == 1;

  static bool _stringToBool(String value) => value == "1";

  static int _boolToInt(bool value) => value ? 1 : 0;

  static String _boolToString(bool value) => value ? "1" : "0";

  static double _stringToDouble(String value) => double.tryParse(value) ?? 0.0;

  static String _doubleToString(double? value) => value.toString() ?? "";
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
  @JsonKey(name: "isActive", fromJson: Offer._intToBool, toJson: Offer._boolToInt)
  bool isActive;
  @JsonKey(name: "image")
  String image;
  @JsonKey(name: "offer_status_id")
  int offerStatusId;
  @JsonKey(name: "api_status_id")
  int apiStatusId;
  @JsonKey(name: "supplier_comment", defaultValue: "")
  String? comment;
  @JsonKey(name: "supplier_id")
  int userId;
  @JsonKey(name: "id")
  int id;

  CreatedOffer(
      {required this.isActive,
      required this.image,
      required this.offerStatusId,
      required this.apiStatusId,
      this.comment,
      required this.userId,
      required this.id});

  factory CreatedOffer.fromJson(Map<String, dynamic> json) => _$CreatedOfferFromJson(json);

  Map<String, dynamic> toJson() => _$CreatedOfferToJson(this);
}
