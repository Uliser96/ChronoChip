import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chronochip/src/shared/theme/app_colors.dart';
import 'package:chronochip/src/presentation/event_detail/event_detail.dart';
import 'package:chronochip/src/core/models/get_events_list_response/get_events_list_response.dart';
import 'available_event.dart';
import 'bloc/available_events_bloc.dart';
import 'bloc/available_events_event.dart';
import 'bloc/available_events_state.dart';

class AvailableEventsPage extends StatefulWidget {
  const AvailableEventsPage({super.key});

  @override
  State<AvailableEventsPage> createState() => _AvailableEventsPageState();
}

class _AvailableEventsPageState extends State<AvailableEventsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AvailableEvent> _filtered = [];
  late final AvailableEventsBloc _bloc;
  final TextStyle _eventInfoStyle = TextStyle(
    fontSize: 12,
    color: Colors.grey.shade600,
  );

  List<AvailableEvent> _sourceEvents() {
    final state = _bloc.state;
    return state is AvailableEventsSuccess ? state.events : <AvailableEvent>[];
  }

  @override
  void initState() {
    super.initState();
    _bloc = AvailableEventsBloc();
    _bloc.add(const AvailableEventsFetch());
    _filtered = _sourceEvents();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onSearchChanged() {
    final q = _searchController.text.toLowerCase();
    final source = _sourceEvents();
    setState(() {
      if (q.isEmpty) {
        _filtered = List.from(source);
      } else {
        _filtered = source.where((e) {
          return e.name.toLowerCase().contains(q) ||
              e.location.toLowerCase().contains(q);
        }).toList();
      }
    });
  }

  Widget _iconTextRow(IconData icon, String text, {bool expanded = false}) {
    final textWidget = Text(
      text,
      style: _eventInfoStyle,
      maxLines: expanded ? 1 : null,
      overflow: expanded ? TextOverflow.ellipsis : TextOverflow.visible,
    );

    if (expanded) {
      return Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Expanded(child: textWidget),
        ],
      );
    }

    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        textWidget,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AvailableEventsBloc>.value(
      value: _bloc,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/imgs/main_background.png', fit: BoxFit.cover),
            SafeArea(
              child: Column(
                children: [
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
                        TextField(
                          controller: _searchController,
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildBody(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<AvailableEventsBloc, AvailableEventsState>(
      builder: (context, state) {
        if (state is AvailableEventsLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is AvailableEventsFailure) {
          return Center(child: Text(state.error));
        }

        final events = state is AvailableEventsSuccess
            ? state.events
            : <AvailableEvent>[];
        if (_filtered.isEmpty && events.isEmpty) {
          return const Center(child: Text('No hay eventos disponibles'));
        }

        final list = _filtered.isNotEmpty ? _filtered : events;

        return ListView.separated(
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final e = list[index];
            return _buildEventCard(
              id: e.id,
              title: e.name,
              date: e.date,
              location: e.location,
              imageUrl: e.coverImageUrl,
              onTap: () {
                final state = _bloc.state;
                if (state is AvailableEventsSuccess) {
                  final GetEventsListResponse resp = state.response;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          EventDetailPage(eventId: e.id, eventsResponse: resp),
                    ),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEventCard({
    required int id,
    required String title,
    required String date,
    required String location,
    String? imageUrl,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap:
          onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EventDetailPage(
                  eventId: id,
                  eventsResponse: GetEventsListResponse(),
                ),
              ),
            );
          },
      child: Container(
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
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: (imageUrl != null && imageUrl.isNotEmpty)
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.image,
                            color: Colors.grey.shade600,
                            size: 40,
                          ),
                          loadingBuilder: (_, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Icon(Icons.image, color: Colors.grey.shade600, size: 40),
              ),
              const SizedBox(width: 16),
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
                    _iconTextRow(Icons.calendar_today, date),
                    const SizedBox(height: 4),
                    _iconTextRow(Icons.location_on, location, expanded: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
