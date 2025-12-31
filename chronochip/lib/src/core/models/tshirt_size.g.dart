// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tshirt_size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TShirtSize _$TShirtSizeFromJson(Map<String, dynamic> json) => TShirtSize(
  id: json['id'] as int,
  sizeEs: json['sizeEs'] as String,
  sizeEn: json['sizeEn'] as String,
  description: json['description'] as String,
);

Map<String, dynamic> _$TShirtSizeToJson(TShirtSize instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sizeEs': instance.sizeEs,
      'sizeEn': instance.sizeEn,
      'description': instance.description,
    };
