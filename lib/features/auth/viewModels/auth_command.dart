import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthCommand {
  final String email;
  final String password;

  const AuthCommand({
    required this.email,
    required this.password,
  });
}

@immutable
class LoginCommand extends AuthCommand {
  const LoginCommand({
    required super.email,
    required super.password,
  });
}

@immutable
class RegisterCommand extends AuthCommand {
  const RegisterCommand({
    required super.email,
    required super.password,
  });
}
