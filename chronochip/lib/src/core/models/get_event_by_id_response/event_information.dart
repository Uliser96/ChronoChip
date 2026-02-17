import 'dart:convert';

class EventInformation {
  int? id;
  String? startTime;
  String? startLocation;
  String? kitPickupInfo;
  String? rules;
  String? contactInfo;

  EventInformation({
    this.id,
    this.startTime,
    this.startLocation,
    this.kitPickupInfo,
    this.rules,
    this.contactInfo,
  });

  @override
  String toString() {
    return 'EventInformation(id: $id, startTime: $startTime, startLocation: $startLocation, kitPickupInfo: $kitPickupInfo, rules: $rules, contactInfo: $contactInfo)';
  }

  factory EventInformation.fromMap(Map<String, dynamic> data) {
    return EventInformation(
      id: data['id'] as int?,
      startTime: data['startTime'] as String?,
      startLocation: data['startLocation'] as String?,
      kitPickupInfo: data['kitPickupInfo'] as String?,
      rules: data['rules'] as String?,
      contactInfo: data['contactInfo'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'startTime': startTime,
    'startLocation': startLocation,
    'kitPickupInfo': kitPickupInfo,
    'rules': rules,
    'contactInfo': contactInfo,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [EventInformation].
  factory EventInformation.fromJson(String data) {
    return EventInformation.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [EventInformation] to a JSON string.
  String toJson() => json.encode(toMap());

  EventInformation copyWith({
    int? id,
    String? startTime,
    String? startLocation,
    String? kitPickupInfo,
    String? rules,
    String? contactInfo,
  }) {
    return EventInformation(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      startLocation: startLocation ?? this.startLocation,
      kitPickupInfo: kitPickupInfo ?? this.kitPickupInfo,
      rules: rules ?? this.rules,
      contactInfo: contactInfo ?? this.contactInfo,
    );
  }
}
