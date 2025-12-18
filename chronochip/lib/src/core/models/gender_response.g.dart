// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gender_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenderResponse _$GenderResponseFromJson(Map<String, dynamic> json) =>
    GenderResponse(
      message: json['message'] as String,
      data: GenderData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GenderResponseToJson(GenderResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

GenderData _$GenderDataFromJson(Map<String, dynamic> json) => GenderData(
  rows: (json['rows'] as List<dynamic>)
      .map((e) => Gender.fromJson(e as Map<String, dynamic>))
      .toList(),
  paginator: Paginator.fromJson(json['paginator'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GenderDataToJson(GenderData instance) =>
    <String, dynamic>{'rows': instance.rows, 'paginator': instance.paginator};

Gender _$GenderFromJson(Map<String, dynamic> json) => Gender(
  code: json['code'] as String,
  name: json['name'] as String,
  id: json['id'] as int,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$GenderToJson(Gender instance) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
  'id': instance.id,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};

Paginator _$PaginatorFromJson(Map<String, dynamic> json) => Paginator(
  currentPage: json['currentPage'] as int,
  pageSize: json['pageSize'] as int,
  totalRecords: json['totalRecords'] as int,
);

Map<String, dynamic> _$PaginatorToJson(Paginator instance) => <String, dynamic>{
  'currentPage': instance.currentPage,
  'pageSize': instance.pageSize,
  'totalRecords': instance.totalRecords,
};
