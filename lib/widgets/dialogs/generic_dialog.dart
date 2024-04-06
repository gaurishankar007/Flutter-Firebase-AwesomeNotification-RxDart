import 'package:flutter/material.dart';

typedef DialogOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionBuilder<T> optionsBuilder,
}) {
  final options = optionsBuilder();

  final alertDialog = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: options.keys.map((optionTitle) {
      final value = options[optionTitle];

      return TextButton(
        onPressed: () {
          if (value == null) return Navigator.pop(context);
          Navigator.pop(context, value);
        },
        child: Text(optionTitle),
      );
    }).toList(),
  );

  return showDialog<T>(
    context: context,
    builder: (context) => alertDialog,
  );
}
