import 'package:bloc/bloc.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'package:chronochip/src/core/models/get_events_list_response/get_events_list_response.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';
import '../available_event.dart';
import 'available_events_event.dart';
import 'available_events_state.dart';

class AvailableEventsBloc
    extends Bloc<AvailableEventsEvent, AvailableEventsState> {
  final ApiService _apiService;

  AvailableEventsBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(const AvailableEventsInitial()) {
    on<AvailableEventsFetch>(_onFetch);
    on<AvailableEventsReset>(
      (event, emit) => emit(const AvailableEventsInitial()),
    );
  }

  Future<void> _onFetch(
    AvailableEventsFetch event,
    Emitter<AvailableEventsState> emit,
  ) async {
    emit(const AvailableEventsLoading());

    try {
      final response = await _apiService.getEventsList();
      final rows = response.data?.rows ?? [];
      final events = rows
          .map(
            (row) => AvailableEvent(
              id: row.id ?? 0,
              name: row.name ?? '',
              date: row.date ?? '',
              location: row.location ?? '',
              coverImageUrl: row.coverImageUrl,
            ),
          )
          .toList();

      // Keep the full response available in the success state
      final GetEventsListResponse fullResponse = response;
      emit(AvailableEventsSuccess(events: events, response: fullResponse));
    } on ApiException catch (e) {
      final errorMessage = e.statusCode == 401 ? 'No autorizado' : e.message;
      emit(AvailableEventsFailure(error: errorMessage));
    } catch (e) {
      emit(AvailableEventsFailure(error: 'Error al cargar eventos: $e'));
    }
  }
}
