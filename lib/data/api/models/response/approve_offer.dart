import 'package:json_annotation/json_annotation.dart';
import 'package:motor_hunter/data/api/models/response/error_model.dart';

part 'approve_offer.g.dart';
/**
 * {
    "id": 119,
    "is_requested_media": 0,
    "photos": [],
    "video": "https://api.motor-hunter.com/",
    "status": "price_declined",
    "comment": null,
    "has_media": 1,
    "mobile_status": 1,
    "mobile_status_text": "Order in process"
    }
 */

@JsonSerializable()
class ApproveOffer {
  @JsonKey(name: "id")
  int id;

  ApproveOffer({required this.id});

  factory ApproveOffer.fromJson(Map<String, dynamic> json) => _$ApproveOfferFromJson(json);

  Map<String, dynamic> toJson() => _$ApproveOfferToJson(this);
}
