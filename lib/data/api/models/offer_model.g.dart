// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
      id: json['id'] as int,
      status: json['status'] as String,
      comment: json['comment'] as String,
      isRequestedMedia:
          Offer._stringToBool(json['is_requested_media'] as String),
      hasMedia: Offer._intToBool(json['has_media'] as int),
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      video: json['video'] as String?,
      price: json['price'] == null
          ? 0.0
          : Offer._stringToDouble(json['price'] as String),
    );

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'comment': instance.comment,
      'is_requested_media': Offer._boolToString(instance.isRequestedMedia),
      'has_media': Offer._boolToInt(instance.hasMedia),
      'photos': instance.photos,
      'video': instance.video,
      'price': Offer._doubleToString(instance.price),
    };

CreatedOffer _$CreatedOfferFromJson(Map<String, dynamic> json) => CreatedOffer(
      isActive: Offer._intToBool(json['isActive'] as int),
      image: json['image'] as String,
      offerStatusId: json['offer_status_id'] as int,
      apiStatusId: json['api_status_id'] as int,
      comment: json['supplier_comment'] as String? ?? '',
      userId: json['supplier_id'] as int,
      id: json['id'] as int,
    );

Map<String, dynamic> _$CreatedOfferToJson(CreatedOffer instance) =>
    <String, dynamic>{
      'isActive': Offer._boolToInt(instance.isActive),
      'image': instance.image,
      'offer_status_id': instance.offerStatusId,
      'api_status_id': instance.apiStatusId,
      'supplier_comment': instance.comment,
      'supplier_id': instance.userId,
      'id': instance.id,
    };
