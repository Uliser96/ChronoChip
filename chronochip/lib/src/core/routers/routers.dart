import 'package:flutter/widgets.dart';
import 'package:chronochip/src/presentation/login/login_page.dart';
import 'package:chronochip/src/presentation/reset_password/reset_password.dart';
import 'package:chronochip/src/presentation/welcome/welcome.dart';
import 'package:chronochip/src/presentation/register/register.dart';

/// Centralized app routes.
class Routers {
  Routers._();

  static const String welcome = '/';
  static const String login = '/login';
  static const String resetPassword = '/reset-password';
  static const String register = '/register';

  static Map<String, WidgetBuilder> get routes => {
    welcome: (context) => const WelcomePage(),
    login: (context) => const LoginPage(),
    resetPassword: (context) => const ResetPasswordPage(),
    register: (context) => const RegisterPage(),
  };
}
