import 'package:flutter/material.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';

class AvailableEventsPage extends StatelessWidget {
  const AvailableEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset('assets/imgs/main_background.png', fit: BoxFit.cover),
          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '¡Es momento de elegir',
                        style: TextStyle(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: AppColors.primary,
                        ),
                      ),
                      const Text(
                        'tu próximo reto!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Search bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar',
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Events list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      _buildEventCard(
                        title: 'Love Run',
                        date: '16 / 02 / 25',
                        location: 'Cuernavaca, Mor.',
                      ),
                      const SizedBox(height: 12),
                      _buildEventCard(
                        title: '5K Hollywood Challenge',
                        date: '18 / 02 / 25',
                        location: 'Puebla, Pue.',
                      ),
                      const SizedBox(height: 12),
                      _buildEventCard(
                        title: 'Monarca Trail',
                        date: '09 / 03 / 25',
                        location: 'Angangueo, Mich.',
                      ),
                      const SizedBox(height: 12),
                      _buildEventCard(
                        title: 'Entre Cerros 2025',
                        date: '16 / 03 / 25',
                        location: 'Peña de Bernal, Qro.',
                      ),
                      const SizedBox(height: 12),
                      _buildEventCard(
                        title: 'Transnavajas',
                        date: '21 / 09 / 25',
                        location: 'Mineral del Monte, Hgo.',
                      ),
                      const SizedBox(height: 12),
                      _buildEventCard(
                        title: 'Reto Vulcano',
                        date: '11 / 10 / 25',
                        location: 'Atzintzán, Pue.',
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String location,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.image, color: Colors.grey.shade600, size: 40),
            ),
            const SizedBox(width: 16),
            // Event info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
