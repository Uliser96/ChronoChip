import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper para flutter_secure_storage que centraliza accesos a tokens
class TokenStorage {
  TokenStorage._();

  static const _accessKey = 'ACCESS_TOKEN';
  static const _refreshKey = 'REFRESH_TOKEN';

  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Guarda access y refresh tokens
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  /// Lee access token
  static Future<String?> readAccessToken() async {
    return _storage.read(key: _accessKey);
  }

  /// Lee refresh token
  static Future<String?> readRefreshToken() async {
    return _storage.read(key: _refreshKey);
  }

  /// Elimina ambos tokens
  static Future<void> deleteTokens() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }

  /// Clear all keys (use with cuidado)
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
