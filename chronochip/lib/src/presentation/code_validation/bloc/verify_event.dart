part of 'verify_bloc.dart';

abstract class VerifyEvent {}

class VerifySubmitted extends VerifyEvent {
  final String email;
  final String code;

  VerifySubmitted({required this.email, required this.code});
}

class VerifyReset extends VerifyEvent {}
