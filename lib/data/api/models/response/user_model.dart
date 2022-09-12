import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "supplier_id")
  int id;
  @JsonKey(name: "token_type")
  String tokenType;
  @JsonKey(name: "token")
  String token;

  User({required this.id, required this.tokenType, required this.token});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
