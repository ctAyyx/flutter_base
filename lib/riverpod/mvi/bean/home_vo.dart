import 'package:json_annotation/json_annotation.dart';

part 'home_vo.g.dart';

@JsonSerializable()
class HomeVo {
  final int applyState;
  final String appVersion;

  HomeVo({required this.applyState, required this.appVersion});

  factory HomeVo.fromJson(Map<String, dynamic> json) => _$HomeVoFromJson(json);
}
