import 'dart:convert';

class State {
  int? id;
  String? name;
  String? code;

  State({this.id, this.name, this.code});

  @override
  String toString() => 'State(id: $id, name: $name, code: $code)';

  factory State.fromMap(Map<String, dynamic> data) {
    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return State(
      id: _toInt(data['id']),
      name: data['name'] as String?,
      code: data['code'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'code': code};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [State].
  factory State.fromJson(String data) {
    return State.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [State] to a JSON string.
  String toJson() => json.encode(toMap());

  State copyWith({int? id, String? name, String? code}) {
    return State(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
    );
  }
}
