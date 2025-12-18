import 'package:equatable/equatable.dart';
import 'package:chronochip/src/core/models/gender_response.dart';

abstract class GenderState extends Equatable {
  const GenderState();

  @override
  List<Object?> get props => [];
}

class GenderInitial extends GenderState {
  const GenderInitial();
}

class GenderLoading extends GenderState {
  const GenderLoading();
}

class GenderSuccess extends GenderState {
  final List<Gender> genders;

  const GenderSuccess({required this.genders});

  @override
  List<Object?> get props => [genders];
}

class GenderFailure extends GenderState {
  final String error;

  const GenderFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
