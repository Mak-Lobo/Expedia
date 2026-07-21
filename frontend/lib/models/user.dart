class AppUser {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final bool admin;
  final int? passengerId;

  const AppUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.admin,
    this.passengerId,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userId: json['user_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      admin: json['admin'] as bool,
      passengerId: json['passenger_id'] as int?,
    );
  }
}

class LoginRequest {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class RegisterRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String sex;
  final DateTime dateOfBirth;
  final int documentType;
  final DateTime documentExpiry;
  final int documentNo;
  final int nationality;

  const RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.sex,
    required this.dateOfBirth,
    required this.documentType,
    required this.documentExpiry,
    required this.documentNo,
    required this.nationality,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'sex': sex,
      'date_of_birth': dateOfBirth.toIso8601String(),
      'document_type': documentType,
      'document_expiry': documentExpiry.toIso8601String(),
      'document_no': documentNo,
      'nationality': nationality,
    };
  }
}
