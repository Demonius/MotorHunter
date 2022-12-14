import 'package:json_annotation/json_annotation.dart';

part 'offer_model.g.dart';

@JsonSerializable()
class Offer {
  int id;
  String image;
  String licensePlate;
  DateTime createdAt;
  bool isRequestedMedia;
  String? managerComment;
  String? supplierComment;
  List<String>? photos;
  String? video;
  double? price;
  String messageStatus;
  int idStatus;
  UiState uiState;
  int? colorBorder;
  String? currency;

  Offer(
      {required this.id,
      required this.image,
      required this.licensePlate,
      required this.createdAt,
      required this.isRequestedMedia,
      this.managerComment,
      this.supplierComment,
      this.photos,
      this.video,
      this.price,
      required this.messageStatus,
      required this.idStatus,
      this.uiState = UiState.basic,
      this.colorBorder,
      this.currency});

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  Map<String, dynamic> toJson() => _$OfferToJson(this);
}

enum UiState {
  basic,
  notActive,
  borderColor;
}
