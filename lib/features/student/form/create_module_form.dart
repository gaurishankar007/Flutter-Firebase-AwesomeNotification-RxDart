import '../models/module.dart';

class CreateModuleForm {
  final Module module;
  final String studentId;

  const CreateModuleForm({
    required this.module,
    required this.studentId,
  });
}
