import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';
import 'package:chronochip/src/core/services/token_storage.dart';

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

      // Consider success when we have data with a non-empty accessToken
      if (response.data != null && response.data!.accessToken.isNotEmpty) {
        // Guardar tokens de forma segura
        await TokenStorage.saveTokens(
          accessToken: response.data!.accessToken,
          refreshToken: response.data!.refreshToken,
        );

        emit(const LoginSuccess());
      } else {
        emit(
          LoginFailure(
            error: response.message.isNotEmpty
                ? response.message
                : 'Login failed',
          ),
        );
      }
    } catch (e) {
      if (e is ApiException && e.statusCode == 401) {
        // Mostrar mensaje amigable sin exponer detalles del servicio
        emit(LoginFailure(error: 'Credenciales invalidas'));
      } else if (e is ApiException) {
        emit(LoginFailure(error: e.message));
      } else {
        emit(LoginFailure(error: e.toString()));
      }
    }
  }

  Future<void> _onLoginReset(LoginReset event, Emitter<LoginState> emit) async {
    emit(const LoginInitial());
  }
}
