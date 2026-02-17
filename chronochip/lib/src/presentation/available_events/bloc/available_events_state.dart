import 'package:equatable/equatable.dart';
import '../available_event.dart';
import 'package:chronochip/src/core/models/get_events_list_response/get_events_list_response.dart';

abstract class AvailableEventsState extends Equatable {
  const AvailableEventsState();

  @override
  List<Object?> get props => [];
}

class AvailableEventsInitial extends AvailableEventsState {
  const AvailableEventsInitial();
}

class AvailableEventsLoading extends AvailableEventsState {
  const AvailableEventsLoading();
}

class AvailableEventsSuccess extends AvailableEventsState {
  final List<AvailableEvent> events;
  final GetEventsListResponse response;

  const AvailableEventsSuccess({required this.events, required this.response});

  @override
  List<Object?> get props => [events, response];
}

class AvailableEventsFailure extends AvailableEventsState {
  final String error;

  const AvailableEventsFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
