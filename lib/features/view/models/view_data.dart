import 'package:flutter/foundation.dart';

import '../../student/models/student.dart';
import '../viewModel/current_view.dart';

@immutable
class ViewData<T> {
  final CurrentView currentView;
  final T? data;

  const ViewData({
    required this.currentView,
    this.data,
  });

  const ViewData.login() : this(currentView: CurrentView.login);
  const ViewData.register() : this(currentView: CurrentView.register);
  const ViewData.studentList() : this(currentView: CurrentView.studentList);
  const ViewData.createStudent() : this(currentView: CurrentView.createStudent);

  static ViewData<Student> updateStudent(Student student) {
    return ViewData<Student>(currentView: CurrentView.updateStudent, data: student);
  }

  static ViewData<Student> studentInformation(Student student) {
    return ViewData<Student>(currentView: CurrentView.studentInformation, data: student);
  }

  @override
  bool operator ==(covariant ViewData other) => currentView == other.currentView;

  @override
  int get hashCode => currentView.hashCode;
}
