import 'package:flutter/material.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'package:chronochip/src/core/routers/routers.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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

          Positioned.fill(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Top logo
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Image.asset(
                      'assets/imgs/logo.png',
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Middle spacer and action buttons
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, Routers.register);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Regístrarse',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routers.login);
                            },
                            child: Text(
                              'Iniciar sesión',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom slogan image
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Image.asset(
                      'assets/imgs/slogan.png',
                      height: 80,
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
