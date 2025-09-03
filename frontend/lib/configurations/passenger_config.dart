import '../models/passengers.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'backend_connect.dart';

GetIt getIt = GetIt.instance;

final db = getIt.get<DbConnect>();

class PassengerConfig {
  final String _host = 'http://127.0.0.1:8000/';
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: db.host,
      connectTimeout: const Duration(milliseconds: 7000),
    ),
  );
  final endpoint = "passengers";

  // connection to the database
  PassengerConfig() {
    db.connection();
  }

  // get all passengers
  Future<List<dynamic>> getPassengers() async {
    final response = await _dio.get(endpoint);
    return response.data;
  }

  // map to the classes
  Future<List<Passenger>> mapPassengers() async {
    final passengers = <Passenger>[];
    final data = await getPassengers();
    for (final passenger in data) {
      passengers.add(Passenger.fromJson(passenger));
    }
    return passengers;
  }
}
