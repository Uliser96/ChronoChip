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
    on<FetchTshirtSizesRequested>(_onFetchTshirtSizesRequested);
    on<FetchCategoriesRequested>(_onFetchCategoriesRequested);
    on<FetchSelfInformationRequested>(_onFetchSelfInformationRequested);
    on<FetchRunnersRequested>(_onFetchRunnersRequested);
  }
  Future<void> _onFetchSelfInformationRequested(
    FetchSelfInformationRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final resp = await _apiService.getSelfRegistration();
      emit(state.copyWith(isLoading: false, selfInformation: resp));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onFetchRunnersRequested(
    FetchRunnersRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final runners = await _apiService.getRunners();
      emit(state.copyWith(isLoading: false, runners: runners));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
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

  Future<void> _onFetchTshirtSizesRequested(
    FetchTshirtSizesRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(isLoadingTshirtSizes: true, error: null));
    try {
      final resp = await _apiService.getEventTshirtSizes(
        eventId: event.eventId,
        genderId: event.genderId,
      );
      final tshirtData = resp.data ?? [];
      emit(
        state.copyWith(isLoadingTshirtSizes: false, tshirtSizes: tshirtData),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingTshirtSizes: false, error: e.toString()));
    }
  }

  Future<void> _onFetchCategoriesRequested(
    FetchCategoriesRequested event,
    Emitter<RegistrationState> emit,
  ) async {
    emit(state.copyWith(isLoadingCategories: true, error: null));
    try {
      final categories = await _apiService.filterEventCategories(
        eventId: event.eventId,
        genderId: event.genderId,
        birthdate: event.birthdate,
      );
      emit(state.copyWith(isLoadingCategories: false, categories: categories));
    } catch (e) {
      emit(state.copyWith(isLoadingCategories: false, error: e.toString()));
    }
  }
}
