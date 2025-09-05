import '../models/passengers.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'backend_connect.dart';

GetIt getIt = GetIt.instance;

final db = getIt.get<DbConnect>();

class PassengerConfig {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: db.host,
      connectTimeout: const Duration(milliseconds: 7000),
      receiveTimeout: const Duration(milliseconds: 7000),
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
    print('API response data: ${response.data}');
    if (response.data is List) {
      return response.data as List<dynamic>;
    } else {
      throw Exception('Invalid data format');
    }
  }

  // map to the classes
  Future<List<Passenger>> mapPassengers() async {
    final passengers = <Passenger>[];
    final data = await getPassengers();
    // print(data);
    for (final passenger in data) {
      passengers.add(Passenger.fromJson(passenger));
    }
    print("The processed passengers are: $passengers");
    return passengers;
  }

  // save passengers
  Future<String> savePassenger(Passenger passenger) async {
    try {
      final response = await _dio.post(
        "$endpoint/save",
        data: passenger.toJson(),
      );
      print('API save passenger response data: ${response.data}');
      return response.data;
    } catch (e) {
      return "Failure to save passenger: $e";
    }
  }
}
