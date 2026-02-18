import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/states_response/datum.dart';
import 'package:chronochip/src/core/models/tshirt_sizes_response/datum.dart'
    as TshirtDatum;
import 'package:chronochip/src/core/models/event_category.dart';
import 'package:equatable/equatable.dart';

class RegistrationState extends Equatable {
  final bool isLoading;
  final List<Gender> genders;
  final List<Datum> states;
  final List<TshirtDatum.Datum> tshirtSizes;
  final List<EventCategory> categories;
  final bool isLoadingTshirtSizes;
  final bool isLoadingCategories;
  final String? error;

  const RegistrationState({
    this.isLoading = false,
    this.genders = const [],
    this.states = const [],
    this.tshirtSizes = const [],
    this.categories = const [],
    this.isLoadingTshirtSizes = false,
    this.isLoadingCategories = false,
    this.error,
  });

  RegistrationState copyWith({
    bool? isLoading,
    List<Gender>? genders,
    List<Datum>? states,
    List<TshirtDatum.Datum>? tshirtSizes,
    List<EventCategory>? categories,
    bool? isLoadingTshirtSizes,
    bool? isLoadingCategories,
    String? error,
  }) {
    return RegistrationState(
      isLoading: isLoading ?? this.isLoading,
      genders: genders ?? this.genders,
      states: states ?? this.states,
      tshirtSizes: tshirtSizes ?? this.tshirtSizes,
      categories: categories ?? this.categories,
      isLoadingTshirtSizes: isLoadingTshirtSizes ?? this.isLoadingTshirtSizes,
      isLoadingCategories: isLoadingCategories ?? this.isLoadingCategories,
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
    categories,
    isLoadingCategories,
    error,
  ];
}
