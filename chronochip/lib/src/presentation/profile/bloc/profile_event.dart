import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class UploadProfileImage extends ProfileEvent {
  final File file;

  const UploadProfileImage(this.file);

  @override
  List<Object?> get props => [file.path];
}
