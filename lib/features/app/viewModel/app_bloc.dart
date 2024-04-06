import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../auth/viewModels/auth_bloc.dart';
import '../../auth/viewModels/auth_command.dart';
import '../../auth/viewModels/auth_error.dart';
import '../../auth/viewModels/auth_status.dart';
import '../../contact/models/contact.dart';
import '../../contact/viewModels/contact_bloc.dart';
import '../../currentView/viewModel/current_view.dart';
import '../../currentView/viewModel/view_bloc.dart';

@immutable
class AppBloc {
  // Hiding these bloc from being interacted form the UI
  final AuthBloc _authBloc;
  final ViewBloc _viewBloc;
  final ContactBloc _contactBloc;

  final Stream<CurrentView> currentView;
  final Stream<bool> isLoading;
  final Stream<AuthError?> authError;
  final StreamSubscription<String?> _userIdChanges;

  const AppBloc._({
    required AuthBloc authBloc,
    required ViewBloc viewsBloc,
    required ContactBloc contactBloc,
    required this.currentView,
    required this.isLoading,
    required this.authError,
    required StreamSubscription<String?> userIdChanges,
  })  : _authBloc = authBloc,
        _viewBloc = viewsBloc,
        _contactBloc = contactBloc,
        _userIdChanges = userIdChanges;

  void dispose() {
    _authBloc.dispose();
    _viewBloc.dispose();
    _contactBloc.dispose();
    _userIdChanges.cancel();
  }

  factory AppBloc() {
    final authBloc = AuthBloc();
    final viewsBloc = ViewBloc();
    final contactBloc = ContactBloc();

    // Pass userId from auth bloc into the contacts bloc
    final userIdChanges = authBloc.userId.listen((String? userId) {
      contactBloc.userId.add(userId);
    });

    // Calculate the current view
    final Stream<CurrentView> currentViewBasedOnAuthStatus =
        authBloc.authStatus.map<CurrentView>((authStatus) {
      if (authStatus is AuthStatusLoggedIn) {
        return CurrentView.contactList;
      } else {
        return CurrentView.login;
      }
    });

    // Current View
    final Stream<CurrentView> currentView = Rx.merge([
      currentViewBasedOnAuthStatus,
      viewsBloc.currentView,
    ]);

    // IsLoading
    final Stream<bool> isLoading = Rx.merge([
      authBloc.isLoading,
    ]);

    return AppBloc._(
      authBloc: authBloc,
      viewsBloc: viewsBloc,
      contactBloc: contactBloc,
      currentView: currentView,
      // asBroadcastStream allows listen and cancel multiple times
      // In the UI you might to show and destroys widgets multiple times according to stream events
      isLoading: isLoading.asBroadcastStream(),
      authError: authBloc.authError.asBroadcastStream(),
      userIdChanges: userIdChanges,
    );
  }

  void deleteContact(Contact contact) {
    _contactBloc.deleteContact.add(contact);
  }

  void createContact(
    String firstName,
    String lastName,
    String phoneNumber,
  ) {
    _contactBloc.createContact.add(
      Contact.withoutIdProfile(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      ),
    );
  }

  void deleteAccount() {
    _contactBloc.deleteAllContacts.add(null);
    _authBloc.deleteAccount.add(null);
  }

  void logout() {
    _authBloc.logout.add(null);
  }

  Stream<Iterable<Contact>> get contacts => _contactBloc.contacts;

  void register(
    String email,
    String password,
  ) {
    _authBloc.register.add(
      RegisterCommand(
        email: email,
        password: password,
      ),
    );
  }

  void login(
    String email,
    String password,
  ) {
    _authBloc.login.add(
      LoginCommand(
        email: email,
        password: password,
      ),
    );
  }

  void goToContactListView() => _viewBloc.goToView.add(CurrentView.contactList);

  void goToCreateContactView() => _viewBloc.goToView.add(CurrentView.createContact);

  void goToRegisterView() => _viewBloc.goToView.add(CurrentView.register);

  void goToLoginView() => _viewBloc.goToView.add(CurrentView.login);
}
