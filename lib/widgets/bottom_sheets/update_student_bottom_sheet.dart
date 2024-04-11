import 'package:flutter/material.dart';

import '../../core/typedef/function_type_definitions.dart';
import '../../features/student/models/student.dart';
import '../../features/student/views/update_student_view.dart';

showUpdateStudentBottomSheet({
  required BuildContext context,
  required Student student,
  required UpdateStudentCallback updateStudent,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
    builder: (bottomSheetContext) {
      return UpdateStudentView(
        student: student,
        updateStudent: updateStudent,
        goBack: () => Navigator.pop(bottomSheetContext),
      );
    },
  );
}
