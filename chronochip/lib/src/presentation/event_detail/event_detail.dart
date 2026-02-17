import 'package:flutter/material.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'package:chronochip/src/core/routers/routers.dart';
import 'package:chronochip/src/presentation/event_detail_info/event_detail_info_page.dart';
import 'package:chronochip/src/core/models/get_events_list_response/get_events_list_response.dart';
// API calls removed from this screen per requirements

class EventDetailPage extends StatefulWidget {
  final int eventId;
  final GetEventsListResponse eventsResponse;

  const EventDetailPage({
    super.key,
    required this.eventId,
    required this.eventsResponse,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  // API removed: this screen now shows static structure only.

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final selected = (() {
      final rows = widget.eventsResponse.data?.rows;
      if (rows == null) return null;
      for (var r in rows) {
        if (r.id == widget.eventId) return r;
      }
      return null;
    })();
    final bool isFinished = selected?.finished ?? false;

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
                      const SizedBox(height: 8),
                      Text(
                        selected?.name ?? 'Título del evento',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${selected?.location ?? '-'} • ${selected?.date ?? '-'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: SizedBox(
                          width: width * 0.6,
                          child: _SmallOutlinedButton(
                            label: 'Información',
                            icon: Icons.info_outline,
                            expanded: false,
                            // navigate using named route and pass event info
                            onPressed: () {
                              if (selected == null) {
                                Navigator.pushNamed(
                                  context,
                                  Routers.eventDetailInfo,
                                );
                                return;
                              }
                              final info = EventDetailInfo(
                                id: selected!.id ?? 0,
                                name: selected!.name ?? '',
                                date: selected!.date ?? '',
                                location: selected!.location ?? '',
                                registrationStartDate: '',
                                registrationEndDate: '',
                                finished: selected!.finished ?? false,
                                event: selected!.toMap(),
                              );
                              Navigator.pushNamed(
                                context,
                                Routers.eventDetailInfo,
                                arguments: info,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Image.asset(
                        'assets/imgs/logo.png',
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
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
                        sublabel: isFinished ? 'Cerradas' : 'Abiertas',
                        backgroundColor: isFinished
                            ? Colors.grey.shade400
                            : AppColors.primary,
                        textColor: Colors.white,
                        onPressed: isFinished
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  Routers.raceRegistration,
                                );
                              },
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
            ),
          ),
        ],
      ),
    );
  }
}

// _EventDetail and parsing removed: this screen no longer fetches API data

class _SmallOutlinedButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? subtitle;
  final VoidCallback? onPressed;
  final bool expanded;

  const _SmallOutlinedButton({
    required this.label,
    required this.icon,
    this.subtitle,
    this.onPressed,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null && subtitle!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );

    if (expanded) return Expanded(child: button);
    return button;
  }
}

class _LargePillButton extends StatelessWidget {
  final double width;
  final String label;
  final String sublabel;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onPressed;

  const _LargePillButton({
    required this.width,
    required this.label,
    required this.sublabel,
    required this.backgroundColor,
    required this.textColor,
    this.onPressed,
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
