class Passenger {
  int? id;
  final String firstName;
  final String lastName;
  final String sex;
  final String birthDate;
  final String email;
  final int docType;
  final int docNumber;
  final String docExpiry;
  final int nationality;

  Passenger({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.sex,
    required this.birthDate,
    required this.email,
    required this.docType,
    required this.docNumber,
    required this.docExpiry,
    required this.nationality,
  });

  // factory method to convert object to JSON
  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      id: json['id'] as int?,
      firstName: json['firstName'],
      lastName: json['lastName'],
      sex: json['sex'],
      birthDate: json['birth_date'],
      email: json['email'],
      docType: json['doc_type'],
      docNumber: json['doc_number'],
      docExpiry: json['doc_expiry'],
      nationality: json['nationality'],
    );
  }

  // JSON to object map
  Map<String, dynamic> toObject() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'sex': sex,
      'birth_date': birthDate,
      'email': email,
      'doc_type': docType,
      'doc_number': docNumber,
      'doc_expiry': docExpiry,
      'nationality': nationality,
    };
  }
}
