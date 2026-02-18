import 'dart:convert';

import 'datum.dart';

class TshirtSizesResponse {
  String? message;
  List<Datum>? data;

  TshirtSizesResponse({this.message, this.data});

  @override
  String toString() => 'TshirtSizesResponse(message: $message, data: $data)';

  factory TshirtSizesResponse.fromMap(Map<String, dynamic> data) {
    return TshirtSizesResponse(
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
  /// Parses the string and returns the resulting Json object as [TshirtSizesResponse].
  factory TshirtSizesResponse.fromJson(String data) {
    return TshirtSizesResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [TshirtSizesResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  TshirtSizesResponse copyWith({String? message, List<Datum>? data}) {
    return TshirtSizesResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
