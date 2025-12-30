import 'package:equatable/equatable.dart';

abstract class RaceRegistrationEvent extends Equatable {
  const RaceRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class ConfirmToggled extends RaceRegistrationEvent {
  final bool confirmed;
  const ConfirmToggled(this.confirmed);

  @override
  List<Object?> get props => [confirmed];
}

class SubmitRegistrationPressed extends RaceRegistrationEvent {
  const SubmitRegistrationPressed();
}

class FetchRunners extends RaceRegistrationEvent {
  const FetchRunners();
}

// internal event for loaded runners
class RunnersLoaded extends RaceRegistrationEvent {
  final List<dynamic> runners;
  const RunnersLoaded(this.runners);

  @override
  List<Object?> get props => [runners];
}
