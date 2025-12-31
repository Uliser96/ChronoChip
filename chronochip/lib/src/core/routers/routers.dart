import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chronochip/src/presentation/login/login_page.dart';
import 'package:chronochip/src/presentation/login/bloc/login_bloc.dart';
import 'package:chronochip/src/presentation/register/register.dart';
import 'package:chronochip/src/presentation/register/bloc/gender_bloc.dart';
import 'package:chronochip/src/presentation/reset_password/reset_password.dart';
import 'package:chronochip/src/presentation/welcome/welcome.dart';
import 'package:chronochip/src/presentation/home/home_page.dart';
import 'package:chronochip/src/presentation/event_detail_info/event_detail_info_page.dart';
import 'package:chronochip/src/presentation/race_registration/race_registration_page.dart';
import 'package:chronochip/src/presentation/payment/payment_page.dart';

/// Centralized app routes.
class Routers {
  Routers._();

  static const String welcome = '/';
  static const String login = '/login';
  static const String resetPassword = '/reset-password';
  static const String register = '/register';
  static const String home = '/home';
  static const String eventDetailInfo = '/event-detail-info';
  static const String raceRegistration = '/race-registration';
  static const String payment = '/payment';

  static Map<String, WidgetBuilder> get routes => {
    welcome: (context) => const WelcomePage(),
    login: (context) => BlocProvider(
      create: (context) => LoginBloc(),
      child: const LoginPage(),
    ),
    resetPassword: (context) => const ResetPasswordPage(),
    register: (context) => BlocProvider(
      create: (context) => GenderBloc(),
      child: const RegisterPage(),
    ),
    home: (context) => const HomePage(),
    eventDetailInfo: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is EventDetailInfo) {
        return EventDetailInfoPage(event: args);
      }
      final fallback = EventDetailInfo(
        id: 0,
        name: '',
        date: '',
        location: '',
        registrationStartDate: '',
        registrationEndDate: '',
        finished: false,
      );
      return EventDetailInfoPage(event: fallback);
    },
    raceRegistration: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is EventDetailInfo) {
        return RaceRegistrationPage(eventId: args.id, event: args.event);
      }
      return const RaceRegistrationPage(eventId: 0, event: null);
    },
    payment: (context) => const PaymentPage(),
  };
}
