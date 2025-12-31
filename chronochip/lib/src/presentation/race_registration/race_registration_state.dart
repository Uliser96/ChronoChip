import 'package:equatable/equatable.dart';
import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/runner_response.dart';
import 'package:chronochip/src/core/models/event_category.dart';

class RaceRegistrationState extends Equatable {
  final bool isConfirmed;
  final bool isSubmitting;
  final bool isSuccess;
  final String? error;
  final List<Gender> genders;
  final List<Runner> runners;
  final List<EventCategory> categories;
  final bool isCategoriesLoading;

  const RaceRegistrationState({
    required this.isConfirmed,
    required this.isSubmitting,
    required this.isSuccess,
    this.error,
    this.genders = const [],
    this.runners = const [],
    this.categories = const [],
    this.isCategoriesLoading = false,
  });

  factory RaceRegistrationState.initial() {
    return const RaceRegistrationState(
      isConfirmed: false,
      isSubmitting: false,
      isSuccess: false,
      error: null,
      genders: [],
    );
  }

  RaceRegistrationState copyWith({
    bool? isConfirmed,
    bool? isSubmitting,
    bool? isSuccess,
    String? error,
    List<Gender>? genders,
    List<Runner>? runners,
    List<EventCategory>? categories,
    bool? isCategoriesLoading,
  }) {
    return RaceRegistrationState(
      isConfirmed: isConfirmed ?? this.isConfirmed,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      genders: genders ?? this.genders,
      runners: runners ?? this.runners,
      categories: categories ?? this.categories,
      isCategoriesLoading: isCategoriesLoading ?? this.isCategoriesLoading,
    );
  }

  @override
  List<Object?> get props => [
    isConfirmed,
    isSubmitting,
    isSuccess,
    error,
    genders,
    runners,
    categories,
    isCategoriesLoading,
  ];
}
