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

class FetchCategoriesRequested extends RegistrationEvent {
  final int eventId;
  final int genderId;
  final String birthdate;

  const FetchCategoriesRequested({
    required this.eventId,
    required this.genderId,
    required this.birthdate,
  });

  @override
  List<Object?> get props => [eventId, genderId, birthdate];
}
