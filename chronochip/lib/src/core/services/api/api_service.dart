import 'package:chronochip/src/core/models/login_response.dart';
import 'api_client.dart';

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
        'login',
        body: {'email': email, 'password': password},
      );

      return LoginResponse.fromJson(response);
    } catch (e) {
      throw Exception('Error en login: $e');
    }
  }
}
