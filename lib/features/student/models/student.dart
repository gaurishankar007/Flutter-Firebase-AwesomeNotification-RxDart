import 'package:flutter/foundation.dart' show immutable;
import 'package:uuid/uuid.dart';

import 'address.dart';

@immutable
class Student {
  final String id;
  final String userId;
  final String name;
  final String phoneNumber;
  final String profilePicture;
  final Address address;

  const Student({
    required this.id,
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.profilePicture,
    required this.address,
  });

  Student.withoutIdProfile({
    required this.name,
    required this.phoneNumber,
    required this.address,
  })  : id = const Uuid().v4(),
        userId = "",
        profilePicture = "";

  Student copyWith({
    String? id,
    String? userId,
    String? name,
    String? phoneNumber,
    String? profilePicture,
    Address? address,
  }) =>
      Student(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        profilePicture: profilePicture ?? this.profilePicture,
        address: address ?? this.address,
      );

  Student.fromJson(
    Map<String, dynamic> json, {
    required this.id,
  })  : userId = json[_Keys.userIdKey] as String,
        name = json[_Keys.firstNameKey] as String,
        phoneNumber = json[_Keys.phoneNumberKey] as String,
        profilePicture = json[_Keys.profilePicture] as String,
        address = Address.fromJson(json[_Keys.address] as Map<String, dynamic>);

  Map<String, dynamic> json() => {
        _Keys.userIdKey: userId,
        _Keys.firstNameKey: name,
        _Keys.phoneNumberKey: phoneNumber,
        _Keys.profilePicture: profilePicture,
        _Keys.address: address.toJson(),
      };
}

@immutable
class _Keys {
  const _Keys._();
  static const userIdKey = 'user_id';
  static const firstNameKey = 'name';
  static const phoneNumberKey = 'phone_number';
  static const profilePicture = 'profile_picture';
  static const address = 'address';
}
