import 'package:json_annotation/json_annotation.dart';

part 'option_item.g.dart';

@JsonSerializable()
class OptionItem {
  final String id;
  final String title;
  final bool isSelected;

  OptionItem({required this.id, required this.title, required this.isSelected});

  factory OptionItem.fromJson(Map<String, dynamic> json) =>
      _$OptionItemFromJson(json);

  Map<String, dynamic> toJson() => _$OptionItemToJson(this);

  OptionItem copyWith({String? id, String? title, bool? isSelected}) {
    return OptionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
