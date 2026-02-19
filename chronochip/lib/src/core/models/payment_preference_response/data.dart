import 'dart:convert';

class Data {
  String? paymentUrl;
  String? preferenceId;

  Data({this.paymentUrl, this.preferenceId});

  @override
  String toString() {
    return 'Data(paymentUrl: $paymentUrl, preferenceId: $preferenceId)';
  }

  factory Data.fromMap(Map<String, dynamic> data) => Data(
    paymentUrl: data['paymentUrl'] as String?,
    preferenceId: data['preferenceId'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'paymentUrl': paymentUrl,
    'preferenceId': preferenceId,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());

  Data copyWith({String? paymentUrl, String? preferenceId}) {
    return Data(
      paymentUrl: paymentUrl ?? this.paymentUrl,
      preferenceId: preferenceId ?? this.preferenceId,
    );
  }
}
