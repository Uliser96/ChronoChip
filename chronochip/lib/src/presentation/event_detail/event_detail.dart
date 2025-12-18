import 'package:flutter/material.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'package:chronochip/src/core/services/api/api_client.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';

class EventDetailPage extends StatefulWidget {
  final int eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _loading = false;
  String? _error;
  _EventDetail? _event;

  @override
  void initState() {
    super.initState();
    _fetchEvent();
  }

  Future<void> _fetchEvent() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ApiClient();
      final body = await api.get('api/events/${widget.eventId}');
      final data = body?['data'] as Map<String, dynamic>?;
      if (data != null) {
        _event = _EventDetail.fromJson(data);
      } else {
        _error = 'Evento no encontrado';
      }
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      if (mounted) setState(() => _loading = false);
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/imgs/main_background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.arrow_back),
                            color: Colors.black,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_loading) ...[
                        const SizedBox(height: 24),
                        const Center(child: CircularProgressIndicator()),
                      ] else if (_error != null) ...[
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ] else if (_event != null) ...[
                        Text(
                          _event!.name,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_event!.location} • ${_event!.date}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            _SmallOutlinedButton(
                              label: 'Información',
                              icon: Icons.info_outline,
                            ),
                            const SizedBox(width: 12),
                            _SmallOutlinedButton(
                              label: 'Convocatoria',
                              icon: Icons.description_outlined,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const Spacer(),
                if (_event != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Image.asset(
                      'assets/imgs/logo.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        _LargePillButton(
                          width: width,
                          label: 'Inscripciones',
                          sublabel: _event!.registrationStatusLabel,
                          backgroundColor: AppColors.primary,
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                        const SizedBox(height: 12),
                        _LargePillButton(
                          width: width,
                          label: 'Clasificaciones',
                          sublabel: 'Pendientes',
                          backgroundColor: Colors.grey.shade800,
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EventDetail {
  final String name;
  final String date;
  final String location;
  final String registrationStartDate;
  final String registrationEndDate;

  _EventDetail({
    required this.name,
    required this.date,
    required this.location,
    required this.registrationStartDate,
    required this.registrationEndDate,
  });

  factory _EventDetail.fromJson(Map<String, dynamic> json) {
    return _EventDetail(
      name: json['name'] as String? ?? '',
      date: json['date'] as String? ?? '',
      location: json['location'] as String? ?? '',
      registrationStartDate: json['registrationStartDate'] as String? ?? '',
      registrationEndDate: json['registrationEndDate'] as String? ?? '',
    );
  }

  String get registrationStatusLabel {
    if (registrationStartDate.isEmpty || registrationEndDate.isEmpty)
      return 'N/A';
    return '${registrationStartDate.split('T').first} - ${registrationEndDate.split('T').first}';
  }
}

class _SmallOutlinedButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SmallOutlinedButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Icon(icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LargePillButton extends StatelessWidget {
  final double width;
  final String label;
  final String sublabel;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _LargePillButton({
    required this.width,
    required this.label,
    required this.sublabel,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 4,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sublabel,
              style: TextStyle(
                color: textColor.withOpacity(0.95),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
