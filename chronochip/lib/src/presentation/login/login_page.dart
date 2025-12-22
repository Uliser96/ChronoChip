import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'package:chronochip/src/core/routers/routers.dart';
import 'package:chronochip/src/core/utils/validation_util.dart';
import 'bloc/login_bloc.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';
import 'package:chronochip/src/presentation/code_validation/code_validation_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  String? _emailError;
  String? _passwordError;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    // Validar en tiempo real
    _emailController.addListener(_validateEmail);
    _passwordController.addListener(_validatePassword);
  }

  void _validateEmail() {
    setState(() {
      final error = ValidationUtil.getEmailError(_emailController.text);
      _emailError = error.isEmpty ? null : error;
    });
  }

  void _validatePassword() {
    setState(() {
      final error = ValidationUtil.getPasswordError(_passwordController.text);
      _passwordError = error.isEmpty ? null : error;
    });
  }

  bool _isFormValid() {
    return ValidationUtil.isValidEmail(_emailController.text) &&
        ValidationUtil.isValidPassword(_passwordController.text);
  }

  void _handleLogin() {
    if (!_isFormValid()) {
      _validateEmail();
      _validatePassword();
      return;
    }

    context.read<LoginBloc>().add(
      LoginSubmitted(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/imgs/main_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Content above the background: centered login card and bottom logo
          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: BlocListener<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is LoginSuccess) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              Routers.home,
                              (route) => false,
                            );
                          } else if (state is LoginEmailNotVerified) {
                            // Use parent context for navigation / SnackBars to avoid accessing
                            // a deactivated context after dialog is closed.
                            final parentContext = context;
                            showDialog<void>(
                              context: parentContext,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  content: const Text(
                                    'Correo electronico no verificado, por favor verifiquelo',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(),
                                      child: const Text('Cancelar'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        Navigator.of(dialogContext).pop();
                                        final email = _emailController.text
                                            .trim();
                                        try {
                                          final api = ApiService();
                                          await api.requestVerificationCode(
                                            email: email,
                                          );
                                          Future.microtask(() {
                                            Navigator.of(parentContext).push(
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    CodeValidationPage(
                                                      email: email,
                                                    ),
                                              ),
                                            );
                                          });
                                        } catch (e) {
                                          Future.microtask(() {
                                            if (e is ApiException) {
                                              ScaffoldMessenger.of(
                                                parentContext,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(e.message),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(
                                                parentContext,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString()),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          });
                                        }
                                      },
                                      child: const Text('De acuerdo'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else if (state is LoginFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.82,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Iniciar sesión',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 16),

                              // Email field
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'Correo electrónico',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.18),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                  errorText: _emailError,
                                  errorStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),

                              // Password field
                              TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  hintText: 'Contraseña',
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.18),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: const TextStyle(
                                    color: Colors.white70,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.white70,
                                    ),
                                    splashRadius: 18,
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  errorText: _passwordError,
                                  errorStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 10),

                              // Login button
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  final isButtonEnabled =
                                      _isFormValid() && state is! LoginLoading;

                                  return ElevatedButton(
                                    onPressed: isButtonEnabled
                                        ? _handleLogin
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: AppColors.primary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      disabledBackgroundColor: Colors.white
                                          .withOpacity(0.5),
                                    ),
                                    child: state is LoginLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    AppColors.primary,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            'Iniciar sesión',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  );
                                },
                              ),

                              const SizedBox(height: 8),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routers.resetPassword,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                  ),
                                  child: const Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Image.asset(
                      'assets/imgs/logo.png',
                      height: 90,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
