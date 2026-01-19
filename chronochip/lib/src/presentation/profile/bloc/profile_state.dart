abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String fullName;
  final String? profileImageUrl;
  final String favoriteDistance;
  final String bestPaceTime;
  final String yearlyKm;
  final String raceCount;

  ProfileLoaded({
    required this.fullName,
    required this.profileImageUrl,
    required this.favoriteDistance,
    required this.bestPaceTime,
    required this.yearlyKm,
    required this.raceCount,
  });
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
