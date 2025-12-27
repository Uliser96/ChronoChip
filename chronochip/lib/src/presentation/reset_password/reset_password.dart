import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'reset_password_bloc.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResetPasswordBloc(),
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/imgs/main_background.png',
                fit: BoxFit.cover,
              ),
            ),

            // Content above the background: centered card and bottom logo
            Positioned.fill(
              child: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.82,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child:
                              BlocListener<
                                ResetPasswordBloc,
                                ResetPasswordState
                              >(
                                listener: (context, state) {
                                  if (state is ResetPasswordSuccess) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.message),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                  } else if (state is ResetPasswordFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.error)),
                                    );
                                  }
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Recupera tu contraseña',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Email field
                                    TextField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: 'Correo electrónico',
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(
                                          0.18,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 12,
                                            ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        hintStyle: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),

                                    const SizedBox(height: 14),

                                    // Restablecer contraseña button
                                    BlocBuilder<
                                      ResetPasswordBloc,
                                      ResetPasswordState
                                    >(
                                      builder: (context, state) {
                                        final isLoading =
                                            state is ResetPasswordLoading;
                                        return ElevatedButton(
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                                  final email = _emailController
                                                      .text
                                                      .trim();
                                                  if (email.isEmpty) {
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          'Ingrese un correo válido',
                                                        ),
                                                      ),
                                                    );
                                                    return;
                                                  }
                                                  context
                                                      .read<ResetPasswordBloc>()
                                                      .add(
                                                        ResetPasswordSubmitted(
                                                          email: email,
                                                        ),
                                                      );
                                                },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: AppColors.primary,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : const Text(
                                                  'Restablecer contraseña',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                        );
                                      },
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
      ),
    );
  }
}
