import 'package:json_annotation/json_annotation.dart';

part 'gender_response.g.dart';

@JsonSerializable()
class GenderResponse {
  final String message;
  final GenderData data;

  GenderResponse({required this.message, required this.data});

  factory GenderResponse.fromJson(Map<String, dynamic> json) =>
      _$GenderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GenderResponseToJson(this);
}

@JsonSerializable()
class GenderData {
  final List<Gender> rows;
  final Paginator paginator;

  GenderData({required this.rows, required this.paginator});

  factory GenderData.fromJson(Map<String, dynamic> json) =>
      _$GenderDataFromJson(json);

  Map<String, dynamic> toJson() => _$GenderDataToJson(this);
}

@JsonSerializable()
class Gender {
  final String code;
  final String name;
  final int id;
  final String createdAt;
  final String updatedAt;

  Gender({
    required this.code,
    required this.name,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Gender.fromJson(Map<String, dynamic> json) => _$GenderFromJson(json);

  Map<String, dynamic> toJson() => _$GenderToJson(this);
}

@JsonSerializable()
class Paginator {
  final int currentPage;
  final int pageSize;
  final int totalRecords;

  Paginator({
    required this.currentPage,
    required this.pageSize,
    required this.totalRecords,
  });

  factory Paginator.fromJson(Map<String, dynamic> json) =>
      _$PaginatorFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatorToJson(this);
}
