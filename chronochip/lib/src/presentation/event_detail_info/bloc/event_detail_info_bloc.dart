import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_detail_info_event.dart';
import 'event_detail_info_state.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';

class EventDetailInfoBloc
    extends Bloc<EventDetailInfoEvent, EventDetailInfoState> {
  final ApiService _apiService;
  final int _eventId;

  EventDetailInfoBloc({required int eventId, ApiService? apiService})
    : _eventId = eventId,
      _apiService = apiService ?? ApiService(),
      super(EventDetailInfoState()) {
    on<EventDetailInfoRefreshRequested>(_onRefresh);
    on<EventDetailInfoRegistrationRequested>(_onRegister);
    // fetch data on creation
    add(EventDetailInfoRefreshRequested());
  }

  Future<void> _onRefresh(
    EventDetailInfoRefreshRequested event,
    Emitter<EventDetailInfoState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, error: null));
    try {
      debugPrint('EventDetailInfoBloc: fetching /api/events/$_eventId');
      final resp = await _apiService.getEventById(eventId: _eventId);
      // debug log response
      debugPrint('EventDetailInfoBloc: getEventById response => $resp');
      if (resp.data == null) {
        debugPrint(
          'EventDetailInfoBloc: response.data is null for eventId=$_eventId',
        );
      }
      emit(state.copyWith(isRefreshing: false, eventResponse: resp));
    } catch (e) {
      debugPrint('EventDetailInfoBloc: getEventById error => $e');
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
