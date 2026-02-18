import 'dart:convert';

import 'datum.dart';

class CategoriesFilterResponse {
  String? message;
  List<Datum>? data;

  CategoriesFilterResponse({this.message, this.data});

  @override
  String toString() {
    return 'CategoriesFilterResponse(message: $message, data: $data)';
  }

  factory CategoriesFilterResponse.fromMap(Map<String, dynamic> data) {
    return CategoriesFilterResponse(
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
  /// Parses the string and returns the resulting Json object as [CategoriesFilterResponse].
  factory CategoriesFilterResponse.fromJson(String data) {
    return CategoriesFilterResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [CategoriesFilterResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  CategoriesFilterResponse copyWith({String? message, List<Datum>? data}) {
    return CategoriesFilterResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
