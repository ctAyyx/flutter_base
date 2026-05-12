import 'package:json_annotation/json_annotation.dart';

part 'base_resp.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponse<T> {
  @JsonKey(name: "data")
  final T? data;
  @JsonKey(name: "msg")
  final String? msg;
  @JsonKey(name: "code")
  final int? code;

  BaseResponse({this.data, this.msg, this.code});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$BaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseToJson(this, toJsonT);
}
