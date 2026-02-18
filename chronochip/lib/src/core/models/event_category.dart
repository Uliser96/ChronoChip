class EventCategory {
  final int id;
  final int eventCategoryId;
  final String categoryName;
  final String divisionName;
  final String displayName;
  final double distanceKm;
  final int minAge;
  final int maxAge;
  final int genderId;

  EventCategory({
    required this.id,
    required this.eventCategoryId,
    required this.categoryName,
    required this.divisionName,
    required this.displayName,
    required this.distanceKm,
    required this.minAge,
    required this.maxAge,
    required this.genderId,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic v, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is String) return int.tryParse(v) ?? fallback;
      if (v is num) return v.toInt();
      return fallback;
    }

    double parseDouble(dynamic v, [double fallback = 0.0]) {
      if (v == null) return fallback;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? fallback;
      if (v is num) return v.toDouble();
      return fallback;
    }

    String parseString(dynamic v) {
      if (v == null) return '';
      return v.toString();
    }

    return EventCategory(
      id: parseInt(json['id']),
      eventCategoryId: parseInt(json['eventCategoryId']),
      categoryName: parseString(json['categoryName']),
      divisionName: parseString(json['divisionName']),
      displayName: parseString(json['displayName']),
      distanceKm: parseDouble(json['distanceKm']),
      minAge: parseInt(json['minAge']),
      maxAge: parseInt(json['maxAge']),
      genderId: parseInt(json['genderId']),
    );
  }
}
