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

class FetchCategories extends RaceRegistrationEvent {
  final int genderId;
  final String birthdate;
  const FetchCategories({required this.genderId, required this.birthdate});

  @override
  List<Object?> get props => [genderId, birthdate];
}

// internal event for categories loaded
class CategoriesLoaded extends RaceRegistrationEvent {
  final List<dynamic> categories;
  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}
