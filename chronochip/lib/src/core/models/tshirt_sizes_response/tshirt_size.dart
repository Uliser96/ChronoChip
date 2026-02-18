import 'dart:convert';

class TshirtSize {
  int? id;
  String? sizeEs;
  String? sizeEn;
  String? description;

  TshirtSize({this.id, this.sizeEs, this.sizeEn, this.description});

  @override
  String toString() {
    return 'TshirtSize(id: $id, sizeEs: $sizeEs, sizeEn: $sizeEn, description: $description)';
  }

  factory TshirtSize.fromMap(Map<String, dynamic> data) => TshirtSize(
    id: data['id'] as int?,
    sizeEs: data['sizeEs'] as String?,
    sizeEn: data['sizeEn'] as String?,
    description: data['description'] as String?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'sizeEs': sizeEs,
    'sizeEn': sizeEn,
    'description': description,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [TshirtSize].
  factory TshirtSize.fromJson(String data) {
    return TshirtSize.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [TshirtSize] to a JSON string.
  String toJson() => json.encode(toMap());

  TshirtSize copyWith({
    int? id,
    String? sizeEs,
    String? sizeEn,
    String? description,
  }) {
    return TshirtSize(
      id: id ?? this.id,
      sizeEs: sizeEs ?? this.sizeEs,
      sizeEn: sizeEn ?? this.sizeEn,
      description: description ?? this.description,
    );
  }
}
