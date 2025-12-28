import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_detail_info_event.dart';
import 'event_detail_info_state.dart';

class EventDetailInfoBloc
    extends Bloc<EventDetailInfoEvent, EventDetailInfoState> {
  EventDetailInfoBloc({required EventDetailInfoState initial})
    : super(initial) {
    on<EventDetailInfoRefreshRequested>(_onRefresh);
    on<EventDetailInfoRegistrationRequested>(_onRegister);
  }

  Future<void> _onRefresh(
    EventDetailInfoRefreshRequested event,
    Emitter<EventDetailInfoState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, error: null));
    try {
      // Placeholder: in future call API to refresh details
      await Future.delayed(const Duration(milliseconds: 600));
      emit(state.copyWith(isRefreshing: false));
    } catch (e) {
      emit(state.copyWith(isRefreshing: false, error: e.toString()));
    }
  }

  Future<void> _onRegister(
    EventDetailInfoRegistrationRequested event,
    Emitter<EventDetailInfoState> emit,
  ) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, error: null));
    try {
      // Placeholder: call registration API here
      await Future.delayed(const Duration(seconds: 1));
      // Simulate success - no state change to event itself for now
      emit(state.copyWith(isSubmitting: false));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}
