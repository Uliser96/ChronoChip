import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:chronochip/src/presentation/profile/bloc/profile_event.dart';
import 'package:chronochip/src/presentation/profile/bloc/profile_state.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiService _apiService;

  ProfileBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(ProfileInitial()) {
    on<UploadProfileImage>(_onUploadProfileImage);
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final url = await _apiService.uploadProfileImage(event.file);
      emit(ProfileImageUploadSuccess(url));
    } catch (e) {
      if (e is ApiException) {
        emit(ProfileFailure(e.message));
      } else {
        emit(ProfileFailure(e.toString()));
      }
    }
  }
}
