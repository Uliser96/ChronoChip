import 'package:flutter/foundation.dart';

/// Gestor de logging para la aplicación
class LoggerUtil {
  LoggerUtil._();

  /// Registra una solicitud HTTP
  static void logRequest({
    required String method,
    required String url,
    required Map<String, dynamic>? body,
  }) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      final separator = '═' * 80;
      final bodyStr = body != null ? '\n📦 Payload: ${_formatJson(body)}' : '';

      final log =
          '''
$separator
🚀 [${method.toUpperCase()}] $timestamp
🔗 URL: $url$bodyStr
$separator
''';
      print(log);
    }
  }

  /// Registra una respuesta exitosa
  static void logResponse({
    required String method,
    required String url,
    required int statusCode,
    required dynamic response,
  }) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      final separator = '═' * 80;
      final responseStr = response is String
          ? _formatJson(response)
          : _formatJson(response.toString());

      final log =
          '''
$separator
✅ [${method.toUpperCase()}] $statusCode $timestamp
🔗 URL: $url
📥 Response: $responseStr
$separator
''';
      print(log);
    }
  }

  /// Registra un error
  static void logError({
    required String method,
    required String url,
    required Object error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final timestamp = _getTimestamp();
      final separator = '═' * 80;

      final log =
          '''
$separator
❌ [${method.toUpperCase()}] ERROR $timestamp
🔗 URL: $url
💥 Error: $error
${stackTrace != null ? '📍 Stack: ${stackTrace.toString()}' : ''}
$separator
''';
      print(log);
    }
  }

  /// Formatea JSON para legibilidad
  static String _formatJson(dynamic json) {
    try {
      if (json is String) {
        final parsed = json;
        if (parsed.length > 200) {
          return parsed.substring(0, 200) + '...';
        }
        return parsed;
      }
      return json.toString();
    } catch (e) {
      return json.toString();
    }
  }

  /// Obtiene timestamp formateado
  static String _getTimestamp() {
    return DateTime.now().toString().split('.')[0];
  }
}
