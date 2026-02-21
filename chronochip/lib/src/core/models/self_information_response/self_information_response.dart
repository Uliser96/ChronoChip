import 'dart:convert';

import 'data.dart';

class SelfInformationResponse {
  String? message;
  Data? data;

  SelfInformationResponse({this.message, this.data});

  @override
  String toString() {
    return 'SelfInformationResponse(message: $message, data: $data)';
  }

  factory SelfInformationResponse.fromMap(Map<String, dynamic> data) {
    return SelfInformationResponse(
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {'message': message, 'data': data?.toMap()};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SelfInformationResponse].
  factory SelfInformationResponse.fromJson(String data) {
    return SelfInformationResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [SelfInformationResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  SelfInformationResponse copyWith({String? message, Data? data}) {
    return SelfInformationResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
