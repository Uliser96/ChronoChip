import 'package:flutter/material.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final media = MediaQuery.of(context);
    final availableHeight =
        media.size.height - bottomInset - media.padding.vertical;

    return Scaffold(
      // keep default resizeToAvoidBottomInset so viewInsets are updated
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/imgs/main_background.png',
              fit: BoxFit.cover,
            ),
          ),

          // SafeArea to avoid notches
          Positioned.fill(
            child: SafeArea(
              child: Stack(
                children: [
                  // Centered card that will move up when keyboard appears
                  // Use a scrollable column so the card can be fully visible
                  // when the keyboard is open instead of being cut off.
                  SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: bottomInset + 24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: availableHeight),
                      child: Center(
                        child: Container(
                          width: media.size.width * 0.82,
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Registro Usuario',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 12),

                              // Password field
                              TextField(
                                obscureText: true,
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
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),

                              // Name field
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Nombre',
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
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),

                              // Email field
                              TextField(
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
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),

                              // Age field
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Edad',
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
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 12),

                              // Gender field
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Género',
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
                                ),
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 16),

                              // Complete register button
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Completar registro',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom logo removed per request — card stays centered
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
