import 'dart:convert';

class Modality {
  int? id;
  String? name;

  Modality({this.id, this.name});

  @override
  String toString() => 'Modality(id: $id, name: $name)';

  factory Modality.fromMap(Map<String, dynamic> data) =>
      Modality(id: data['id'] as int?, name: data['name'] as String?);

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
