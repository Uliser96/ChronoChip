class AvailableEvent {
  final String name;
  final String date;
  final String location;
  final int id;

  AvailableEvent({
    required this.name,
    required this.date,
    required this.location,
    required this.id,
  });

  factory AvailableEvent.fromJson(Map<String, dynamic> json) {
    return AvailableEvent(
      name: json['name'] as String? ?? '',
      date: json['date'] as String? ?? '',
      location: json['location'] as String? ?? '',
      id: (json['id'] is int)
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
    );
  }
}
