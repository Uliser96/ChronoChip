import 'dart:convert';

class Modality {
  int? id;
  String? name;

  Modality({this.id, this.name});

  @override
  String toString() => 'Modality(id: $id, name: $name)';

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  factory Modality.fromMap(Map<String, dynamic> data) =>
      Modality(id: _toInt(data['id']), name: data['name'] as String?);

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Modality].
  factory Modality.fromJson(String data) {
    return Modality.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Modality] to a JSON string.
  String toJson() => json.encode(toMap());

  Modality copyWith({int? id, String? name}) {
    return Modality(id: id ?? this.id, name: name ?? this.name);
  }
}
