// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferResponse _$OfferResponseFromJson(Map<String, dynamic> json) =>
    OfferResponse(
      id: json['id'] as int,
      image: json['image'] as String?,
      licensePlate: json['license_plate'] as String?,
      createdAt: OfferResponse._stringToDateTime(json['created_at'] as String),
      managerComment: json['manager_comment'] as String?,
      supplierComment: json['supplier_comment'] as String?,
      isRequestedMedia:
          OfferResponse._intToBool(json['is_requested_media'] as int),
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      video: json['video'] as String?,
      price: json['offer_price'] == null
          ? 0.0
          : OfferResponse._stringToDouble(json['offer_price'] as String),
      apiStatusId: json['api_status_id'] as int,
      mobileStatus: json['mobile_status'] as int,
      statusMessage: json['mobile_status_text'] as String,
    );

Map<String, dynamic> _$OfferResponseToJson(OfferResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'license_plate': instance.licensePlate,
      'created_at': instance.createdAt.toIso8601String(),
      'is_requested_media': OfferResponse._boolToInt(instance.isRequestedMedia),
      'manager_comment': instance.managerComment,
      'supplier_comment': instance.supplierComment,
      'photos': instance.photos,
      'video': instance.video,
      'offer_price': OfferResponse._doubleToString(instance.price),
      'api_status_id': instance.apiStatusId,
      'mobile_status': instance.mobileStatus,
      'mobile_status_text': instance.statusMessage,
    };

CreatedOffer _$CreatedOfferFromJson(Map<String, dynamic> json) => CreatedOffer(
      offerId: json['offer_id'] as int,
    );

Map<String, dynamic> _$CreatedOfferToJson(CreatedOffer instance) =>
    <String, dynamic>{
      'offer_id': instance.offerId,
    };
