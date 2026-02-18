import 'dart:convert';

class Datum {
  int? id;
  String? name;
  String? code;

  Datum({this.id, this.name, this.code});

  @override
  String toString() => 'Datum(id: $id, name: $name, code: $code)';

  factory Datum.fromMap(Map<String, dynamic> data) => Datum(
    id: data['id'] as int?,
    name: data['name'] as String?,
    code: data['code'] as String?,
  );

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'code': code};

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

  Datum copyWith({int? id, String? name, String? code}) {
    return Datum(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }
}
