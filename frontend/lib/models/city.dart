class City {
  final int? id;
  final String name;
  final int countryId;

  City({this.id, required this.name, required this.countryId});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int?,
      name: json['name'] as String,
      countryId: json['country_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      // For SaveCity, id will be null and not included. For UpdateCity, it will be included.
      data['id'] = id;
    }
    data['name'] = name;
    data['country_id'] = countryId;
    return data;
  }
}

class DeleteCity {
  final int id;

  DeleteCity({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

class CityCountry {
  final String city;
  final String country;

  CityCountry({required this.city, required this.country});

  factory CityCountry.fromJson(Map<String, dynamic> json) {
    return CityCountry(
      city: json['city'] as String,
      country: json['country'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'city': city, 'country': country};
  }
}
