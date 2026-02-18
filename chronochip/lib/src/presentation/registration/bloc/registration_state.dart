import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/states_response/datum.dart';
import 'package:chronochip/src/core/models/tshirt_sizes_response/datum.dart'
    as TshirtDatum;
import 'package:equatable/equatable.dart';

class RegistrationState extends Equatable {
  final bool isLoading;
  final List<Gender> genders;
  final List<Datum> states;
  final List<TshirtDatum.Datum> tshirtSizes;
  final bool isLoadingTshirtSizes;
  final String? error;

  const RegistrationState({
    this.isLoading = false,
    this.genders = const [],
    this.states = const [],
    this.tshirtSizes = const [],
    this.isLoadingTshirtSizes = false,
    this.error,
  });

  RegistrationState copyWith({
    bool? isLoading,
    List<Gender>? genders,
    List<Datum>? states,
    List<TshirtDatum.Datum>? tshirtSizes,
    bool? isLoadingTshirtSizes,
    String? error,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      genders: genders ?? this.genders,
      states: states ?? this.states,
      tshirtSizes: tshirtSizes ?? this.tshirtSizes,
      isLoadingTshirtSizes: isLoadingTshirtSizes ?? this.isLoadingTshirtSizes,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    genders,
    states,
    tshirtSizes,
    isLoadingTshirtSizes,
    error,
  ];
}
