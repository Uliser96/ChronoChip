import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chronochip/src/presentation/register/bloc/gender_bloc.dart';
import 'package:chronochip/src/presentation/register/bloc/gender_event.dart';
import 'package:chronochip/src/presentation/register/bloc/gender_state.dart';
import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/runner_response.dart';
import 'package:chronochip/src/core/models/event_category.dart';
import 'package:chronochip/src/core/models/tshirt_size.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'race_registration_event.dart';
import 'race_registration_state.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';

class RaceRegistrationBloc
    extends Bloc<RaceRegistrationEvent, RaceRegistrationState> {
  final int eventId;
  final GenderBloc _genderBloc;
  final ApiService _apiService;
  late final StreamSubscription _genderSub;
  RaceRegistrationBloc({
    required this.eventId,
    GenderBloc? genderBloc,
    ApiService? apiService,
  }) : _genderBloc = genderBloc ?? GenderBloc(),
       _apiService = apiService ?? ApiService(),
       super(RaceRegistrationState.initial()) {
    on<ConfirmToggled>(_onConfirmToggled);
    on<ValidateAndToggleConfirm>(_onValidateAndToggleConfirm);
    on<SubmitRegistrationPressed>(_onSubmitPressed);
    on<_GendersLoaded>(_onGendersLoaded);
    on<FetchRunners>(_onFetchRunners);
    on<RunnersLoaded>(_onRunnersLoaded);
    on<FetchTshirtSizes>(_onFetchTshirtSizes);
    on<TshirtSizesLoaded>(_onTshirtSizesLoaded);
    on<FetchCategories>(_onFetchCategories);
    on<CategoriesLoaded>(_onCategoriesLoaded);

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
    // trigger tshirt sizes fetch
    add(const FetchTshirtSizes());
  }

  FutureOr<void> _onConfirmToggled(
    ConfirmToggled event,
    Emitter<RaceRegistrationState> emit,
  ) {
    emit(state.copyWith(isConfirmed: event.confirmed, error: null));
  }

  FutureOr<void> _onValidateAndToggleConfirm(
    ValidateAndToggleConfirm event,
    Emitter<RaceRegistrationState> emit,
  ) {
    // If user wants to uncheck, allow immediately
    if (!event.desiredConfirmed) {
      emit(state.copyWith(isConfirmed: false, error: null));
    } else {
      // Perform validations
      final nameValid = event.name.trim().length >= 1;
      final surnameValid = event.surname.trim().length >= 1;
      final genderValid = event.genderId != null;
      final dobValid = event.birthdate.trim().isNotEmpty;
      final categoryValid =
          event.category != null && event.category!.trim().isNotEmpty;

      if (nameValid &&
          surnameValid &&
          genderValid &&
          dobValid &&
          categoryValid) {
        emit(state.copyWith(isConfirmed: true, error: null));
      } else {
        emit(
          state.copyWith(
            isConfirmed: false,
            error: 'Por favor complete los campos obligatorios.',
          ),
        );
      }
    }
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

  FutureOr<void> _onFetchTshirtSizes(
    FetchTshirtSizes event,
    Emitter<RaceRegistrationState> emit,
  ) async {
    try {
      final fetched = await _apiService.getTshirtSizes();
      add(TshirtSizesLoaded(fetched));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  FutureOr<void> _onTshirtSizesLoaded(
    TshirtSizesLoaded event,
    Emitter<RaceRegistrationState> emit,
  ) {
    final sizes = event.sizes.map((s) {
      // may already be TShirtSize instances or maps
      try {
        if (s is TShirtSize) return s;
      } catch (_) {}
      return TShirtSize.fromJson(s as Map<String, dynamic>);
    }).toList();

    emit(state.copyWith(tshirtSizes: sizes));
  }

  FutureOr<void> _onFetchCategories(
    FetchCategories event,
    Emitter<RaceRegistrationState> emit,
  ) async {
    emit(state.copyWith(isCategoriesLoading: true, error: null));
    try {
      final fetched = await _apiService.filterEventCategories(
        eventId: eventId,
        genderId: event.genderId,
        birthdate: event.birthdate,
      );
      add(CategoriesLoaded(fetched));
    } catch (e) {
      emit(state.copyWith(isCategoriesLoading: false, error: e.toString()));
    }
  }

  FutureOr<void> _onCategoriesLoaded(
    CategoriesLoaded event,
    Emitter<RaceRegistrationState> emit,
  ) {
    final cats = event.categories.map((c) {
      if (c is EventCategory) return c;
      return EventCategory.fromJson(c as Map<String, dynamic>);
    }).toList();

    emit(state.copyWith(categories: cats, isCategoriesLoading: false));
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
      final runnerId = event.runnerId ?? 0;
      final teamName = event.teamName ?? '';
      final tshirtSize = event.tshirtSize ?? 0;

      final resp = await _apiService.submitRaceRegistration(
        runnerId: runnerId,
        firstName: event.firstName,
        lastName: event.lastName,
        birthdate: event.birthdate,
        genderId: event.genderId,
        teamName: teamName,
        eventCategoryId: event.eventCategoryId,
        tshirtSize: tshirtSize,
      );

      // consider success when no exception thrown; may inspect resp
      emit(state.copyWith(isSubmitting: false, isSuccess: true));
    } catch (e) {
      String errMsg;
      if (e is ApiException && e.statusCode == 400) {
        errMsg = 'Corredor ya registrado en la carrera';
      } else if (e is ApiException) {
        errMsg = e.message;
      } else {
        errMsg = e.toString();
      }

      emit(
        state.copyWith(isSubmitting: false, isSuccess: false, error: errMsg),
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
