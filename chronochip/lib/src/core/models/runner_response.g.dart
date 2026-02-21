// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'runner_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RunnerResponse _$RunnerResponseFromJson(Map<String, dynamic> json) =>
    RunnerResponse(
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Runner.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RunnerResponseToJson(RunnerResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

Runner _$RunnerFromJson(Map<String, dynamic> json) => Runner(
  id: json['id'] as int,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  birthdate: json['birthdate'] as String,
  genderId: json['genderId'] as int,
  email: json['email'] as String,
  phone: json['phone'] as String,
  stateId: json['stateId'] as int,
  city: json['city'] as String,
  emergencyPhone: json['emergencyPhone'] as String,
  teamName: json['teamName'] as String,
);

Map<String, dynamic> _$RunnerToJson(Runner instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'birthdate': instance.birthdate,
  'genderId': instance.genderId,
  'email': instance.email,
  'phone': instance.phone,
  'stateId': instance.stateId,
  'city': instance.city,
  'emergencyPhone': instance.emergencyPhone,
  'teamName': instance.teamName,
};
