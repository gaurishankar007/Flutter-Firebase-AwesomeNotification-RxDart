import 'package:flutter/material.dart' show BuildContext;

import 'generic_dialog.dart';

Future<bool> showDeleteStudentDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete student',
    content: 'Are you sure you want to delete this student? You cannot undo this operation!',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete student': true,
    },
  ).then((value) => value ?? false);
}
