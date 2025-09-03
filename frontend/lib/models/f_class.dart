class FlightClass {
  // Similar to FlightBooking, flight_class_id is likely DB generated.
  final int? flightClassId;
  final int flightId;
  final int bookingClass; // Assuming this is an ID (e.g., BookingClass ID)
  final double price;
  final String currency;

  FlightClass({
    this.flightClassId,
    required this.flightId,
    required this.bookingClass,
    required this.price,
    required this.currency,
  });

  factory FlightClass.fromJson(Map<String, dynamic> json) {
    return FlightClass(
      flightClassId: json['flight_class_id'] as int?,
      flightId: json['flight_id'] as int,
      bookingClass: json['booking_class'] as int,
      price: (json['price'] as num).toDouble(),
      // Ensure it's a double
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (flightClassId != null) {
      data['flight_class_id'] = flightClassId;
    }
    data['flight_id'] = flightId;
    data['booking_class'] = bookingClass;
    data['price'] = price;
    data['currency'] = currency;
    return data;
  }
}
