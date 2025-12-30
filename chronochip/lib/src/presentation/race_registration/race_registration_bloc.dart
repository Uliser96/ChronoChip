import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chronochip/src/presentation/register/bloc/gender_bloc.dart';
import 'package:chronochip/src/presentation/register/bloc/gender_event.dart';
import 'package:chronochip/src/presentation/register/bloc/gender_state.dart';
import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/runner_response.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'race_registration_event.dart';
import 'race_registration_state.dart';

class RaceRegistrationBloc
    extends Bloc<RaceRegistrationEvent, RaceRegistrationState> {
  final GenderBloc _genderBloc;
  final ApiService _apiService;
  late final StreamSubscription _genderSub;

  RaceRegistrationBloc({GenderBloc? genderBloc, ApiService? apiService})
    : _genderBloc = genderBloc ?? GenderBloc(),
      _apiService = apiService ?? ApiService(),
      super(RaceRegistrationState.initial()) {
    on<ConfirmToggled>(_onConfirmToggled);
    on<SubmitRegistrationPressed>(_onSubmitPressed);
    on<_GendersLoaded>(_onGendersLoaded);
    on<FetchRunners>(_onFetchRunners);
    on<RunnersLoaded>(_onRunnersLoaded);

    // trigger genders fetch and listen for updates
    _genderBloc.add(const GendersFetch());
    _genderSub = _genderBloc.stream.listen((gState) {
      if (gState is GenderSuccess) {
        add(_GendersLoaded(gState.genders));
      } else if (gState is GenderFailure) {
        // propagate error to this bloc state
        emit(state.copyWith(error: gState.error));
      }
    });

    // trigger runners fetch
    add(const FetchRunners());
  }

  FutureOr<void> _onConfirmToggled(
    ConfirmToggled event,
    Emitter<RaceRegistrationState> emit,
  ) {
    emit(state.copyWith(isConfirmed: event.confirmed, error: null));
  }

  FutureOr<void> _onGendersLoaded(
    _GendersLoaded event,
    Emitter<RaceRegistrationState> emit,
  ) {
    emit(state.copyWith(genders: event.genders));
  }

  FutureOr<void> _onRunnersLoaded(
    RunnersLoaded event,
    Emitter<RaceRegistrationState> emit,
  ) {
    // event.runners contains dynamic objects or Runner instances
    final runners = event.runners.map((r) {
      if (r is Runner) return r;
      return Runner.fromJson(r as Map<String, dynamic>);
    }).toList();

    emit(state.copyWith(runners: runners));
  }

  FutureOr<void> _onFetchRunners(
    FetchRunners event,
    Emitter<RaceRegistrationState> emit,
  ) async {
    try {
      final fetched = await _apiService.getRunners();
      add(RunnersLoaded(fetched));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  FutureOr<void> _onSubmitPressed(
    SubmitRegistrationPressed event,
    Emitter<RaceRegistrationState> emit,
  ) async {
    if (!state.isConfirmed) {
      emit(state.copyWith(error: 'Debe confirmar la información antes.'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null));

    try {
      // Aquí se integraría la llamada a servicio real. Simulamos espera.
      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          isSuccess: false,
          error: e.toString(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _genderSub.cancel();
    _genderBloc.close();
    return super.close();
  }
}

// Internal event to carry loaded genders into this bloc
class _GendersLoaded extends RaceRegistrationEvent {
  final List<Gender> genders;
  const _GendersLoaded(this.genders);

  @override
  List<Object?> get props => [genders];
}
