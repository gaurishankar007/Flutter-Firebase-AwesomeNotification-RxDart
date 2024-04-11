import 'dart:async';

import 'package:flutter/material.dart';

import '../../../widgets/dialogs/auth_error_dialog.dart';
import '../../../widgets/loading/loading_screen.dart';
import '../../auth/viewModels/auth_error.dart';
import '../../auth/views/login_view.dart';
import '../../auth/views/register_view.dart';
import '../../student/models/student.dart';
import '../../student/views/new_student_view.dart';
import '../../student/views/student_information_view.dart';
import '../../student/views/students_list_view.dart';
import '../../student/views/update_student_view.dart';
import '../../view/models/view_data.dart';
import '../../view/viewModel/current_view.dart';
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

  @override
  Widget build(BuildContext context) {
    handleAuthErrors(context);
    setupLoadingScreen(context);
    return getHomePage();
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
    return StreamBuilder<ViewData>(
      stream: appBloc.view,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          // Returning circular progress indicator for both case
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());

          case ConnectionState.active:
          case ConnectionState.done:
            final view = snapshot.requireData;
            final currentView = view.currentView;
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
              case CurrentView.studentList:
                return StudentsListView(
                  logout: appBloc.logout,
                  deleteAccount: appBloc.deleteAccount,
                  deleteStudent: appBloc.deleteStudent,
                  updateStudent: appBloc.updateStudent,
                  goCreateNewStudent: appBloc.goToCreateStudentView,
                  goStudentInformation: appBloc.goToStudentInformationView,
                  goUpdateStudent: appBloc.goToUpdateStudentView,
                  students: appBloc.students,
                );
              case CurrentView.createStudent:
                return NewStudentView(
                  createStudent: appBloc.createStudent,
                  goBack: appBloc.goToStudentListView,
                );
              case CurrentView.updateStudent:
                return UpdateStudentView(
                  student: view.data as Student,
                  updateStudent: appBloc.updateStudent,
                  goBack: appBloc.goToStudentListView,
                );
              case CurrentView.studentInformation:
                return StudentInformation(
                  student: view.data as Student,
                  moduleStream: appBloc.modules,
                  createModule: appBloc.createModule,
                  deleteModule: appBloc.deleteModule,
                  goBack: appBloc.goToStudentListView,
                );
            }
        }
      },
    );
  }
}
