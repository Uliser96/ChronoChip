import 'package:equatable/equatable.dart';

abstract class AvailableEventsEvent extends Equatable {
  const AvailableEventsEvent();

  @override
  List<Object?> get props => [];
}

class AvailableEventsFetch extends AvailableEventsEvent {
  const AvailableEventsFetch();
}

class AvailableEventsReset extends AvailableEventsEvent {
  const AvailableEventsReset();
}
