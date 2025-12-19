import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:chronochip/src/core/services/api/api_service.dart';
import 'package:chronochip/src/core/services/api/api_exception.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final ApiService _apiService;

  RegisterBloc({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<RegisterReset>((event, emit) => emit(RegisterInitial()));
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    try {
      final response = await _apiService.register(
        email: event.email,
        password: event.password,
        firstName: event.firstName,
        lastName: event.lastName,
        birthdate: event.birthdate,
        genderId: event.genderId,
      );

      if (response.data != null) {
        emit(
          RegisterSuccess(
            message: response.data!.message,
            userId: response.data!.userId,
          ),
        );
      } else {
        emit(
          RegisterFailure(
            error: response.message.isNotEmpty
                ? response.message
                : 'Registration failed',
          ),
        );
      }
    } catch (e) {
      if (e is ApiException) {
        emit(RegisterFailure(error: e.message));
      } else {
        emit(RegisterFailure(error: e.toString()));
      }
    }
  }
}
