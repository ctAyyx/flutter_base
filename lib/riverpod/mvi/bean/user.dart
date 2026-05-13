import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';
@JsonSerializable()
class UserVo {
  final String phone;
  final String pwd;

  UserVo({required this.phone, required this.pwd});

  factory UserVo.fromJson(Map<String, dynamic> json) => _$UserVoFromJson(json);
}
