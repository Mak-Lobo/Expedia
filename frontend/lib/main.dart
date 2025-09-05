import 'package:expedia/configurations/backend_connect.dart';
import 'package:expedia/configurations/city_config.dart';
import 'package:expedia/configurations/passenger_config.dart';
import 'package:expedia/forms/airline.dart';
import 'package:expedia/forms/country.dart';
import 'package:expedia/forms/documents.dart';
import 'package:expedia/pages/screen.dart';
import 'package:get_it/get_it.dart';
import 'forms/passengers.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'forms/city.dart';

void main() {
  setupInstances();
  runApp(const MyApp());
}

// get_it instances
GetIt getIt = GetIt.instance;

void setupInstances() {
  getIt.registerLazySingleton<DbConnect>(() => DbConnect());
  getIt.registerLazySingleton<PassengerForm>(() => PassengerForm());
  getIt.registerLazySingleton<CityForm>(() => CityForm());
  getIt.registerLazySingleton<PassengerConfig>(() => PassengerConfig());
  getIt.registerLazySingleton<DocForm>(() => DocForm());
  getIt.registerLazySingleton<CityConfig>(() => CityConfig());
}

// go routes
final _router = GoRouter(
  initialLocation: "/",
  navigatorKey: GlobalKey<NavigatorState>(),
  routes: [
    GoRoute(path: "/", builder: (context, state) => const Screen()),
    GoRoute(
      path: "/passengerForm",
      builder: (context, state) => const PassengerForm(),
    ),
    GoRoute(path: "/cityForm", builder: (context, state) => const CityForm()),
    GoRoute(path: "/docForm", builder: (context, state) => const DocForm()),
    GoRoute(
      path: "/countryForm",
      builder: (context, state) => const CountryForm(),
    ),
    GoRoute(
      path: "/airlineForm",
      builder: (context, state) => const AirlineForm(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
        fontFamilyFallback: ["Texturina"],
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
        fontFamilyFallback: ["Montserrat", "Texturina"],
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
