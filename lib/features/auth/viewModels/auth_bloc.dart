import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'auth_command.dart';
import 'auth_error.dart';
import 'auth_status.dart';

extension Loading<E> on Stream<E> {
  Stream<E> setLoadingTo(
    bool isLoading, {
    required Sink<bool> onSink,
  }) {
    return doOnEach((_) => onSink.add(isLoading));
  }
}

@immutable
class AuthBloc {
  // Read only properties
  final Stream<AuthStatus> authStatus;
  final Stream<AuthError?> authError;
  final Stream<bool> isLoading;
  final Stream<String?> userId;

  // Write only properties
  final Sink<LoginCommand> login;
  final Sink<RegisterCommand> register;
  final Sink<void> logout;
  final Sink<void> deleteAccount;

  const AuthBloc._({
    required this.authStatus,
    required this.authError,
    required this.isLoading,
    required this.userId,
    required this.login,
    required this.register,
    required this.logout,
    required this.deleteAccount,
  });

  void dispose() {
    login.close();
    register.close();
    logout.close();
    deleteAccount.close();
  }

  factory AuthBloc() {
    final isLoading = BehaviorSubject<bool>();

    // Calculate auth state
    final Stream<AuthStatus> authStatus = FirebaseAuth.instance.authStateChanges().map((user) {
      if (user == null) return const AuthStatusLoggedOut();

      return const AuthStatusLoggedIn();
    });

    // Get the user-id
    final Stream<String?> userId = FirebaseAuth.instance
        .authStateChanges()
        .map((user) => user?.uid)
        .startWith(FirebaseAuth.instance.currentUser?.uid);

    // Login and error handling
    final login = BehaviorSubject<LoginCommand>();
    final Stream<AuthError?> loginError =
        login.setLoadingTo(true, onSink: isLoading).asyncMap<AuthError?>((loginCommand) async {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginCommand.email,
          password: loginCommand.password,
        );
        return null;
      } on FirebaseAuthException catch (error) {
        debugPrint('Error: $error');
        return AuthError.from(error);
      } catch (_) {
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

    // Register and error handling
    final register = BehaviorSubject<RegisterCommand>();
    final Stream<AuthError?> registerError = register
        .setLoadingTo(true, onSink: isLoading)
        .asyncMap<AuthError?>((registerCommand) async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: registerCommand.email,
          password: registerCommand.password,
        );
        return null;
      } on FirebaseAuthException catch (error) {
        return AuthError.from(error);
      } catch (_) {
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

    // Login and error handling
    final logout = BehaviorSubject<void>();
    final Stream<AuthError?> logoutError =
        logout.setLoadingTo(true, onSink: isLoading).asyncMap<AuthError?>((_) async {
      try {
        await FirebaseAuth.instance.signOut();
        return null;
      } on FirebaseAuthException catch (error) {
        return AuthError.from(error);
      } catch (_) {
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

    // Delete account
    final deleteAccount = BehaviorSubject<void>();
    final Stream<AuthError?> deleteAccountError =
        deleteAccount.setLoadingTo(true, onSink: isLoading).asyncMap((_) async {
      try {
        await FirebaseAuth.instance.currentUser?.delete();
        return null;
      } on FirebaseAuthException catch (error) {
        return AuthError.from(error);
      } catch (_) {
        return const AuthErrorUnknown();
      }
    }).setLoadingTo(false, onSink: isLoading);

    // AuthError = (login error + register error + logout error)
    final Stream<AuthError?> authError = Rx.merge([
      loginError,
      registerError,
      logoutError,
      deleteAccountError,
    ]);

    return AuthBloc._(
      authStatus: authStatus,
      authError: authError,
      isLoading: isLoading,
      userId: userId,
      login: login,
      register: register,
      logout: logout,
      deleteAccount: deleteAccount,
    );
  }
}
