import 'package:flutter/material.dart';

import 'generic_dialog.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) async {
  final value = await showGenericDialog<bool>(
    context: context,
    title: 'Delete account',
    content: 'Are you sure you want to delete your account? You cannot undo this operation!',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete Account': true,
    },
  );

  return value ?? false;
}
