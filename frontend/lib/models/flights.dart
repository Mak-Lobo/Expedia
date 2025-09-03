class Flight {
  final int? id; // Nullable for SaveFlight harmonization
  final String flightNumber;
  final int airlineId;
  final DateTime departureTime; // Use DateTime
  final int noOfSeats;
  final int departureAirportId;
  final int arrivalAirportId;
  final int duration; // Assuming duration is in minutes or some integer unit

  Flight({
    this.id,
    required this.flightNumber,
    required this.airlineId,
    required this.departureTime,
    required this.noOfSeats,
    required this.departureAirportId,
    required this.arrivalAirportId,
    required this.duration,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'] as int?,
      flightNumber: json['flight_number'] as String,
      airlineId: json['airline_id'] as int,
      departureTime: DateTime.parse(json['departure_time'] as String),
      noOfSeats: json['no_of_seats'] as int,
      departureAirportId: json['departure_airport_id'] as int,
      arrivalAirportId: json['arrival_airport_id'] as int,
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['flight_number'] = flightNumber;
    data['airline_id'] = airlineId;
    data['departure_time'] = departureTime.toIso8601String();
    data['no_of_seats'] = noOfSeats;
    data['departure_airport_id'] = departureAirportId;
    data['arrival_airport_id'] = arrivalAirportId;
    data['duration'] = duration;
    return data;
  }
}
