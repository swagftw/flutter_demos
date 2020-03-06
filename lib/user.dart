import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final String address;
  final String phoneNo;

  User({this.id,this.phoneNo,this.address,this.name});

  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
  Map<String,dynamic> toJson()=> _$UserToJson(this);
}

