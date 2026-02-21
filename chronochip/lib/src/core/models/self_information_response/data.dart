import 'dart:convert';

class Data {
  bool? hasPrimaryRunner;
  dynamic runnerId;
  String? firstName;
  String? lastName;
  String? email;
  String? birthdate;
  int? genderId;
  dynamic phone;
  dynamic stateId;
  dynamic city;
  dynamic emergencyPhone;
  dynamic teamName;
  dynamic profileImgPath;

  Data({
    this.hasPrimaryRunner,
    this.runnerId,
    this.firstName,
    this.lastName,
    this.email,
    this.birthdate,
    this.genderId,
    this.phone,
    this.stateId,
    this.city,
    this.emergencyPhone,
    this.teamName,
    this.profileImgPath,
  });

  @override
  String toString() {
    return 'Data(hasPrimaryRunner: $hasPrimaryRunner, runnerId: $runnerId, firstName: $firstName, lastName: $lastName, email: $email, birthdate: $birthdate, genderId: $genderId, phone: $phone, stateId: $stateId, city: $city, emergencyPhone: $emergencyPhone, teamName: $teamName, profileImgPath: $profileImgPath)';
  }

  factory Data.fromMap(Map<String, dynamic> data) => Data(
    hasPrimaryRunner: data['hasPrimaryRunner'] as bool?,
    runnerId: data['runnerId'] as dynamic,
    firstName: data['firstName'] as String?,
    lastName: data['lastName'] as String?,
    email: data['email'] as String?,
    birthdate: data['birthdate'] as String?,
    genderId: data['genderId'] as int?,
    phone: data['phone'] as dynamic,
    stateId: data['stateId'] as dynamic,
    city: data['city'] as dynamic,
    emergencyPhone: data['emergencyPhone'] as dynamic,
    teamName: data['teamName'] as dynamic,
    profileImgPath: data['profileImgPath'] as dynamic,
  );

  Map<String, dynamic> toMap() => {
    'hasPrimaryRunner': hasPrimaryRunner,
    'runnerId': runnerId,
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'birthdate': birthdate,
    'genderId': genderId,
    'phone': phone,
    'stateId': stateId,
    'city': city,
    'emergencyPhone': emergencyPhone,
    'teamName': teamName,
    'profileImgPath': profileImgPath,
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
    bool? hasPrimaryRunner,
    dynamic runnerId,
    String? firstName,
    String? lastName,
    String? email,
    String? birthdate,
    int? genderId,
    dynamic phone,
    dynamic stateId,
    dynamic city,
    dynamic emergencyPhone,
    dynamic teamName,
    dynamic profileImgPath,
  }) {
    return Data(
      hasPrimaryRunner: hasPrimaryRunner ?? this.hasPrimaryRunner,
      runnerId: runnerId ?? this.runnerId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthdate: birthdate ?? this.birthdate,
      genderId: genderId ?? this.genderId,
      phone: phone ?? this.phone,
      stateId: stateId ?? this.stateId,
      city: city ?? this.city,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      teamName: teamName ?? this.teamName,
      profileImgPath: profileImgPath ?? this.profileImgPath,
    );
  }
}
