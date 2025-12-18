import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chronochip/src/core/utils/logger_util.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';

class ApiClient {
  static const String baseUrl = 'https://api.crono.stackcloud.com.mx/';

  final http.Client _httpClient;

  ApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  /// Realiza una solicitud GET
  Future<dynamic> get(String endpoint) async {
    final url = '$baseUrl$endpoint';
    try {
      LoggerUtil.logRequest(method: 'GET', url: url, body: null);
      final response = await _httpClient.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return _handleResponse(response, 'GET', url);
    } catch (e, stackTrace) {
      LoggerUtil.logError(
        method: 'GET',
        url: url,
        error: e,
        stackTrace: stackTrace,
      );
      // If the error is already an ApiException, rethrow it to preserve
      // statusCode and original message. Otherwise, wrap it.
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// Realiza una solicitud POST
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final url = '$baseUrl$endpoint';
    try {
      LoggerUtil.logRequest(method: 'POST', url: url, body: body);
      final response = await _httpClient.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response, 'POST', url);
    } catch (e, stackTrace) {
      LoggerUtil.logError(
        method: 'POST',
        url: url,
        error: e,
        stackTrace: stackTrace,
      );
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// Realiza una solicitud PUT
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    final url = '$baseUrl$endpoint';
    try {
      LoggerUtil.logRequest(method: 'PUT', url: url, body: body);
      final response = await _httpClient.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response, 'PUT', url);
    } catch (e, stackTrace) {
      LoggerUtil.logError(
        method: 'PUT',
        url: url,
        error: e,
        stackTrace: stackTrace,
      );
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// Realiza una solicitud DELETE
  Future<dynamic> delete(String endpoint) async {
    final url = '$baseUrl$endpoint';
    try {
      LoggerUtil.logRequest(method: 'DELETE', url: url, body: null);
      final response = await _httpClient.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return _handleResponse(response, 'DELETE', url);
    } catch (e, stackTrace) {
      LoggerUtil.logError(
        method: 'DELETE',
        url: url,
        error: e,
        stackTrace: stackTrace,
      );
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// Maneja la respuesta HTTP
  dynamic _handleResponse(http.Response response, String method, String url) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      LoggerUtil.logResponse(
        method: method,
        url: url,
        statusCode: response.statusCode,
        response: response.body,
      );
      if (response.body.isEmpty) {
        return null;
      }
      return jsonDecode(response.body);
    } else {
      final body = response.body;
      final message = body.isNotEmpty
          ? body
          : (response.reasonPhrase ?? 'HTTP error');

      LoggerUtil.logError(
        method: method,
        url: url,
        error: 'HTTP ${response.statusCode}: $message',
      );

      // Lanzar ApiException con código y mensaje para que la capa superior
      // (Bloc/servicio) pueda manejarlo de forma específica.
      throw ApiException(message, statusCode: response.statusCode);
    }
  }
}
