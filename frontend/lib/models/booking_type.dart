class BookingType {
  final int? id;
  final String name;

  BookingType({this.id, required this.name});

  factory BookingType.fromJson(Map<String, dynamic> json) {
    return BookingType(
      id: json['id'] as int?,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['name'] = name;
    return data;
  }
}
