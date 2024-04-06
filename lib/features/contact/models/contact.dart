import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

@immutable
class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String profilePicture;

  const Contact({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.profilePicture,
  });

  Contact.withoutIdProfile({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  })  : id = const Uuid().v4(),
        profilePicture = "";

  Contact.fromJson(
    Map<String, dynamic> json, {
    required this.id,
  })  : firstName = json[_Keys.firstNameKey] as String,
        lastName = json[_Keys.lastNameKey] as String,
        phoneNumber = json[_Keys.phoneNumberKey] as String,
        profilePicture = json[_Keys.profilePicture] as String;

  String get fullName => '$firstName $lastName';

  Map<String, dynamic> get json => {
        _Keys.firstNameKey: firstName,
        _Keys.lastNameKey: lastName,
        _Keys.phoneNumberKey: phoneNumber,
        _Keys.profilePicture: profilePicture,
      };
}

@immutable
class _Keys {
  const _Keys._();
  static const firstNameKey = 'first_name';
  static const lastNameKey = 'last_name';
  static const phoneNumberKey = 'phone_number';
  static const profilePicture = 'profile_picture';
}
