class AvailableEvent {
  final String name;
  final String date;
  final String location;
  final int id;
  final String? coverImageUrl;

  AvailableEvent({
    required this.name,
    required this.date,
    required this.location,
    required this.id,
    this.coverImageUrl,
  });

  factory AvailableEvent.fromJson(Map<String, dynamic> json) {
    String? coverUrl;
    if (json['coverImageUrl'] is String &&
        (json['coverImageUrl'] as String).isNotEmpty) {
      coverUrl = json['coverImageUrl'] as String;
    } else if (json['coverImgPath'] is String &&
        (json['coverImgPath'] as String).isNotEmpty) {
      coverUrl = json['coverImgPath'] as String;
    } else {
      coverUrl = null;
    }

    return AvailableEvent(
      name: json['name'] as String? ?? '',
      date: json['date'] as String? ?? '',
      location: json['location'] as String? ?? '',
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      coverImageUrl: coverUrl,
    );
  }
}
