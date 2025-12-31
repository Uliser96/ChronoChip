import 'package:json_annotation/json_annotation.dart';

part 'tshirt_size.g.dart';

@JsonSerializable()
class TShirtSize {
  final int id;
  final String sizeEs;
  final String sizeEn;
  final String description;

  TShirtSize({
    required this.id,
    required this.sizeEs,
    required this.sizeEn,
    required this.description,
  });

  factory TShirtSize.fromJson(Map<String, dynamic> json) =>
      _$TShirtSizeFromJson(json);

  Map<String, dynamic> toJson() => _$TShirtSizeToJson(this);
}
