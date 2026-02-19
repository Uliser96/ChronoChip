import 'dart:convert';

import 'event_category.dart';
import 'runner_data.dart';

class Data {
  String? message;
  int? runnerId;
  int? pendingRegistrationId;
  RunnerData? runnerData;
  EventCategory? eventCategory;

  Data({
    this.message,
    this.runnerId,
    this.pendingRegistrationId,
    this.runnerData,
    this.eventCategory,
  });

  @override
  String toString() {
    return 'Data(message: $message, runnerId: $runnerId, pendingRegistrationId: $pendingRegistrationId, runnerData: $runnerData, eventCategory: $eventCategory)';
  }

  factory Data.fromMap(Map<String, dynamic> data) {
    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return Data(
      message: data['message'] as String?,
      runnerId: _toInt(data['runnerId']),
      pendingRegistrationId: _toInt(data['pendingRegistrationId']),
      runnerData: data['runnerData'] == null
          ? null
          : RunnerData.fromMap(data['runnerData'] as Map<String, dynamic>),
      eventCategory: data['eventCategory'] == null
          ? null
          : EventCategory.fromMap(
              data['eventCategory'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toMap() => {
    'message': message,
    'runnerId': runnerId,
    'pendingRegistrationId': pendingRegistrationId,
    'runnerData': runnerData?.toMap(),
    'eventCategory': eventCategory?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Data].
  factory Data.fromJson(String data) {
    return Data.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Data] to a JSON string.
  String toJson() => json.encode(toMap());

  Data copyWith({
    String? message,
    int? runnerId,
    int? pendingRegistrationId,
    RunnerData? runnerData,
    EventCategory? eventCategory,
  }) {
    return Data(
      message: message ?? this.message,
      runnerId: runnerId ?? this.runnerId,
      pendingRegistrationId:
          pendingRegistrationId ?? this.pendingRegistrationId,
      runnerData: runnerData ?? this.runnerData,
      eventCategory: eventCategory ?? this.eventCategory,
    );
  }
}
