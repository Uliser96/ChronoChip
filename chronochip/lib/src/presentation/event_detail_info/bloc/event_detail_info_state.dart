import '../event_detail_info_page.dart';

class EventDetailInfoState {
  final EventDetailInfo event;
  final bool isRefreshing;
  final bool isSubmitting;
  final String? error;

  EventDetailInfoState({
    required this.event,
    this.isRefreshing = false,
    this.isSubmitting = false,
    this.error,
  });

  EventDetailInfoState copyWith({
    EventDetailInfo? event,
    bool? isRefreshing,
    bool? isSubmitting,
    String? error,
  }) {
    return EventDetailInfoState(
      event: event ?? this.event,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}
