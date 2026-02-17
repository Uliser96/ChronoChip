import 'package:chronochip/src/core/models/get_event_by_id_response/get_event_by_id_response.dart';

class EventDetailInfoState {
  final bool isRefreshing;
  final bool isSubmitting;
  final String? error;
  final GetEventByIdResponse? eventResponse;

  EventDetailInfoState({
    this.isRefreshing = false,
    this.isSubmitting = false,
    this.error,
    this.eventResponse,
  });

  EventDetailInfoState copyWith({
    bool? isRefreshing,
    bool? isSubmitting,
    String? error,
    GetEventByIdResponse? eventResponse,
  }) {
    return EventDetailInfoState(
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
      eventResponse: eventResponse ?? this.eventResponse,
    );
  }
}
