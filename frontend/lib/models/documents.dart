class Document {
  final int? id; // Nullable for SaveDoc, required for DeleteDoc
  final String name;

  Document({this.id, required this.name});

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(id: json['id'] as int?, name: json['name'] as String);
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

class DeleteDoc {
  final int id;

  DeleteDoc({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
