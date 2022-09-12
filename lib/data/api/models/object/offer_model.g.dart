// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
      id: json['id'] as int,
      image: json['image'] as String,
      licensePlate: json['licensePlate'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRequestedMedia: json['isRequestedMedia'] as bool,
      managerComment: json['managerComment'] as String?,
      supplierComment: json['supplierComment'] as String?,
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      video: json['video'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      messageStatus: json['messageStatus'] as String,
      idStatus: json['idStatus'] as int,
    );

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'licensePlate': instance.licensePlate,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRequestedMedia': instance.isRequestedMedia,
      'managerComment': instance.managerComment,
      'supplierComment': instance.supplierComment,
      'photos': instance.photos,
      'video': instance.video,
      'price': instance.price,
      'messageStatus': instance.messageStatus,
      'idStatus': instance.idStatus,
    };
