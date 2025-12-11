// Ejemplo de cómo extender la estructura para nuevos servicios

// 1. Crear modelo en core/models/user_profile.dart
/*
import 'package:json_annotation/json_annotation.dart';

part 'user_profile.g.dart';

@JsonSerializable()
class UserProfile {
  final int id;
  final String name;
  final String email;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
*/

// 2. Agregar método en core/services/api/api_service.dart
/*
Future<UserProfile> getUserProfile(String userId) async {
  try {
    final response = await _apiClient.get('users/$userId');
    return UserProfile.fromJson(response);
  } catch (e) {
    throw Exception('Error obteniendo perfil: $e');
  }
}
*/

// 3. Crear Bloc en presentation/user_profile/bloc/
/*
part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final ApiService _apiService;

  UserProfileBloc({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(const UserProfileInitial()) {
    on<UserProfileFetched>(_onUserProfileFetched);
  }

  Future<void> _onUserProfileFetched(
    UserProfileFetched event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(const UserProfileLoading());
    try {
      final profile = await _apiService.getUserProfile(event.userId);
      emit(UserProfileSuccess(profile: profile));
    } catch (e) {
      emit(UserProfileFailure(error: e.toString()));
    }
  }
}
*/

// 4. Agregar BlocProvider en routers.dart
/*
userProfile: (context) => BlocProvider(
  create: (context) => UserProfileBloc(),
  child: const UserProfilePage(),
),
*/
