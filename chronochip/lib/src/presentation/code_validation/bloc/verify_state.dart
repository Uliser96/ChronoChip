part of 'verify_bloc.dart';

abstract class VerifyState {
  const VerifyState();
}

class VerifyInitial extends VerifyState {
  const VerifyInitial() : super();
}

class VerifyLoading extends VerifyState {}

class VerifySuccess extends VerifyState {
  final String message;
  VerifySuccess(this.message);
}

class VerifyFailure extends VerifyState {
  final String error;
  VerifyFailure(this.error);
}
