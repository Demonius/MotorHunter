// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['supplier_id'] as int,
      tokenType: json['token_type'] as String,
      token: json['token'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'supplier_id': instance.id,
      'token_type': instance.tokenType,
      'token': instance.token,
    };
