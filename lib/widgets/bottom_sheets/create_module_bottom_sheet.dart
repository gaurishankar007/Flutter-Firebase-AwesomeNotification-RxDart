import 'package:flutter/material.dart';

import '../../core/typedef/function_type_definitions.dart';
import '../../features/student/views/widgets/create_new_module.dart';

showCreateModuleBottomSheet({
  required BuildContext context,
  required String studentId,
  required CreateModuleCallBack createModule,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
    builder: (bottomSheetContext) {
      return CreateNewModule(
        studentId: studentId,
        createModule: createModule,
        goBack: Navigator.of(bottomSheetContext).pop,
      );
    },
  );
}
