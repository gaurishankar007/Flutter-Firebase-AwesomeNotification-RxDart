import 'dart:async';

import '../../auth/views/login_view.dart';
import '../../auth/views/register_view.dart';
import '../../contact/views/contacts_list_view.dart';
import '../../contact/views/new_contact_view.dart';
import '../../currentView/viewModel/current_view.dart';
import '../../../widgets/dialogs/auth_error_dialog.dart';
import '../../../widgets/loading/loading_screen.dart';
import 'package:flutter/material.dart';

import '../../auth/viewModels/auth_error.dart';
import '../viewModel/app_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final AppBloc appBloc;
  StreamSubscription<AuthError?>? _authErrorSubscription;
  StreamSubscription<bool?>? _isLoadingSubscription;

  @override
  void initState() {
    super.initState();
    appBloc = AppBloc();
  }

  @override
  void dispose() {
    appBloc.dispose();
    _authErrorSubscription?.cancel();
    _isLoadingSubscription?.cancel();
    super.dispose();
  }

  void handleAuthErrors(BuildContext context) async {
    await _authErrorSubscription?.cancel();
    _authErrorSubscription = appBloc.authError.listen((authError) {
      if (authError == null) return;
      showAuthError(context: context, authError: authError);
    });
  }

  void setupLoadingScreen(BuildContext context) async {
    await _isLoadingSubscription?.cancel();
    _isLoadingSubscription = appBloc.isLoading.listen((isLoading) {
      if (isLoading) {
        LoadingScreen.instance().show(context: context, text: "Loading...");
      } else {
        LoadingScreen.instance().hide();
      }
    });
  }

  Widget getHomePage() {
    return StreamBuilder<CurrentView>(
      stream: appBloc.currentView,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          // Returning circular progress indicator for both case
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());

          case ConnectionState.active:
          case ConnectionState.done:
            final currentView = snapshot.requireData;
            switch (currentView) {
              case CurrentView.login:
                return LoginView(
                  login: appBloc.login,
                  goToRegisterView: appBloc.goToRegisterView,
                );
              case CurrentView.register:
                return RegisterView(
                  register: appBloc.register,
                  goToLoginView: appBloc.goToLoginView,
                );

              case CurrentView.contactList:
                return ContactsListView(
                  logout: appBloc.logout,
                  deleteAccount: appBloc.deleteAccount,
                  deleteContact: appBloc.deleteContact,
                  createNewContact: appBloc.goToCreateContactView,
                  contacts: appBloc.contacts,
                );
              case CurrentView.createContact:
                return NewContactView(
                  createContact: appBloc.createContact,
                  goBack: appBloc.goToContactListView,
                );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    handleAuthErrors(context);
    setupLoadingScreen(context);
    return getHomePage();
  }
}
