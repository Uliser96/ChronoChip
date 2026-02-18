import 'dart:convert';

class Row {
  String? code;
  String? name;
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;

  Row({this.code, this.name, this.id, this.createdAt, this.updatedAt});

  @override
  String toString() {
    return 'Row(code: $code, name: $name, id: $id, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Row.fromMap(Map<String, dynamic> data) => Row(
    code: data['code'] as String?,
    name: data['name'] as String?,
    id: data['id'] as int?,
    createdAt: data['createdAt'] == null
        ? null
        : DateTime.parse(data['createdAt'] as String),
    updatedAt: data['updatedAt'] == null
        ? null
        : DateTime.parse(data['updatedAt'] as String),
  );

  Map<String, dynamic> toMap() => {
    'code': code,
    'name': name,
    'id': id,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Row].
  factory Row.fromJson(String data) {
    return Row.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Row] to a JSON string.
  String toJson() => json.encode(toMap());

  Row copyWith({
    String? code,
    String? name,
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Row(
      code: code ?? this.code,
      name: name ?? this.name,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
