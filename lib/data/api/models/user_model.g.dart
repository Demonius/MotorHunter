// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      roleId: json['role_id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      status: json['status'] as int,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'role_id': instance.roleId,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'status': instance.status,
    };
