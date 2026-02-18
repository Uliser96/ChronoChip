import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/states_response/datum.dart';
import 'package:equatable/equatable.dart';

class RegistrationState extends Equatable {
  final bool isLoading;
  final List<Gender> genders;
  final List<Datum> states;
  final String? error;

  const RegistrationState({
    this.isLoading = false,
    this.genders = const [],
    this.states = const [],
    this.error,
  });

  RegistrationState copyWith({
    bool? isLoading,
    List<Gender>? genders,
    List<Datum>? states,
    String? error,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      genders: genders ?? this.genders,
      states: states ?? this.states,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, genders, states, error];
}
