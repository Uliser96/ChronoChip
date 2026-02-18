import 'dart:convert';

import 'data.dart';

class GenderResponse {
  String? message;
  Data? data;

  GenderResponse({this.message, this.data});

  @override
  String toString() => 'GenderResponse(message: $message, data: $data)';

  factory GenderResponse.fromMap(Map<String, dynamic> data) {
    return GenderResponse(
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {'message': message, 'data': data?.toMap()};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [GenderResponse].
  factory GenderResponse.fromJson(String data) {
    return GenderResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [GenderResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  GenderResponse copyWith({String? message, Data? data}) {
    return GenderResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
