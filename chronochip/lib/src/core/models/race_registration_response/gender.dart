import 'dart:convert';

class Gender {
  int? id;
  String? code;
  String? name;

  Gender({this.id, this.code, this.name});

  @override
  String toString() => 'Gender(id: $id, code: $code, name: $name)';

  factory Gender.fromMap(Map<String, dynamic> data) {
    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return Gender(
      id: _toInt(data['id']),
      code: data['code'] as String?,
      name: data['name'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'code': code, 'name': name};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Gender].
  factory Gender.fromJson(String data) {
    return Gender.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Gender] to a JSON string.
  String toJson() => json.encode(toMap());

  Gender copyWith({int? id, String? code, String? name}) {
    return Gender(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
    );
  }
}
