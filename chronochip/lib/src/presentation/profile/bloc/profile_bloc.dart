import 'package:bloc/bloc.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiService apiService;

  ProfileBloc({required this.apiService}) : super(ProfileInitial()) {
    on<FetchProfile>(_onFetchProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfile event,
    Emitter<ProfileState> emit,
  ) async {
    // Debug log when the event handler starts
    // ignore: avoid_print
    print('ProfileBloc: FetchProfile received');
    emit(ProfileLoading());
    try {
      final resp = await apiService.getRunnerProfile();
      // Debug log the response received by the bloc
      // ignore: avoid_print
      print('ProfileBloc: getRunnerProfile resp => $resp');
      final data = resp['data'] as Map<String, dynamic>? ?? {};
      final fullName = (data['fullName']?.toString() ?? '-');
      final profileImageUrl = data['profileImageUrl']?.toString();
      final favoriteDistance = (data['favoriteDistance']?.toString() ?? '-');
      final bestPaceTime = (data['bestPaceTime']?.toString() ?? '-');
      final yearlyKm = data['yearlyKm'] != null
          ? '${data['yearlyKm'].toString()}km'
          : '-';
      final raceCount = data['raceCount'] != null
          ? '${data['raceCount'].toString()} carreras'
          : '-';

      emit(
        ProfileLoaded(
          fullName: fullName,
          profileImageUrl: profileImageUrl,
          favoriteDistance: favoriteDistance,
          bestPaceTime: bestPaceTime,
          yearlyKm: yearlyKm,
          raceCount: raceCount,
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print('ProfileBloc: error fetching profile => $e');
      emit(ProfileError(e?.toString() ?? 'Error desconocido'));
    }
  }
}
