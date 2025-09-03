class Payment {
  final int? id; // Nullable for SavePayment harmonization
  final String name;

  Payment({this.id, required this.name});

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(id: json['id'] as int?, name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['name'] = name;
    return data;
  }
}
