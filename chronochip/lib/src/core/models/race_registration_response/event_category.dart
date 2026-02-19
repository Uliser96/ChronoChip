import 'dart:convert';

class EventCategory {
  int? id;
  String? categoryName;
  String? divisionName;
  String? displayName;
  int? distanceKm;
  int? minAge;
  int? maxAge;
  int? genderId;

  EventCategory({
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
    return 'EventCategory(id: $id, categoryName: $categoryName, divisionName: $divisionName, displayName: $displayName, distanceKm: $distanceKm, minAge: $minAge, maxAge: $maxAge, genderId: $genderId)';
  }

  factory EventCategory.fromMap(Map<String, dynamic> data) {
    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return EventCategory(
      id: _toInt(data['id']),
      categoryName: data['categoryName'] as String?,
      divisionName: data['divisionName'] as String?,
      displayName: data['displayName'] as String?,
      distanceKm: _toInt(data['distanceKm']),
      minAge: _toInt(data['minAge']),
      maxAge: _toInt(data['maxAge']),
      genderId: _toInt(data['genderId']),
    );
  }

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
  /// Parses the string and returns the resulting Json object as [EventCategory].
  factory EventCategory.fromJson(String data) {
    return EventCategory.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EventCategory] to a JSON string.
  String toJson() => json.encode(toMap());

  EventCategory copyWith({
    int? id,
    String? categoryName,
    String? divisionName,
    String? displayName,
    int? distanceKm,
    int? minAge,
    int? maxAge,
    int? genderId,
  }) {
    return EventCategory(
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
