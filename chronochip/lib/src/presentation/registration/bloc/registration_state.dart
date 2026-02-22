import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/models.dart' show Runner;
import 'package:chronochip/src/core/models/states_response/datum.dart';
import 'package:chronochip/src/core/models/tshirt_sizes_response/datum.dart'
    as TshirtDatum;
import 'package:chronochip/src/core/models/event_category.dart';
import 'package:equatable/equatable.dart';
import 'package:chronochip/src/core/models/self_information_response/self_information_response.dart';

class RegistrationState extends Equatable {
  final bool isLoading;
  final List<Gender> genders;
  final List<Datum> states;
  final List<Runner> runners;
  final List<TshirtDatum.Datum> tshirtSizes;
  final List<EventCategory> categories;
  final bool isLoadingTshirtSizes;
  final bool isLoadingCategories;
  final String? error;
  final SelfInformationResponse? selfInformation;

  const RegistrationState({
    this.isLoading = false,
    this.genders = const [],
    this.states = const [],
    this.runners = const [],
    this.tshirtSizes = const [],
    this.categories = const [],
    this.isLoadingTshirtSizes = false,
    this.isLoadingCategories = false,
    this.error,
    this.selfInformation,
  });

  RegistrationState copyWith({
    bool? isLoading,
    List<Gender>? genders,
    List<Runner>? runners,
    List<Datum>? states,
    List<TshirtDatum.Datum>? tshirtSizes,
    List<EventCategory>? categories,
    bool? isLoadingTshirtSizes,
    bool? isLoadingCategories,
    String? error,
    SelfInformationResponse? selfInformation,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      genders: genders ?? this.genders,
      states: states ?? this.states,
      runners: runners ?? this.runners,
      tshirtSizes: tshirtSizes ?? this.tshirtSizes,
      categories: categories ?? this.categories,
      isLoadingTshirtSizes: isLoadingTshirtSizes ?? this.isLoadingTshirtSizes,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
      error: error,
      selfInformation: selfInformation ?? this.selfInformation,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    genders,
    states,
    runners,
    tshirtSizes,
    isLoadingTshirtSizes,
    categories,
    isLoadingCategories,
    error,
    selfInformation,
  ];
}
