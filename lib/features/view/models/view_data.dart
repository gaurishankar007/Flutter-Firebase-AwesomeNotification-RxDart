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
  const ViewData.createStudent()
      : currentView = CurrentView.createStudent,
        data = null;
}

@immutable
class StudentViewData extends ViewData<Student> {
  const StudentViewData.updateStudent(Student student)
      : super(currentView: CurrentView.updateStudent, data: student);

  const StudentViewData.studentInformation(Student student)
      : super(currentView: CurrentView.studentInformation, data: student);
}
