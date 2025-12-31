import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chronochip/src/core/utils/logger_util.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';
import 'package:chronochip/src/core/services/token_storage.dart';
import 'package:chronochip/src/core/models/login_response.dart';

class ApiClient {
  static const String baseUrl = 'https://api.crono.stackcloud.com.mx/';

  final http.Client _httpClient;

  // Si hay un refresh en curso, referencias a esta Future permiten que otras
  // solicitudes esperen al resultado en lugar de lanzar múltiples refresh.
  Future<void>? _refreshFuture;

  ApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  Future<Map<String, String>> _buildHeaders() async {
    final token = await TokenStorage.readAccessToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  /// Realiza una solicitud GET
  Future<dynamic> get(String endpoint, {bool retry = true}) async {
    final url = '$baseUrl$endpoint';
    try {
      final headers = await _buildHeaders();
      LoggerUtil.logRequest(method: 'GET', url: url, body: null);
      final response = await _httpClient.get(Uri.parse(url), headers: headers);
      return _handleResponse(response, 'GET', url);
    } catch (e, stackTrace) {
      LoggerUtil.logError(
        method: 'GET',
        url: url,
        error: e,
        stackTrace: stackTrace,
      );

      if (e is ApiException &&
          e.statusCode == 401 &&
          retry &&
          !_isAuthEndpoint(endpoint)) {
        await _refreshTokenIfNeeded();
        return get(endpoint, retry: false);
      }

      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// Realiza una solicitud POST
  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool retry = true,
  }) async {
    final url = '$baseUrl$endpoint';
    try {
      LoggerUtil.logRequest(method: 'POST', url: url, body: body);
      final headers = await _buildHeaders();
      final response = await _httpClient.post(
        Uri.parse(url),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      // handle temporary redirect (307) by following 'location' header once
      if (response.statusCode == 307) {
        final location = response.headers['location'];
        LoggerUtil.logError(
          method: 'POST',
          url: url,
          error: 'HTTP 307, location: $location',
        );
        if (location != null && location.isNotEmpty) {
          // build redirect url (absolute or relative)
          final redirectUrl = location.startsWith('http')
              ? location
              : (baseUrl +
                    (location.startsWith('/')
                        ? location.substring(1)
                        : location));
          LoggerUtil.logRequest(
            method: 'POST (redirect)',
            url: redirectUrl,
            body: body,
          );
          final redirectResp = await _httpClient.post(
            Uri.parse(redirectUrl),
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          return _handleResponse(redirectResp, 'POST', redirectUrl);
        }
      }

      return _handleResponse(response, 'POST', url);
    } catch (e, stackTrace) {
      LoggerUtil.logError(
        method: 'POST',
        url: url,
        error: e,
        stackTrace: stackTrace,
      );

      if (e is ApiException &&
          e.statusCode == 401 &&
          retry &&
          !_isAuthEndpoint(endpoint)) {
        await _refreshTokenIfNeeded();
        return post(endpoint, body: body, retry: false);
      }

      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// Realiza una solicitud PUT
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    bool retry = true,
  }) async {
    final url = '$baseUrl$endpoint';
    try {
      LoggerUtil.logRequest(method: 'PUT', url: url, body: body);
      final headers = await _buildHeaders();
      final response = await _httpClient.put(
        Uri.parse(url),
        headers: headers,
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

      if (e is ApiException &&
          e.statusCode == 401 &&
          retry &&
          !_isAuthEndpoint(endpoint)) {
        await _refreshTokenIfNeeded();
        return put(endpoint, body: body, retry: false);
      }

      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  /// Realiza una solicitud DELETE
  Future<dynamic> delete(String endpoint, {bool retry = true}) async {
    final url = '$baseUrl$endpoint';
    try {
      LoggerUtil.logRequest(method: 'DELETE', url: url, body: null);
      final headers = await _buildHeaders();
      final response = await _httpClient.delete(
        Uri.parse(url),
        headers: headers,
      );
      return _handleResponse(response, 'DELETE', url);
    } catch (e, stackTrace) {
      LoggerUtil.logError(
        method: 'DELETE',
        url: url,
        error: e,
        stackTrace: stackTrace,
      );

      if (e is ApiException &&
          e.statusCode == 401 &&
          retry &&
          !_isAuthEndpoint(endpoint)) {
        await _refreshTokenIfNeeded();
        return delete(endpoint, retry: false);
      }

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

  bool _isAuthEndpoint(String endpoint) {
    final lower = endpoint.toLowerCase();
    return lower.contains('/api/auth/login') ||
        lower.contains('/api/auth/refresh');
  }

  Future<void> _refreshTokenIfNeeded() async {
    if (_refreshFuture != null) return _refreshFuture!;
    _refreshFuture = _doRefresh();
    try {
      await _refreshFuture;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<void> _doRefresh() async {
    LoggerUtil.logRequest(
      method: 'POST',
      url: '${baseUrl}api/auth/refresh',
      body: null,
    );

    final refreshToken = await TokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      LoggerUtil.logError(
        method: 'POST',
        url: '${baseUrl}api/auth/refresh',
        error: 'No refresh token available',
      );
      // Forzar logout behavior upstream by throwing 401
      await TokenStorage.deleteTokens();
      throw ApiException('No refresh token', statusCode: 401);
    }

    final response = await _httpClient.post(
      Uri.parse('${baseUrl}api/auth/refresh'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      LoggerUtil.logResponse(
        method: 'POST',
        url: '${baseUrl}api/auth/refresh',
        statusCode: response.statusCode,
        response: response.body,
      );

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      try {
        final parsed = LoginResponse.fromJson(json);
        if (parsed.data != null && parsed.data!.accessToken.isNotEmpty) {
          await TokenStorage.saveTokens(
            accessToken: parsed.data!.accessToken,
            refreshToken: parsed.data!.refreshToken,
          );
          return;
        } else {
          await TokenStorage.deleteTokens();
          throw ApiException('Refresh failed', statusCode: response.statusCode);
        }
      } catch (e) {
        await TokenStorage.deleteTokens();
        throw ApiException(
          'Invalid refresh response',
          statusCode: response.statusCode,
        );
      }
    } else {
      LoggerUtil.logError(
        method: 'POST',
        url: '${baseUrl}api/auth/refresh',
        error: 'HTTP ${response.statusCode}: ${response.body}',
      );
      if (response.statusCode == 401) {
        // Refresh token invalid — borrar tokens y propagar 401 para forzar logout
        await TokenStorage.deleteTokens();
        throw ApiException(
          response.body.isNotEmpty ? response.body : 'Unauthorized',
          statusCode: 401,
        );
      }
      throw ApiException(
        response.body.isNotEmpty ? response.body : 'Refresh failed',
        statusCode: response.statusCode,
      );
    }
  }
}
