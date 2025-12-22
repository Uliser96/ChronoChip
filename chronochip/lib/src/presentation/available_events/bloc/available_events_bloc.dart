import 'package:bloc/bloc.dart';
import 'available_events_event.dart';
import 'available_events_state.dart';
import 'package:chronochip/src/core/services/api/api_client.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';
import '../available_event.dart';
import 'package:chronochip/src/core/utils/logger_util.dart';

class AvailableEventsBloc
    extends Bloc<AvailableEventsEvent, AvailableEventsState> {
  final ApiClient _apiClient;

  AvailableEventsBloc({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient(),
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
      LoggerUtil.logRequest(method: 'GET', url: 'api/events', body: null);
      final body = await _apiClient.get('api/events');

      final rows = body?['data']?['rows'] as List<dynamic>? ?? [];
      final events = rows
          .map((e) => AvailableEvent.fromJson(e as Map<String, dynamic>))
          .toList();

      LoggerUtil.logResponse(
        method: 'GET',
        url: 'api/events',
        statusCode: 200,
        response: body?.toString() ?? '',
      );

      emit(AvailableEventsSuccess(events: events));
    } on ApiException catch (e) {
      final errorMessage = e.statusCode == 401 ? 'No autorizado' : e.message;
      LoggerUtil.logError(
        method: 'GET',
        url: 'api/events',
        error: errorMessage,
      );
      emit(AvailableEventsFailure(error: errorMessage));
    } catch (e) {
      LoggerUtil.logError(
        method: 'GET',
        url: 'api/events',
        error: e.toString(),
      );
      emit(AvailableEventsFailure(error: 'Error al cargar eventos: $e'));
    }
  }
}
