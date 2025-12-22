import 'package:equatable/equatable.dart';
import '../available_event.dart';

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

  const AvailableEventsSuccess({required this.events});

  @override
  List<Object?> get props => [events];
}

class AvailableEventsFailure extends AvailableEventsState {
  final String error;

  const AvailableEventsFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
