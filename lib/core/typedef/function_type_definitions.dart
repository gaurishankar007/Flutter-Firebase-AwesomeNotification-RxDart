import 'package:flutter/foundation.dart';

import '../../features/student/form/create_module_form.dart';
import '../../features/student/form/delete_module_form.dart';
import '../../features/student/form/update_student_form.dart';
import '../../features/student/models/module.dart';
import '../../features/student/models/student.dart';

typedef LogoutCallback = VoidCallback;

typedef DeleteAccountCallback = VoidCallback;

typedef GoBackCallback = VoidCallback;

typedef LoginFunction = void Function(
  String email,
  String password,
);

typedef RegisterFunction = void Function(
  String email,
  String password,
);

typedef CreateStudentCallback = void Function({
  required String name,
  required String phoneNumber,
  required String country,
  required String city,
});

typedef StudentCallback = void Function(
  Student student,
);

typedef UpdateStudentCallback = void Function(
  UpdateStudentForm updateStudentForm,
);

typedef ModuleStreamCallback = Stream<Iterable<Module>> Function(
  String studentId,
);

typedef CreateModuleCallBack = void Function(
  CreateModuleForm createModuleForm,
);

typedef DeleteModuleCallBack = void Function(
  DeleteModuleForm deleteModuleForm,
);
