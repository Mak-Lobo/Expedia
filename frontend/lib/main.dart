import 'package:expedia/forms/airline.dart';
import 'package:expedia/forms/country.dart';
import 'package:expedia/forms/documents.dart';
import 'package:expedia/pages/dashboard.dart';
import 'forms/passengers.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'forms/city.dart';

void main() {
  runApp(const MyApp());
}

// go routes

final _router = GoRouter(
  initialLocation: "/passengerForm",
  navigatorKey: GlobalKey<NavigatorState>(),
  routes: [
    GoRoute(path: "/", builder: (context, state) => const Dashboard()),
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
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        useSystemColors: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
    );
  }
}
