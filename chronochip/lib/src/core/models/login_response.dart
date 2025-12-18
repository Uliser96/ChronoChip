import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final String message;
  final AuthData? data;

  LoginResponse({required this.message, this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class AuthData {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final UserInfo? userInfo;

  AuthData({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    this.userInfo,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataToJson(this);
}

@JsonSerializable()
class UserInfo {
  final String email;
  final String firstName;
  final String lastName;
  final String birthdate;
  final int genderId;
  final int profileId;
  final int id;
  final Profile? profile;
  final Gender? gender;

  UserInfo({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.genderId,
    required this.profileId,
    required this.id,
    this.profile,
    this.gender,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class Profile {
  final int id;
  final String name;

  Profile({required this.id, required this.name});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

@JsonSerializable()
class Gender {
  final int id;
  final String code;
  final String name;

  Gender({required this.id, required this.code, required this.name});

  factory Gender.fromJson(Map<String, dynamic> json) => _$GenderFromJson(json);
  Map<String, dynamic> toJson() => _$GenderToJson(this);
}
