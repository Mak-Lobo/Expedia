class Airport {
  final int? id; // Nullable for SaveAirport and required for DeleteAirport
  final String name;
  final String code;
  final int city; // Assuming city refers to a City ID

  Airport({
    this.id,
    required this.name,
    required this.code,
    required this.city,
  });

  factory Airport.fromJson(Map<String, dynamic> json) {
    return Airport(
      id: json['id'] as int?,
      name: json['name'] as String,
      code: json['code'] as String,
      city: json['city'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      // Only include ID if it's present (e.g., for updates or when it's part of the model)
      data['id'] = id;
    }
    data['name'] = name;
    data['code'] = code;
    data['city'] = city;
    return data;
  }
}

class AirportCityCountry {
  final String name;
  final String code;
  final String city;
  final String country;

  AirportCityCountry({
    required this.name,
    required this.code,
    required this.city,
    required this.country,
  });

  factory AirportCityCountry.fromJson(Map<String, dynamic> json) {
    return AirportCityCountry(
      name: json['name'] as String,
      code: json['code'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
    );
  }
}

class DeleteAirport {
  final int id;

  DeleteAirport({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
