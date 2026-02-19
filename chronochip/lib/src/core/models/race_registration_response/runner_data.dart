import 'dart:convert';

import 'gender.dart';
import 'state.dart';
import 'user.dart';

class RunnerData {
  String? firstName;
  String? lastName;
  String? birthdate;
  int? genderId;
  String? teamName;
  String? email;
  String? phone;
  int? stateId;
  String? city;
  String? emergencyPhone;
  int? id;
  int? userId;
  dynamic profileImgPath;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Gender? gender;
  State? state;

  RunnerData({
    this.firstName,
    this.lastName,
    this.birthdate,
    this.genderId,
    this.teamName,
    this.email,
    this.phone,
    this.stateId,
    this.city,
    this.emergencyPhone,
    this.id,
    this.userId,
    this.profileImgPath,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.gender,
    this.state,
  });

  @override
  String toString() {
    return 'RunnerData(firstName: $firstName, lastName: $lastName, birthdate: $birthdate, genderId: $genderId, teamName: $teamName, email: $email, phone: $phone, stateId: $stateId, city: $city, emergencyPhone: $emergencyPhone, id: $id, userId: $userId, profileImgPath: $profileImgPath, createdAt: $createdAt, updatedAt: $updatedAt, user: $user, gender: $gender, state: $state)';
  }

  factory RunnerData.fromMap(Map<String, dynamic> data) {
    int? _toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    return RunnerData(
      firstName: data['firstName'] as String?,
      lastName: data['lastName'] as String?,
      birthdate: data['birthdate'] as String?,
      genderId: _toInt(data['genderId']),
      teamName: data['teamName'] as String?,
      email: data['email'] as String?,
      phone: data['phone'] as String?,
      stateId: _toInt(data['stateId']),
      city: data['city'] as String?,
      emergencyPhone: data['emergencyPhone'] as String?,
      id: _toInt(data['id']),
      userId: _toInt(data['userId']),
      profileImgPath: data['profileImgPath'] as dynamic,
      createdAt: data['createdAt'] == null
          ? null
          : DateTime.parse(data['createdAt'] as String),
      updatedAt: data['updatedAt'] == null
          ? null
          : DateTime.parse(data['updatedAt'] as String),
      user: data['user'] == null
          ? null
          : User.fromMap(data['user'] as Map<String, dynamic>),
      gender: data['gender'] == null
          ? null
          : Gender.fromMap(data['gender'] as Map<String, dynamic>),
      state: data['state'] == null
          ? null
          : State.fromMap(data['state'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
    'firstName': firstName,
    'lastName': lastName,
    'birthdate': birthdate,
    'genderId': genderId,
    'teamName': teamName,
    'email': email,
    'phone': phone,
    'stateId': stateId,
    'city': city,
    'emergencyPhone': emergencyPhone,
    'id': id,
    'userId': userId,
    'profileImgPath': profileImgPath,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'user': user?.toMap(),
    'gender': gender?.toMap(),
    'state': state?.toMap(),
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RunnerData].
  factory RunnerData.fromJson(String data) {
    return RunnerData.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RunnerData] to a JSON string.
  String toJson() => json.encode(toMap());

  RunnerData copyWith({
    String? firstName,
    String? lastName,
    String? birthdate,
    int? genderId,
    String? teamName,
    String? email,
    String? phone,
    int? stateId,
    String? city,
    String? emergencyPhone,
    int? id,
    int? userId,
    dynamic profileImgPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    User? user,
    Gender? gender,
    State? state,
  }) {
    return RunnerData(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthdate: birthdate ?? this.birthdate,
      genderId: genderId ?? this.genderId,
      teamName: teamName ?? this.teamName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      stateId: stateId ?? this.stateId,
      city: city ?? this.city,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      profileImgPath: profileImgPath ?? this.profileImgPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
      gender: gender ?? this.gender,
      state: state ?? this.state,
    );
  }
}
