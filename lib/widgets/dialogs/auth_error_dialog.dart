import 'package:flutter/material.dart' show BuildContext;

import '../../features/auth/viewModels/auth_error.dart';
import 'generic_dialog.dart';

Future<void> showAuthError({
  required BuildContext context,
  required AuthError authError,
}) =>
    showGenericDialog(
      context: context,
      title: authError.dialogTitle,
      content: authError.dialogText,
      optionsBuilder: () => {
        'OK': true,
      },
    );
