import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class FetchGendersRequested extends RegistrationEvent {
  const FetchGendersRequested();
}

class FetchStatesRequested extends RegistrationEvent {
  const FetchStatesRequested();
}

class FetchTshirtSizesRequested extends RegistrationEvent {
  final int eventId;

  const FetchTshirtSizesRequested({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}
