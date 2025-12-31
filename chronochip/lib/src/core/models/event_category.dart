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
    return EventCategory(
      id: json['id'] as int,
      eventCategoryId: json['eventCategoryId'] as int,
      categoryName: json['categoryName'] as String,
      divisionName: json['divisionName'] as String,
      displayName: json['displayName'] as String,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      minAge: json['minAge'] as int,
      maxAge: json['maxAge'] as int,
      genderId: json['genderId'] as int,
    );
  }
}
