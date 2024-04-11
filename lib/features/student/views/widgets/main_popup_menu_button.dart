import 'package:flutter/material.dart';

import '../../../../core/typedef/function_type_definitions.dart';
import '../../../../widgets/dialogs/delete_account_dialog.dart';
import '../../../../widgets/dialogs/logout_dialog.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  final LogoutCallback logout;
  final DeleteAccountCallback deleteAccount;

  const MainPopupMenuButton({
    super.key,
    required this.logout,
    required this.deleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogout = await showLogoutDialog(context);
            if (shouldLogout) logout();
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if (shouldDeleteAccount) deleteAccount();
            break;
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log out'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete account'),
          ),
        ];
      },
    );
  }
}
