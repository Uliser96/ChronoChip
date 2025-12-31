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
  final int? runnerId;
  final String firstName;
  final String lastName;
  final String birthdate;
  final int genderId;
  final String? teamName;
  final int eventCategoryId;
  final int? tshirtSize;

  const SubmitRegistrationPressed({
    this.runnerId,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.genderId,
    this.teamName,
    required this.eventCategoryId,
    this.tshirtSize,
  });

  @override
  List<Object?> get props => [
    runnerId,
    firstName,
    lastName,
    birthdate,
    genderId,
    teamName,
    eventCategoryId,
    tshirtSize,
  ];
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

class FetchTshirtSizes extends RaceRegistrationEvent {
  const FetchTshirtSizes();
}

class TshirtSizesLoaded extends RaceRegistrationEvent {
  final List<dynamic> sizes;
  const TshirtSizesLoaded(this.sizes);

  @override
  List<Object?> get props => [sizes];
}

class ValidateAndToggleConfirm extends RaceRegistrationEvent {
  final bool desiredConfirmed;
  final int? runnerId;
  final String name;
  final String surname;
  final int? genderId;
  final String birthdate;
  final String? team;
  final String? category;
  final String? jersey;

  const ValidateAndToggleConfirm({
    required this.desiredConfirmed,
    this.runnerId,
    required this.name,
    required this.surname,
    this.genderId,
    required this.birthdate,
    this.team,
    this.category,
    this.jersey,
  });

  @override
  List<Object?> get props => [
    desiredConfirmed,
    runnerId,
    name,
    surname,
    genderId,
    birthdate,
    team,
    category,
    jersey,
  ];
}
