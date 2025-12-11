import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final ApiService _apiService;

  LoginBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LoginReset>(_onLoginReset);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    try {
      final response = await _apiService.login(
        email: event.email,
        password: event.password,
      );

      if (response.success) {
        emit(const LoginSuccess());
      } else {
        emit(LoginFailure(error: response.messageError));
      }
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }

  Future<void> _onLoginReset(LoginReset event, Emitter<LoginState> emit) async {
    emit(const LoginInitial());
  }
}
