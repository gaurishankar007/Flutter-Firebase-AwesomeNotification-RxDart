import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

@immutable
class Module {
  final String id;
  final String name;
  final double scorePercentage;

  Module({
    required this.name,
    required this.scorePercentage,
  }) : id = const Uuid().v4();

  Module.fromJson(
    Map<String, dynamic> json, {
    required this.id,
  })  : name = json[_Keys.name] as String,
        scorePercentage = json[_Keys.scorePercentage] as double;

  Map<String, dynamic> toJson() => {
        _Keys.name: name,
        _Keys.scorePercentage: scorePercentage,
      };
}

@immutable
class _Keys {
  const _Keys._();
  static const name = 'name';
  static const scorePercentage = 'score_percentage';
}
