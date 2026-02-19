import 'dart:convert';

import 'data.dart';

class PaymentPreferenceResponse {
  String? message;
  Data? data;

  PaymentPreferenceResponse({this.message, this.data});

  @override
  String toString() {
    return 'PaymentPreferenceResponse(message: $message, data: $data)';
  }

  factory PaymentPreferenceResponse.fromMap(Map<String, dynamic> data) {
    return PaymentPreferenceResponse(
      message: data['message'] as String?,
      data: data['data'] == null
          ? null
          : Data.fromMap(data['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {'message': message, 'data': data?.toMap()};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PaymentPreferenceResponse].
  factory PaymentPreferenceResponse.fromJson(String data) {
    return PaymentPreferenceResponse.fromMap(
      json.decode(data) as Map<String, dynamic>,
    );
  }

  /// `dart:convert`
  ///
  /// Converts [PaymentPreferenceResponse] to a JSON string.
  String toJson() => json.encode(toMap());

  PaymentPreferenceResponse copyWith({String? message, Data? data}) {
    return PaymentPreferenceResponse(
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }
}
