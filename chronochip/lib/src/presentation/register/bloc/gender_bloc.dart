import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';
import 'package:chronochip/src/core/utils/logger_util.dart';
import 'gender_event.dart';
import 'gender_state.dart';

class GenderBloc extends Bloc<GenderEvent, GenderState> {
  final ApiService _apiService;

  GenderBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(const GenderInitial()) {
    on<GendersFetch>(_onGendersFetch);
    on<GendersReset>(_onGendersReset);
  }

  Future<void> _onGendersFetch(
    GendersFetch event,
    Emitter<GenderState> emit,
  ) async {
    emit(const GenderLoading());

    try {
      LoggerUtil.logRequest(method: 'GET', url: 'api/genders', body: null);

      final response = await _apiService.getGenders();

      LoggerUtil.logResponse(
        method: 'GET',
        url: 'api/genders',
        statusCode: 200,
        response: response.message,
      );

      emit(GenderSuccess(genders: response.data.rows));
    } on ApiException catch (e) {
      final errorMessage = e.statusCode == 401
          ? 'No autorizado para obtener géneros'
          : e.message;

      LoggerUtil.logError(
        method: 'GET',
        url: 'api/genders',
        error: errorMessage,
      );

      emit(GenderFailure(error: errorMessage));
    } catch (e) {
      LoggerUtil.logError(
        method: 'GET',
        url: 'api/genders',
        error: e.toString(),
      );
      emit(GenderFailure(error: 'Error al cargar géneros: $e'));
    }
  }

  Future<void> _onGendersReset(
    GendersReset event,
    Emitter<GenderState> emit,
  ) async {
    emit(const GenderInitial());
  }
}
