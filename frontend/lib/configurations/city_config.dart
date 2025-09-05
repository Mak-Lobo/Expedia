import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'backend_connect.dart';
import '../models/city.dart';

final db = GetIt.instance.get<DbConnect>();

class CityConfig {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: db.host,
      connectTimeout: const Duration(milliseconds: 7000),
      receiveTimeout: const Duration(milliseconds: 7000),
    ),
  );
  final endpoint = "cities";

  CityConfig() {
    db.connection();
  }

  // getting cities function
  Future<List<dynamic>> getAllCities() async {
    final response = await _dio.get(endpoint);
    print('API response data: ${response.data}');
    if (response.data is List) {
      return response.data as List<dynamic>;
    } else {
      throw Exception('Invalid data format');
    }
  }

  // getting cities with identified countries
  Future<List<dynamic>> getCitiesWithCountry() async {
    final response = await _dio.get("$endpoint/countries");
    print('API response data: ${response.data}');
    if (response.data is List) {
      return response.data as List<dynamic>;
    } else {
      throw Exception('Invalid data format');
    }
  }

  // mapping cities and cities with countries to the respective classes
  Future<List<City>> mapCities() async {
    final cities = <City>[];
    final data = await getAllCities();
    for (final city in data) {
      cities.add(City.fromJson(city));
    }
    return cities;
  }

  Future<List<CityCountry>> mapCitiesCountry() async {
    final cities = <CityCountry>[];
    final data = await getCitiesWithCountry();
    for (final city in data) {
      cities.add(CityCountry.fromJson(city));
    }
    return cities;
  }

  // saving a city
  Future<String> saveCity(City city) async {
    try {
      final response = await _dio.post("$endpoint/save", data: city.toJson());
      print('API save city response data: ${response.data}');
      return response.data;
    } catch (e) {
      return "Failure to save city: $e";
    }
  }
}
