import 'package:flutter/material.dart';

import '../models/airline.dart';
import '../models/airport.dart';
import '../models/booking_class.dart';
import '../models/booking_type.dart';
import '../models/city.dart';
import '../models/country.dart';
import '../models/documents.dart';
import '../models/payment.dart';
import '../models/passengers.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthController extends ChangeNotifier {
  AuthController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;

  AppUser? currentUser;
  bool isBusy = false;
  String? errorMessage;

  bool get isAuthenticated => currentUser != null;
  bool get isAdmin => currentUser?.admin ?? false;
  int? get currentUserId => currentUser?.userId;

  Future<bool> login(LoginRequest request) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.post('/users/login', request.toJson());
      currentUser = AppUser.fromJson(data as Map<String, dynamic>);
      return true;
    } catch (error) {
      errorMessage = error.toString();
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<bool> register(RegisterRequest request) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _api.post('/users/register', request.toJson());
      return true;
    } catch (error) {
      errorMessage = error.toString();
      return false;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  void signOut() {
    currentUser = null;
    errorMessage = null;
    notifyListeners();
  }

  void logout() => signOut();
}

class PassengerController extends ChangeNotifier {
  PassengerController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;

  bool isBusy = false;
  String? errorMessage;
  List<Passenger> passengers = [];

  Future<List<Passenger>> loadPassengers({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/passengers', userId: userId);
      passengers = data.map((item) => Passenger.fromJson(item as Map<String, dynamic>)).toList();
      return passengers;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<String> savePassenger(Passenger passenger, {int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.post('/passengers/save', passenger.toJson(), userId: userId);
      await loadPassengers(userId: userId);
      return response.toString();
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<String> deletePassenger(int id, {int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.delete('/passengers/delete/$id', userId: userId);
      await loadPassengers(userId: userId);
      return response.toString();
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}

class CityController extends ChangeNotifier {
  CityController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;

  bool isBusy = false;
  String? errorMessage;
  List<City> cities = [];
  List<CityCountry> cityCountries = [];

  Future<List<City>> loadCities({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/cities', userId: userId);
      cities = data.map((item) => City.fromJson(item as Map<String, dynamic>)).toList();
      return cities;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<List<CityCountry>> loadCitiesWithCountry({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/cities/countries', userId: userId);
      cityCountries = data.map((item) => CityCountry.fromJson(item as Map<String, dynamic>)).toList();
      return cityCountries;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<String> saveCity(City city, {int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _api.post('/cities/save', city.toJson(), userId: userId);
      await loadCities(userId: userId);
      return response.toString();
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}

class CountryController extends ChangeNotifier {
  CountryController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;
  bool isBusy = false;
  String? errorMessage;
  List<Country> countries = [];

  Future<List<Country>> loadCountries({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/countries', userId: userId);
      countries = data.map((item) => Country.fromJson(item as Map<String, dynamic>)).toList();
      return countries;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<String> saveCountry(Country country, {int? userId}) async {
    final response = await _api.post('/countries', country.toJson(), userId: userId);
    await loadCountries(userId: userId);
    return response.toString();
  }
}

class AirlineController extends ChangeNotifier {
  AirlineController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;
  bool isBusy = false;
  String? errorMessage;
  List<Airline> airlines = [];

  Future<List<Airline>> loadAirlines({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/airlines', userId: userId);
      airlines = data.map((item) => Airline.fromJson(item as Map<String, dynamic>)).toList();
      return airlines;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<String> saveAirline(Airline airline, {int? userId}) async {
    final response = await _api.post('/airlines', airline.toJson(), userId: userId);
    await loadAirlines(userId: userId);
    return response.toString();
  }
}

class AirportController extends ChangeNotifier {
  AirportController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;
  bool isBusy = false;
  String? errorMessage;
  List<Airport> airports = [];
  List<AirportCityCountry> airportCityCountries = [];

  Future<List<Airport>> loadAirports({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/airports', userId: userId);
      airports = data.map((item) => Airport.fromJson(item as Map<String, dynamic>)).toList();
      return airports;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<List<AirportCityCountry>> loadAirportsWithCountry({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/airports/countries', userId: userId);
      airportCityCountries = data
          .map((item) => AirportCityCountry.fromJson(item as Map<String, dynamic>))
          .toList();
      return airportCityCountries;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<String> saveAirport(Airport airport, {int? userId}) async {
    final response = await _api.post('/airports', airport.toJson(), userId: userId);
    await loadAirports(userId: userId);
    return response.toString();
  }
}

class DocumentController extends ChangeNotifier {
  DocumentController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;
  bool isBusy = false;
  String? errorMessage;
  List<Document> documents = [];

  Future<List<Document>> loadDocuments({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/documents', userId: userId);
      documents = data.map((item) => Document.fromJson(item as Map<String, dynamic>)).toList();
      return documents;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<String> saveDocument(Document document, {int? userId}) async {
    final response = await _api.post('/documents', document.toJson(), userId: userId);
    await loadDocuments(userId: userId);
    return response.toString();
  }
}

class PaymentController extends ChangeNotifier {
  PaymentController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;
  bool isBusy = false;
  String? errorMessage;
  List<Payment> payments = [];

  Future<List<Payment>> loadPayments({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/payments', userId: userId);
      payments = data.map((item) => Payment.fromJson(item as Map<String, dynamic>)).toList();
      return payments;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }
}

class BookingClassController extends ChangeNotifier {
  BookingClassController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;
  bool isBusy = false;
  String? errorMessage;
  List<BookingClass> bookingClasses = [];

  Future<List<BookingClass>> loadBookingClasses({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/book_classes', userId: userId);
      bookingClasses = data
          .map((item) => BookingClass.fromJson(item as Map<String, dynamic>))
          .toList();
      return bookingClasses;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<String> saveBookingClass(BookingClass bookingClass, {int? userId}) async {
    final response = await _api.post('/book_classes', bookingClass.toJson(), userId: userId);
    await loadBookingClasses(userId: userId);
    return response.toString();
  }
}

class BookingTypeController extends ChangeNotifier {
  BookingTypeController({ApiService? apiService}) : _api = apiService ?? ApiService();

  final ApiService _api;
  bool isBusy = false;
  String? errorMessage;
  List<BookingType> bookingTypes = [];

  Future<List<BookingType>> loadBookingTypes({int? userId}) async {
    isBusy = true;
    errorMessage = null;
    notifyListeners();

    try {
      final data = await _api.getList('/book_types', userId: userId);
      bookingTypes = data.map((item) => BookingType.fromJson(item as Map<String, dynamic>)).toList();
      return bookingTypes;
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      isBusy = false;
      notifyListeners();
    }
  }

  Future<String> saveBookingType(BookingType bookingType, {int? userId}) async {
    final response = await _api.post('/book_types', bookingType.toJson(), userId: userId);
    await loadBookingTypes(userId: userId);
    return response.toString();
  }
}
