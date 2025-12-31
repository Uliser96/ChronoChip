import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/event_detail_info_bloc.dart';
import 'bloc/event_detail_info_event.dart';
import 'bloc/event_detail_info_state.dart';
import 'package:chronochip/src/core/routers/routers.dart';

class EventDetailInfo {
  final int id;
  final String name;
  final String date;
  final String location;
  final String registrationStartDate;
  final String registrationEndDate;
  final bool finished;

  EventDetailInfo({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.registrationStartDate,
    required this.registrationEndDate,
    required this.finished,
  });

  String get formattedDate {
    if (date.contains('T')) return date.split('T').first;
    return date;
  }

  String get registrationRange {
    if (registrationStartDate.isEmpty || registrationEndDate.isEmpty)
      return 'N/A';
    final from = registrationStartDate.contains('T')
        ? registrationStartDate.split('T').first
        : registrationStartDate;
    final to = registrationEndDate.contains('T')
        ? registrationEndDate.split('T').first
        : registrationEndDate;
    return '$from - $to';
  }
}

class EventDetailInfoPage extends StatelessWidget {
  final EventDetailInfo event;

  const EventDetailInfoPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) =>
          EventDetailInfoBloc(initial: EventDetailInfoState(event: event)),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: theme.scaffoldBackgroundColor,
              automaticallyImplyLeading: true,
              title: const Text(
                'Información de la carrera',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: false,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: BlocBuilder<EventDetailInfoBloc, EventDetailInfoState>(
                  builder: (context, state) {
                    final bloc = context.read<EventDetailInfoBloc>();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Salida',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _InfoCard(
                          header: 'SALIDA 1',
                          primaryText: state.event.formattedDate,
                          secondaryText: '',
                        ),
                        const SizedBox(height: 8),
                        Text(state.event.location),
                        const SizedBox(height: 18),

                        const Text(
                          'Feria del corredor',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _InfoCard(
                          header: 'Registro',
                          primaryText: state.event.registrationRange,
                          secondaryText: '',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Entrega de kit:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Fecha: ${state.event.registrationStartDate}',
                                  ),
                                  Text('Lugar: ${state.event.location}'),
                                ],
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  bloc.add(EventDetailInfoRefreshRequested()),
                              child: const Text('Ver más'),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),
                        const Divider(),
                        const SizedBox(height: 8),
                        const Text(
                          'Reglamento',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'www.5khollywoodchallenge.mx',
                            style: TextStyle(
                              color: theme.primaryColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        const SizedBox(height: 90),
                      ],
                    );
                  },
                ),
              ),
            ),
            bottomNavigationBar: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 12.0,
                ),
                child: SizedBox(
                  height: 52,
                  width: double.infinity,
                  child: BlocBuilder<EventDetailInfoBloc, EventDetailInfoState>(
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                                Navigator.pushNamed(
                                  context,
                                  Routers.raceRegistration,
                                  arguments: state.event,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF08A00),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Inscripción',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String header;
  final String primaryText;
  final String secondaryText;

  const _InfoCard({
    Key? key,
    required this.header,
    required this.primaryText,
    required this.secondaryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFE0E0E0),
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            child: Center(
              child: Text(
                header,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  primaryText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text(
                  secondaryText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
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
