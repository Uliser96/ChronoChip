import 'dart:io';

import 'package:chronochip/src/presentation/profile/bloc/profile_event.dart';
import 'package:chronochip/src/presentation/profile/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'package:chronochip/src/presentation/profile/bloc/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String fullName = '-';
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/imgs/main_background.png', fit: BoxFit.cover),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    BlocProvider(
                      create: (_) => ProfileBloc(),
                      child: Column(
                        children: [
                          Builder(
                            builder: (innerContext) => GestureDetector(
                              onTap: () async {
                                final picker = ImagePicker();
                                final XFile? picked = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 85,
                                );
                                if (picked != null) {
                                  final file = File(picked.path);
                                  // dispatch upload event using innerContext
                                  final bloc = BlocProvider.of<ProfileBloc>(
                                    innerContext,
                                  );
                                  bloc.add(UploadProfileImage(file));
                                }
                              },
                              child: Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 3,
                                  ),
                                ),
                                child: BlocBuilder<ProfileBloc, ProfileState>(
                                  builder: (context, state) {
                                    if (state is ProfileLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (state is ProfileImageUploadSuccess) {
                                      return ClipOval(
                                        child: Image.network(
                                          state.imageUrl,
                                          fit: BoxFit.cover,
                                          width: 140,
                                          height: 140,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                                color: Colors.grey.shade300,
                                                child: const Icon(
                                                  Icons.person,
                                                  size: 80,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                        ),
                                      );
                                    }

                                    return ClipOval(
                                      child: Container(
                                        color: Colors.grey.shade300,
                                        child: const Icon(
                                          Icons.person,
                                          size: 80,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Distancia Favorita',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '-',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                            height: 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Mejor ritmo / Tiempo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '-',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                            height: 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Km del año',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '-',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                            height: 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tus carreras',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      '-',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.white.withOpacity(0.3),
                            height: 0,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Tus certificados',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.arrow_forward, color: Colors.white),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                    Image.asset(
                      'assets/imgs/logo.png',
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
