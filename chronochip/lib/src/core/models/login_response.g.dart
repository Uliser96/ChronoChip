// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : AuthData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'data': instance.data?.toJson(),
    };

AuthData _$AuthDataFromJson(Map<String, dynamic> json) => AuthData(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  tokenType: json['tokenType'] as String,
  expiresIn: json['expiresIn'] as int,
  userInfo: json['userInfo'] == null
      ? null
      : UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'tokenType': instance.tokenType,
  'expiresIn': instance.expiresIn,
  'userInfo': instance.userInfo?.toJson(),
};

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  birthdate: json['birthdate'] as String,
  genderId: json['genderId'] as int,
  profileId: json['profileId'] as int,
  id: json['id'] as int,
  profile: json['profile'] == null
      ? null
      : Profile.fromJson(json['profile'] as Map<String, dynamic>),
  gender: json['gender'] == null
      ? null
      : Gender.fromJson(json['gender'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
  'email': instance.email,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'birthdate': instance.birthdate,
  'genderId': instance.genderId,
  'profileId': instance.profileId,
  'id': instance.id,
  'profile': instance.profile?.toJson(),
  'gender': instance.gender?.toJson(),
};

Profile _$ProfileFromJson(Map<String, dynamic> json) =>
    Profile(id: json['id'] as int, name: json['name'] as String);

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

Gender _$GenderFromJson(Map<String, dynamic> json) => Gender(
  id: json['id'] as int,
  code: json['code'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$GenderToJson(Gender instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
};
