import 'package:expedia/controllers/app_controllers.dart';
import 'package:expedia/forms/airline.dart';
import 'package:expedia/forms/airports.dart';
import 'package:expedia/forms/book_class_type.dart';
import 'package:expedia/forms/city.dart';
import 'package:expedia/forms/country.dart';
import 'package:expedia/forms/documents.dart';
import 'package:expedia/forms/passengers.dart';
import 'package:expedia/pages/auth/login_page.dart';
import 'package:expedia/pages/auth/register_page.dart';
import 'package:expedia/pages/screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

final AuthController authController = AuthController();

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  refreshListenable: authController,
  redirect: (context, state) {
    final isAuthenticated = authController.isAuthenticated;
    final isAuthRoute =
        state.matchedLocation == '/login' || state.matchedLocation == '/register';

    if (!isAuthenticated && !isAuthRoute) {
      return '/login';
    }

    if (isAuthenticated && isAuthRoute) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const Screen(),
    ),
    GoRoute(
      path: '/passengerForm',
      builder: (context, state) => const PassengerForm(),
    ),
    GoRoute(
      path: '/cityForm',
      builder: (context, state) => const CityForm(),
    ),
    GoRoute(
      path: '/docForm',
      builder: (context, state) => const DocForm(),
    ),
    GoRoute(
      path: '/countryForm',
      builder: (context, state) => const CountryForm(),
    ),
    GoRoute(
      path: '/airlineForm',
      builder: (context, state) => const AirlineForm(),
    ),
    GoRoute(
      path: '/airportForm',
      builder: (context, state) => const AirportForm(),
    ),
    GoRoute(
      path: '/bookingClassForm',
      builder: (context, state) => const BookingClassForm(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authController),
        ChangeNotifierProvider(create: (_) => PassengerController()),
        ChangeNotifierProvider(create: (_) => CityController()),
        ChangeNotifierProvider(create: (_) => CountryController()),
        ChangeNotifierProvider(create: (_) => AirlineController()),
        ChangeNotifierProvider(create: (_) => AirportController()),
        ChangeNotifierProvider(create: (_) => PaymentController()),
        ChangeNotifierProvider(create: (_) => DocumentController()),
        ChangeNotifierProvider(create: (_) => BookingClassController()),
        ChangeNotifierProvider(create: (_) => BookingTypeController()),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: "Expedia",
        theme: ThemeData(
          useMaterial3: true,
          useSystemColors: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,
          ),
          brightness: Brightness.light,
          fontFamily: "Urbanist",
          fontFamilyFallback: const ["Texturina"],
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          useSystemColors: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
          brightness: Brightness.dark,
          fontFamily: "Urbanist",
          fontFamilyFallback: const ["Montserrat", "Texturina"],
        ),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
