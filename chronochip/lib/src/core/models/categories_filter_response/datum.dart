import 'dart:convert';

class Datum {
  int? id;
  String? categoryName;
  String? divisionName;
  String? displayName;
  int? distanceKm;
  int? minAge;
  int? maxAge;
  int? genderId;

  Datum({
    this.id,
    this.categoryName,
    this.divisionName,
    this.displayName,
    this.distanceKm,
    this.minAge,
    this.maxAge,
    this.genderId,
  });

  @override
  String toString() {
    return 'Datum(id: $id, categoryName: $categoryName, divisionName: $divisionName, displayName: $displayName, distanceKm: $distanceKm, minAge: $minAge, maxAge: $maxAge, genderId: $genderId)';
  }

  factory Datum.fromMap(Map<String, dynamic> data) => Datum(
    id: data['id'] as int?,
    categoryName: data['categoryName'] as String?,
    divisionName: data['divisionName'] as String?,
    displayName: data['displayName'] as String?,
    distanceKm: data['distanceKm'] as int?,
    minAge: data['minAge'] as int?,
    maxAge: data['maxAge'] as int?,
    genderId: data['genderId'] as int?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'categoryName': categoryName,
    'divisionName': divisionName,
    'displayName': displayName,
    'distanceKm': distanceKm,
    'minAge': minAge,
    'maxAge': maxAge,
    'genderId': genderId,
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
    String? categoryName,
    String? divisionName,
    String? displayName,
    int? distanceKm,
    int? minAge,
    int? maxAge,
    int? genderId,
  }) {
    return Datum(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      divisionName: divisionName ?? this.divisionName,
      displayName: displayName ?? this.displayName,
      distanceKm: distanceKm ?? this.distanceKm,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      genderId: genderId ?? this.genderId,
    );
  }
}
