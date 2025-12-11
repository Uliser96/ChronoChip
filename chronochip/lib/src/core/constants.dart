/// Constantes de la aplicación
class AppConstants {
  AppConstants._();

  /// URLs de endpoints
  static const String baseUrl =
      'https://42240a32-872b-4780-a82b-11965d804431.mock.pstmn.io/';

  /// Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);

  /// Headers por defecto
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
