import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'registration_event.dart';
import 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final ApiService _apiService;

  RegistrationBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(const RegistrationState()) {
    on<FetchGendersRequested>(_onFetchGendersRequested);
    on<FetchStatesRequested>(_onFetchStatesRequested);
  }

  Future<void> _onFetchGendersRequested(
    FetchGendersRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final genders = await _apiService.getGendersForRegistration();
      emit(state.copyWith(isLoading: false, genders: genders));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchStatesRequested(
    FetchStatesRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final states = await _apiService.getStatesForRegistration();
      emit(state.copyWith(isLoading: false, states: states));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
