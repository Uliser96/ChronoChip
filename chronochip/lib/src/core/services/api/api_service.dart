import 'package:chronochip/src/core/models/login_response.dart';
import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/runner_response.dart';
import 'package:chronochip/src/core/models/event_category.dart';
import 'package:chronochip/src/core/models/tshirt_size.dart';
import 'api_client.dart';
import 'api_exception.dart';
import '../../models/register_response.dart';

class ApiService {
  final ApiClient _apiClient;

  ApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Realiza la solicitud de login
  Future<LoginResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        'api/auth/login',
        body: {'email': email, 'password': password},
      );

      return LoginResponse.fromJson(response);
    } catch (e) {
      // If the underlying client threw an ApiException, rethrow it so callers
      // (e.g., Blocs) can handle status codes specifically.
      if (e is ApiException) rethrow;
      throw Exception('Error en login: $e');
    }
  }

  /// Obtiene la lista de géneros disponibles
  Future<GenderResponse> getGenders() async {
    try {
      final response = await _apiClient.get('api/genders');
      return GenderResponse.fromJson(response);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error al obtener géneros: $e');
    }
  }

  /// Registra un nuevo usuario
  Future<RegisterResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String birthdate,
    required int genderId,
  }) async {
    try {
      final response = await _apiClient.post(
        'api/public/register',
        body: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
          'birthdate': birthdate,
          'genderId': genderId,
        },
      );

      return RegisterResponse.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error en register: $e');
    }
  }

  /// Verifica el email con el código proporcionado
  Future<Map<String, dynamic>> verifyEmail({
    required String email,
    required String code,
  }) async {
    try {
      final response = await _apiClient.post(
        'api/public/verify-email',
        body: {'email': email, 'code': code},
      );

      return response as Map<String, dynamic>;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error en verifyEmail: $e');
    }
  }

  /// Solicita el envío del código de verificación al email proporcionado
  Future<Map<String, dynamic>> requestVerificationCode({
    required String email,
  }) async {
    try {
      final response = await _apiClient.post(
        'api/public/resend-verification-code',
        body: {'email': email},
      );

      return response as Map<String, dynamic>;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error en requestVerificationCode: $e');
    }
  }

  /// Solicita restablecer la contraseña (forgot password)
  Future<Map<String, dynamic>> forgotPassword({required String email}) async {
    try {
      final response = await _apiClient.post(
        'api/public/forgot-password',
        body: {'email': email},
      );

      return response as Map<String, dynamic>;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error en forgotPassword: $e');
    }
  }

  /// Obtiene la lista de corredores registrados para la inscripción
  Future<List<Runner>> getRunners() async {
    try {
      final response = await _apiClient.get('api/race-registration/runners');

      // response expected: { "message": "Success", "data": [ {...} ] }
      final parsed = RunnerResponse.fromJson(response as Map<String, dynamic>);
      return parsed.data;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error al obtener corredores: $e');
    }
  }

  /// Obtiene las categorías de evento filtradas por evento/género/fecha
  Future<List<EventCategory>> filterEventCategories({
    required int eventId,
    required int genderId,
    required String birthdate,
  }) async {
    try {
      final payload = {
        'eventId': eventId,
        'genderId': genderId,
        'birthdate': birthdate,
      };

      final response = await _apiClient.post(
        'api/race-registration/event-categories/filter',
        body: payload,
      );

      final map = response as Map<String, dynamic>;
      final data = map['data'] as List<dynamic>;
      return data
          .map((e) => EventCategory.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error al obtener categorías: $e');
    }
  }

  /// Obtiene las tallas de jersey (tshirt sizes)
  Future<List<TShirtSize>> getTshirtSizes() async {
    try {
      final response = await _apiClient.get('api/tshirt-sizes');

      // expected: { message: 'Success', data: { rows: [ {...} ], paginator: {...} } }
      final map = response as Map<String, dynamic>;
      final data = map['data'] as Map<String, dynamic>?;
      final rows = data?['rows'] as List<dynamic>? ?? [];
      return rows
          .map((e) => TShirtSize.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error al obtener tallas de jersey: $e');
    }
  }

  /// Envía la inscripción a la carrera
  Future<Map<String, dynamic>> submitRaceRegistration({
    required int runnerId,
    required String firstName,
    required String lastName,
    required String birthdate,
    required int genderId,
    required String teamName,
    required int eventCategoryId,
    required int tshirtSize,
  }) async {
    try {
      final payload = {
        'runnerId': runnerId,
        'firstName': firstName,
        'lastName': lastName,
        'birthdate': birthdate,
        'genderId': genderId,
        'teamName': teamName,
        'eventCategoryId': eventCategoryId,
        'tshirtSize': tshirtSize,
      };

      final response = await _apiClient.post(
        'api/race-registration',
        body: payload,
      );

      return response as Map<String, dynamic>;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error al enviar inscripción: $e');
    }
  }
}
