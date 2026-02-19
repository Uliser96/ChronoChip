import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/event_detail_info_bloc.dart';
import 'bloc/event_detail_info_event.dart';
import 'bloc/event_detail_info_state.dart';
import 'package:chronochip/src/core/routers/routers.dart';
import 'document_webview_modal.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class EventDetailInfoPage extends StatelessWidget {
  final int eventId;

  const EventDetailInfoPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (_) => EventDetailInfoBloc(eventId: eventId),
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
                    final data = state.eventResponse?.data;

                    if (state.isRefreshing && data == null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (state.error != null && data == null) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Column(
                            children: [
                              Text('Error: ${state.error}'),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () =>
                                    bloc.add(EventDetailInfoRefreshRequested()),
                                child: const Text('Reintentar'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final eventName = data?.name ?? 'Título del evento';
                    final eventDate = data?.date ?? '';
                    final kitPickup =
                        data?.eventInformation?.kitPickupInfo ?? '';
                    final eventLocation = data?.location ?? '';
                    final registrationRange =
                        (data?.registrationStartDate == null ||
                            data?.registrationEndDate == null)
                        ? ''
                        : '${data!.registrationStartDate} - ${data.registrationEndDate}';
                    final documents = data?.documents ?? [];

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
                          primaryText: eventDate.contains('T')
                              ? eventDate.split('T').first
                              : eventDate,
                          secondaryText: eventLocation,
                        ),
                        const SizedBox(height: 8),
                        Text(eventLocation),
                        const SizedBox(height: 18),

                        const Text(
                          'Feria del corredor',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        _InfoCard(
                          header: 'Registro',
                          primaryText: registrationRange,
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
                                  Text(kitPickup),
                                  Text(""),
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
                        if (documents.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'Reglamento',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: documents.map((doc) {
                              final docType = doc.documentType ?? '';
                              return InkWell(
                                onTap: () {
                                  final url = doc.documentUrl;
                                  if (url == null || url.isEmpty) return;
                                  _launchURL(context, url);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          docType,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.open_in_new, size: 18),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

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
                      final data = state.eventResponse?.data;
                      return ElevatedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                                final allow = data?.allowTshirtSize ?? false;
                                var id = 0;
                                final rawId = data?.id;
                                if (rawId is int) {
                                  id = rawId;
                                }
                                Navigator.pushNamed(
                                  context,
                                  Routers.registration,
                                  arguments: {
                                    'allowTshirtSize': allow,
                                    'eventId': id,
                                  },
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

void _launchURL(BuildContext context, String url) async {
  final theme = Theme.of(context);
  try {
    await launchUrl(
      Uri.parse(url),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcons.back,
        ),
        animations: const CustomTabsAnimations(
          startEnter: 'slide_up',
          startExit: 'android:anim/fade_out',
          endEnter: 'android:anim/fade_in',
          endExit: 'slide_down',
        ),
      ),
    );
  } catch (e) {
    // Se lanza una excepción si no hay una aplicación de navegador instalada en el dispositivo Android.
    debugPrint(e.toString());
  }
}
