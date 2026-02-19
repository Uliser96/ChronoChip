import 'dart:convert';

import 'data.dart';

class RaceRegistrationResponse {
  String? message;
  Data? data;

  RaceRegistrationResponse({this.message, this.data});

  @override
  String toString() {
    return 'RaceRegistrationResponse(message: $message, data: $data)';
  }

  factory RaceRegistrationResponse.fromMap(Map<String, dynamic> data) {
    return RaceRegistrationResponse(
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {'message': message, 'data': data?.toMap()};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RaceRegistrationResponse].
  factory RaceRegistrationResponse.fromJson(String data) {
    return RaceRegistrationResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [RaceRegistrationResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  RaceRegistrationResponse copyWith({String? message, Data? data}) {
    return RaceRegistrationResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
