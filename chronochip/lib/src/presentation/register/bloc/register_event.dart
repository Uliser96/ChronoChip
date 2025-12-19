part of 'register_bloc.dart';

abstract class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String birthdate; // YYYY-MM-DD
  final int genderId;

  RegisterSubmitted({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.genderId,
  });
}

class RegisterReset extends RegisterEvent {}
