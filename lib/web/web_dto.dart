import 'package:json_annotation/json_annotation.dart';

part 'web_dto.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class JsResponseVo<T> {
  @JsonKey(name: "identifer")
  String? iden;
  @JsonKey(name: "status")
  bool? status;
  @JsonKey(name: "data")
  T? data;
  @JsonKey(name: "errorMessage")
  String? errorMessage;

  JsResponseVo({this.iden, this.data, this.status, this.errorMessage});

  factory JsResponseVo.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$JsResponseVoFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$JsResponseVoToJson(this, toJsonT);
}
