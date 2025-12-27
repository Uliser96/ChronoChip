import 'package:bloc/bloc.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';
import 'package:chronochip/src/core/utils/logger_util.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final ApiService _apiService;

  ResetPasswordBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(const ResetPasswordInitial()) {
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(const ResetPasswordLoading());

    try {
      LoggerUtil.logRequest(
        method: 'POST',
        url: 'api/public/forgot-password',
        body: {'email': event.email},
      );

      final response = await _apiService.forgotPassword(email: event.email);

      final message =
          'Se envio un link de reestablecimiento a tu correo, por favor verificalo';

      LoggerUtil.logResponse(
        method: 'POST',
        url: 'api/public/forgot-password',
        statusCode: 200,
        response: response.toString(),
      );

      emit(ResetPasswordSuccess(message: message));
    } on ApiException catch (e) {
      final errorMessage = e.statusCode == 401 ? 'No autorizado' : e.message;
      LoggerUtil.logError(
        method: 'POST',
        url: 'api/public/forgot-password',
        error: errorMessage,
      );
      emit(ResetPasswordFailure(error: errorMessage));
    } catch (e) {
      LoggerUtil.logError(
        method: 'POST',
        url: 'api/public/forgot-password',
        error: e.toString(),
      );
      emit(ResetPasswordFailure(error: 'Error al enviar solicitud: $e'));
    }
  }
}
