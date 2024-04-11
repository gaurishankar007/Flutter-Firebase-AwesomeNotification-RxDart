import 'package:flutter/material.dart';

@immutable
class Address {
  final String country;
  final String city;

  const Address({
    required this.country,
    required this.city,
  });

  Address.fromJson(Map<String, dynamic> json)
      : country = json[_Keys.country] as String,
        city = json[_Keys.city] as String;

  Map<String, dynamic> toJson() => {
        _Keys.country: country,
        _Keys.city: city,
      };
}

@immutable
class _Keys {
  const _Keys._();
  static const country = 'country';
  static const city = 'city';
}
