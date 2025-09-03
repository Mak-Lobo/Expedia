class BookingClass {
  final int? id; // Nullable for SaveBookingClass harmonization
  final String className;

  BookingClass({this.id, required this.className});

  factory BookingClass.fromJson(Map<String, dynamic> json) {
    return BookingClass(
      id: json['id'] as int?,
      className: json['class_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['class_name'] = className;
    return data;
  }
}
