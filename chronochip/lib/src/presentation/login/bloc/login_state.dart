part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  const LoginSuccess();
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class LoginEmailNotVerified extends LoginState {
  final String message;

  const LoginEmailNotVerified({
    this.message = 'Correo electronico no verificado, por favor verifiquelo',
  });

  @override
  List<Object> get props => [message];
}
