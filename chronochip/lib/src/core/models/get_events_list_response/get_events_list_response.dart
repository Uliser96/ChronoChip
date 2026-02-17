import 'dart:convert';

import 'data.dart';

class GetEventsListResponse {
  String? message;
  Data? data;

  GetEventsListResponse({this.message, this.data});

  @override
  String toString() {
    return 'GetEventsListResponse(message: $message, data: $data)';
  }

  factory GetEventsListResponse.fromMap(Map<String, dynamic> data) {
    return GetEventsListResponse(
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {'message': message, 'data': data?.toMap()};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GetEventsListResponse].
  factory GetEventsListResponse.fromJson(String data) {
    return GetEventsListResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [GetEventsListResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  GetEventsListResponse copyWith({String? message, Data? data}) {
    return GetEventsListResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
