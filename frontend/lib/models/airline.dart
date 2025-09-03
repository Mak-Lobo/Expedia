class Airline {
  final int? id; // Nullable for SaveAirline harmonization
  final String airlineName;
  final String logoPath;

  Airline({this.id, required this.airlineName, required this.logoPath});

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      id: json['id'] as int?,
      airlineName: json['airline_name'] as String,
      logoPath: json['logo_path'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['airline_name'] = airlineName;
    data['logo_path'] = logoPath;
    return data;
  }
}
