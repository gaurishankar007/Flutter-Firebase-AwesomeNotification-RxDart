import '../models/student.dart';

class UpdateStudentForm {
  final String imagePath;
  final Student student;

  const UpdateStudentForm({
    required this.imagePath,
    required this.student,
  });
}
