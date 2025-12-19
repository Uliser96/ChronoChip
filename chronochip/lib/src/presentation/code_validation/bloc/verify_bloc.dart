import 'package:bloc/bloc.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';

part 'verify_event.dart';
part 'verify_state.dart';

class VerifyBloc extends Bloc<VerifyEvent, VerifyState> {
  final ApiService _apiService;

  VerifyBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(const VerifyInitial()) {
    on<VerifySubmitted>(_onVerifySubmitted);
    on<VerifyReset>((event, emit) => emit(const VerifyInitial()));
  }

  Future<void> _onVerifySubmitted(
    VerifySubmitted event,
    Emitter<VerifyState> emit,
  ) async {
    emit(VerifyLoading());

    try {
      final response = await _apiService.verifyEmail(
        email: event.email,
        code: event.code,
      );

      final message =
          (response['data'] != null && response['data']['message'] != null)
          ? response['data']['message'] as String
          : (response['message'] ?? 'Success') as String;

      emit(VerifySuccess(message));
    } catch (e) {
      if (e is ApiException) {
        emit(VerifyFailure(e.message));
      } else {
        emit(VerifyFailure(e.toString()));
      }
    }
  }
}
