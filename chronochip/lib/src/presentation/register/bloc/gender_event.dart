import 'package:equatable/equatable.dart';

abstract class GenderEvent extends Equatable {
  const GenderEvent();

  @override
  List<Object> get props => [];
}

class GendersFetch extends GenderEvent {
  const GendersFetch();

  @override
  List<Object> get props => [];
}

class GendersReset extends GenderEvent {
  const GendersReset();

  @override
  List<Object> get props => [];
}
