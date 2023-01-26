import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  final String firstName;
  final String lastName;
  final String email;
  final int phone;
  final DateTime birthday;

  const Person({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.birthday,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        firstName: json["firstName"] as String,
        lastName: json["lastName"] as String,
        email: json["email"] as String,
        phone: json["phone"] as int,
        birthday: (json["birthday"] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "birthday": birthday,
      };
}
