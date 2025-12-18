import 'package:chronochip/src/core/models/login_response.dart';
import 'api_client.dart';
import 'api_exception.dart';

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
}
