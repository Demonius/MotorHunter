import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: "id")
  int id;
  @JsonKey(name: "role_id")
  int roleId;
  @JsonKey(name: "name")
  String name;
  @JsonKey(name: "email")
  String email;
  @JsonKey(name: "avatar")
  String avatar;
  @JsonKey(name: "status")
  int status;

  User({required this.id, required this.roleId, required this.name, required this.email, required this.avatar, required this.status});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
// "id": 21,
// "role_id": "2",
// "name": "British Motors",
// "email": "user@mail.ru",
// "avatar": "users/January2022/c8XiQ8nyVDhB3D8JPpiu.jpg",
// "email_verified_at": "2022-06-07T14:50:00.000000Z",
// "settings": [],
// "created_at": "2022-01-21T14:29:26.000000Z",
// "updated_at": "2022-06-07T11:50:07.000000Z",
// "status": "2",
// "language_id": "1",
// "working_email": null,
// "phone": null,
// "location": null,
// "company": null,
// "price_group_id": "2",
// "assignments": "[]",
// "offer_lifetime": "2"
// }
