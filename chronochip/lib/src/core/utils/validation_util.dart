/// Utilidades para validación de datos
class ValidationUtil {
  ValidationUtil._();

  /// Valida que el email tenga formato correcto
  static bool isValidEmail(String email) {
    if (email.isEmpty) {
      return false;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return emailRegex.hasMatch(email);
  }

  /// Valida que el campo no esté vacío
  static bool isNotEmpty(String value) {
    return value.trim().isNotEmpty;
  }

  /// Valida que la contraseña tenga una longitud mínima
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Obtiene mensaje de error para email
  static String getEmailError(String email) {
    if (!isNotEmpty(email)) {
      return 'El email no puede estar vacío';
    }
    if (!isValidEmail(email)) {
      return 'Ingresa un email válido';
    }
    return '';
  }

  /// Obtiene mensaje de error para contraseña
  static String getPasswordError(String password) {
    if (!isNotEmpty(password)) {
      return 'La contraseña no puede estar vacía';
    }
    if (!isValidPassword(password)) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return '';
  }
}
