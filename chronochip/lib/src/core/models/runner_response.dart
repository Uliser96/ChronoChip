import 'package:json_annotation/json_annotation.dart';

part 'runner_response.g.dart';

@JsonSerializable()
class RunnerResponse {
  final String message;
  final List<Runner> data;

  RunnerResponse({required this.message, required this.data});

  factory RunnerResponse.fromJson(Map<String, dynamic> json) =>
      _$RunnerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RunnerResponseToJson(this);
}

@JsonSerializable()
class Runner {
  final int id;
  final String firstName;
  final String lastName;
  final String birthdate;
  final int genderId;
  final String email;
  final String phone;
  final int stateId;
  final String city;
  final String emergencyPhone;
  final String teamName;

  Runner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.genderId,
    required this.email,
    required this.phone,
    required this.stateId,
    required this.city,
    required this.emergencyPhone,
    required this.teamName,
  });

  factory Runner.fromJson(Map<String, dynamic> json) => _$RunnerFromJson(json);

  Map<String, dynamic> toJson() => _$RunnerToJson(this);
}
