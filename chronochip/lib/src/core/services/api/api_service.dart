import 'package:chronochip/src/core/models/login_response.dart' hide Gender;
import 'package:chronochip/src/core/models/gender_response.dart';
import 'package:chronochip/src/core/models/states_response/states_response.dart';
import 'package:chronochip/src/core/models/states_response/datum.dart';
import 'package:chronochip/src/core/models/runner_response.dart';
import 'package:chronochip/src/core/models/event_category.dart';
import 'package:chronochip/src/core/models/tshirt_size.dart';
import 'package:chronochip/src/core/models/get_events_list_response/get_events_list_response.dart';
import 'package:chronochip/src/core/models/get_event_by_id_response/get_event_by_id_response.dart';
import 'api_client.dart';
import 'api_exception.dart';
import '../../models/register_response.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../token_storage.dart';

class ApiService {
  final ApiClient _apiClient;

  ApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Obtiene la lista de eventos disponibles
  Future<GetEventsListResponse> getEventsList() async {
    try {
      final response = await _apiClient.get('api/events');
      return GetEventsListResponse.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error al obtener eventos: $e');
    }
  }

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

  /// Obtiene la lista de géneros para la pantalla de registro (separado
  /// para no afectar llamadas existentes que dependan de `getGenders`).
  Future<List<Gender>> getGendersForRegistration() async {
    try {
      final response = await _apiClient.get('api/genders');
      final map = response as Map<String, dynamic>;
      final parsed = GenderResponse.fromJson(map);
      return parsed.data.rows;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error al obtener géneros para registro: $e');
    }
  }

  /// Obtiene la lista de estados para la pantalla de registro.
  Future<List<Datum>> getStatesForRegistration() async {
    try {
      final response = await _apiClient.get('api/states');
      final map = response as Map<String, dynamic>;
      final parsed = StatesResponse.fromMap(map);
      return parsed.data ?? [];
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error al obtener estados para registro: $e');
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

  /// Obtiene los detalles de un evento por id
  Future<GetEventByIdResponse> getEventById({required int eventId}) async {
    try {
      final response = await _apiClient.get('api/events/$eventId');
      return GetEventByIdResponse.fromMap(response as Map<String, dynamic>);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error al obtener evento por id: $e');
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

  /// Obtiene el perfil del corredor
  Future<Map<String, dynamic>> getRunnerProfile() async {
    // Debug log to verify the method is called
    // ignore: avoid_print
    print('ApiService.getRunnerProfile: called');
    try {
      final response = await _apiClient.get('api/runner-profile');
      // Debug log the raw response
      // ignore: avoid_print
      print('ApiService.getRunnerProfile: response => $response');
      return response as Map<String, dynamic>;
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error al obtener perfil: $e');
    }
  }

  /// Sube la imagen de perfil (multipart) y retorna la URL recibida
  Future<String> uploadProfileImage(File file) async {
    try {
      final uri = Uri.parse(
        '${ApiClient.baseUrl}api/runner-profile/profile-image',
      );

      final token = await TokenStorage.readAccessToken();

      final request = http.MultipartRequest('POST', uri);
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Accept'] = 'application/json';

      // determine mime type from file extension
      final lower = file.path.toLowerCase();
      String mimeType;
      if (lower.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      } else {
        throw ApiException(
          'Tipo de archivo no permitido. Tipos permitidos: image/jpeg, image/png',
          statusCode: 400,
        );
      }

      final filename = file.uri.pathSegments.isNotEmpty
          ? file.uri.pathSegments.last
          : file.path.split(Platform.pathSeparator).last;

      final multipartFile = await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: filename,
        contentType: MediaType(mimeType.split('/')[0], mimeType.split('/')[1]),
      );
      request.files.add(multipartFile);

      final streamed = await request.send();
      final resp = await http.Response.fromStream(streamed);

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final map = jsonDecode(resp.body) as Map<String, dynamic>;
        final data = map['data'] as Map<String, dynamic>?;
        final url = data != null ? data['profileImageUrl']?.toString() : null;
        if (url != null && url.isNotEmpty) return url;
        throw Exception('No profileImageUrl in response');
      } else {
        throw ApiException(
          resp.body.isNotEmpty ? resp.body : 'Upload failed',
          statusCode: resp.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw Exception('Error uploading profile image: $e');
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
