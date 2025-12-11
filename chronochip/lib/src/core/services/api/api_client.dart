import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chronochip/src/core/utils/logger_util.dart';

class ApiClient {
  static const String baseUrl =
      'https://42240a32-872b-4780-a82b-11965d804431.mock.pstmn.io/';

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
      throw Exception('Error en solicitud GET: $e');
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
      throw Exception('Error en solicitud POST: $e');
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
      throw Exception('Error en solicitud PUT: $e');
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
      throw Exception('Error en solicitud DELETE: $e');
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
      LoggerUtil.logError(
        method: method,
        url: url,
        error: 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
      );
      throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}
