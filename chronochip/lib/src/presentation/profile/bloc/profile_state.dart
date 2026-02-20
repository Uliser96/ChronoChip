import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileImageUploadSuccess extends ProfileState {
  final String imageUrl;

  const ProfileImageUploadSuccess(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure(this.error);

  @override
  List<Object?> get props => [error];
}
