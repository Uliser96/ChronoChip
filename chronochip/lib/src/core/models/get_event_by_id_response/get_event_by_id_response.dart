import 'dart:convert';

import 'data.dart';

class GetEventByIdResponse {
  String? message;
  Data? data;

  GetEventByIdResponse({this.message, this.data});

  @override
  String toString() {
    return 'GetEventByIdResponse(message: $message, data: $data)';
  }

  factory GetEventByIdResponse.fromMap(Map<String, dynamic> data) {
    return GetEventByIdResponse(
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {'message': message, 'data': data?.toMap()};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetEventByIdResponse].
  factory GetEventByIdResponse.fromJson(String data) {
    return GetEventByIdResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [GetEventByIdResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  GetEventByIdResponse copyWith({String? message, Data? data}) {
    return GetEventByIdResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
