import 'dart:convert';

class Row {
  int? id;
  String? name;
  String? coverImageUrl;
  String? date;
  String? location;
  int? maxParticipants;
  bool? finished;
  bool? allowTshirtSize;

  Row({
    this.id,
    this.name,
    this.coverImageUrl,
    this.date,
    this.location,
    this.maxParticipants,
    this.finished,
    this.allowTshirtSize,
  });

  @override
  String toString() {
    return 'Row(id: $id, name: $name, coverImageUrl: $coverImageUrl, date: $date, location: $location, maxParticipants: $maxParticipants, finished: $finished, allowTshirtSize: $allowTshirtSize)';
  }

  factory Row.fromMap(Map<String, dynamic> data) => Row(
    id: data['id'] as int?,
    name: data['name'] as String?,
    coverImageUrl: data['coverImageUrl'] as String?,
    date: data['date'] as String?,
    location: data['location'] as String?,
    maxParticipants: data['maxParticipants'] as int?,
    finished: data['finished'] as bool?,
    allowTshirtSize: data['allowTshirtSize'] as bool?,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'coverImageUrl': coverImageUrl,
    'date': date,
    'location': location,
    'maxParticipants': maxParticipants,
    'finished': finished,
    'allowTshirtSize': allowTshirtSize,
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
    int? id,
    String? name,
    String? coverImageUrl,
    String? date,
    String? location,
    int? maxParticipants,
    bool? finished,
    bool? allowTshirtSize,
  }) {
    return Row(
      id: id ?? this.id,
      name: name ?? this.name,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      date: date ?? this.date,
      location: location ?? this.location,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      finished: finished ?? this.finished,
      allowTshirtSize: allowTshirtSize ?? this.allowTshirtSize,
    );
  }
}
