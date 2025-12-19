part of 'register_bloc.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String message;
  final int userId;

  RegisterSuccess({required this.message, required this.userId});
}

class RegisterFailure extends RegisterState {
  final String error;

  RegisterFailure({required this.error});
}
