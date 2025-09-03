class Country {
  final int? id; // Nullable for SaveCountry, required for Update and Delete
  final String name;

  Country({this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(id: json['id'] as int?, name: json['name'] as String);
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

class DeleteCountry {
  final int id;

  DeleteCountry({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
