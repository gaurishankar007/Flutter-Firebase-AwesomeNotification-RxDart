import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../auth/viewModels/auth_bloc.dart';
import '../../auth/viewModels/auth_command.dart';
import '../../auth/viewModels/auth_error.dart';
import '../../auth/viewModels/auth_status.dart';
import '../../student/form/create_module_form.dart';
import '../../student/form/delete_module_form.dart';
import '../../student/form/update_student_form.dart';
import '../../student/models/address.dart';
import '../../student/models/module.dart';
import '../../student/models/student.dart';
import '../../student/viewModels/student_bloc.dart';
import '../../view/models/view_data.dart';
import '../../view/viewModel/view_bloc.dart';

@immutable
class AppBloc {
  // Hiding these bloc from being interacted form the UI
  final AuthBloc _authBloc;
  final ViewBloc _viewBloc;
  final StudentBloc _studentBloc;

  final Stream<ViewData> view;
  final Stream<bool> isLoading;
  final Stream<AuthError?> authError;
  final StreamSubscription<String?> _userIdChanges;

  const AppBloc._({
    required AuthBloc authBloc,
    required ViewBloc viewsBloc,
    required StudentBloc studentBloc,
    required this.view,
    required this.isLoading,
    required this.authError,
    required StreamSubscription<String?> userIdChanges,
  })  : _authBloc = authBloc,
        _viewBloc = viewsBloc,
        _studentBloc = studentBloc,
        _userIdChanges = userIdChanges;

  void dispose() {
    _authBloc.dispose();
    _viewBloc.dispose();
    _studentBloc.dispose();
    _userIdChanges.cancel();
  }

  factory AppBloc() {
    final authBloc = AuthBloc();
    final viewsBloc = ViewBloc();
    final studentBloc = StudentBloc();

    // Pass userId from auth bloc into the students bloc
    final userIdChanges = authBloc.userId.listen((String? userId) {
      studentBloc.userId.add(userId);
    });

    // Calculate the view based on the auth status
    final Stream<ViewData> viewBasedOnAuthStatus = authBloc.authStatus.map<ViewData>((authStatus) {
      if (authStatus is AuthStatusLoggedIn) {
        return const ViewData.studentList();
      } else {
        return const ViewData.login();
      }
    });

    // Current View
    final Stream<ViewData> view = Rx.merge([
      viewBasedOnAuthStatus,
      viewsBloc.viewData,
    ]);

    // IsLoading
    final Stream<bool> isLoading = Rx.merge([
      authBloc.isLoading,
    ]);

    // asBroadcastStream allows multiple subscription
    // In the UI you might to show and destroys widgets multiple times according to stream events
    return AppBloc._(
      authBloc: authBloc,
      viewsBloc: viewsBloc,
      studentBloc: studentBloc,
      view: view,
      isLoading: isLoading.asBroadcastStream(),
      authError: authBloc.authError.asBroadcastStream(),
      userIdChanges: userIdChanges,
    );
  }

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

  Stream<Iterable<Student>> get students => _studentBloc.students;

  Stream<Iterable<Module>> modules(String studentId) => _studentBloc.modules(studentId);

  void createStudent({
    required String name,
    required String phoneNumber,
    required String country,
    required String city,
  }) {
    _studentBloc.createStudent.add(
      Student.withoutIdProfile(
        name: name,
        phoneNumber: phoneNumber,
        address: Address(
          country: country,
          city: city,
        ),
      ),
    );
  }

  void updateStudent(UpdateStudentForm updateStudentForm) {
    _studentBloc.updateStudent.add(updateStudentForm);
  }

  void deleteStudent(Student student) {
    _studentBloc.deleteStudent.add(student);
  }

  void deleteAccount() {
    _studentBloc.deleteAllStudents.add(null);
    _authBloc.deleteAccount.add(null);
  }

  void createModule(CreateModuleForm createModuleForm) {
    _studentBloc.createModule.add(createModuleForm);
  }

  void deleteModule(DeleteModuleForm deleteModuleForm) {
    _studentBloc.deleteModule.add(deleteModuleForm);
  }

  void logout() {
    _authBloc.logout.add(null);
  }

  void goToLoginView() => _viewBloc.goToView.add(const ViewData.login());

  void goToRegisterView() => _viewBloc.goToView.add(const ViewData.register());

  void goToStudentListView() => _viewBloc.goToView.add(const ViewData.studentList());

  void goToCreateStudentView() => _viewBloc.goToView.add(const ViewData.createStudent());

  void goToUpdateStudentView(Student student) =>
      _viewBloc.goToView.add(StudentViewData.updateStudent(student));

  void goToStudentInformationView(Student student) =>
      _viewBloc.goToView.add(StudentViewData.studentInformation(student));
}
