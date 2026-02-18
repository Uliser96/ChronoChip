import 'dart:convert';

import 'tshirt_size.dart';

class Datum {
  int? id;
  TshirtSize? tshirtSize;
  int? genderId;
  String? genderName;

  Datum({this.id, this.tshirtSize, this.genderId, this.genderName});

  @override
  String toString() {
    return 'Datum(id: $id, tshirtSize: $tshirtSize, genderId: $genderId, genderName: $genderName)';
  }

  factory Datum.fromMap(Map<String, dynamic> data) => Datum(
    id: data['id'] as int?,
    tshirtSize: data['tshirtSize'] == null
        ? null
        : TshirtSize.fromMap(data['tshirtSize'] as Map<String, dynamic>),
    genderId: data['genderId'] as int?,
    genderName: data['genderName'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'tshirtSize': tshirtSize?.toMap(),
    'genderId': genderId,
    'genderName': genderName,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Datum].
  factory Datum.fromJson(String data) {
    return Datum.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Datum] to a JSON string.
  String toJson() => json.encode(toMap());

  Datum copyWith({
    int? id,
    TshirtSize? tshirtSize,
    int? genderId,
    String? genderName,
  }) {
    return Datum(
      id: id ?? this.id,
      tshirtSize: tshirtSize ?? this.tshirtSize,
      genderId: genderId ?? this.genderId,
      genderName: genderName ?? this.genderName,
    );
  }
}
