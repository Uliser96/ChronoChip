import 'dart:convert';

import 'datum.dart';

class StatesResponse {
  String? message;
  List<Datum>? data;

  StatesResponse({this.message, this.data});

  @override
  String toString() => 'StatesResponse(message: $message, data: $data)';

  factory StatesResponse.fromMap(Map<String, dynamic> data) {
    return StatesResponse(
      message: data['message'] as String?,
      data: (data['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'message': message,
    'data': data?.map((e) => e.toMap()).toList(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [StatesResponse].
  factory StatesResponse.fromJson(String data) {
    return StatesResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [StatesResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  StatesResponse copyWith({String? message, List<Datum>? data}) {
    return StatesResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
