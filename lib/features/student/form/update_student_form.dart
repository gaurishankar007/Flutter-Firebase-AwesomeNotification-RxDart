import 'package:flutter/material.dart';

import '../models/student.dart';

@immutable
class UpdateStudentForm {
  final String imagePath;
  final Student student;

  const UpdateStudentForm({
    required this.imagePath,
    required this.student,
  });
}
