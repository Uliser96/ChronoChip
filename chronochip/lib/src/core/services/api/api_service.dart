import 'package:chronochip/src/core/models/login_response.dart';
import 'package:chronochip/src/core/models/gender_response.dart';
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
}
