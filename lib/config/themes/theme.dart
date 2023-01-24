import 'package:flutter/material.dart';

import '../../core/constant.dart';

ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.deepPurpleAccent,
  primaryContainer: Colors.deepPurple,
  secondary: Color(0xFF140F41),
  secondaryContainer: Color(0xFF140F41),
  background: Color(0xFFFFFFFF),
  surface: Color(0xFFFFFFFF),
  error: Color(0xFFB00020),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFF000000),
  onBackground: Color(0xFF000000),
  onSurface: Color(0xFF000000),
  onError: Color(0xFFFFFFFF),
);

final outlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(
    width: 1,
    color: colorScheme.secondary,
  ),
  borderRadius: BorderRadius.circular(
    cBorderRadius,
  ),
);

ThemeData lightTheme = ThemeData(
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  unselectedWidgetColor: colorScheme.secondary,
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      color: colorScheme.onPrimary,
      fontSize: h6["size"],
      fontWeight: h6["weight"],
    ),
  ),
  listTileTheme: ListTileThemeData(
    iconColor: colorScheme.primary,
    horizontalTitleGap: 0,
    contentPadding: EdgeInsets.zero,
    dense: true,
  ),
  inputDecorationTheme: InputDecorationTheme(
    isDense: true,
    labelStyle: TextStyle(
      color: colorScheme.onBackground,
      fontSize: subtitle2["size"],
      fontWeight: subtitle2["weight"],
    ),
    hintStyle: TextStyle(
      color: colorScheme.onBackground.withOpacity(.5),
      fontSize: subtitle2["size"],
      fontWeight: subtitle2["weight"],
    ),
    enabledBorder: outlineInputBorder,
    errorBorder: outlineInputBorder.copyWith(
      borderSide: BorderSide(
        color: colorScheme.error,
      ),
    ),
    focusedErrorBorder: outlineInputBorder.copyWith(
      borderSide: BorderSide(
        width: 2,
        color: colorScheme.primary,
      ),
    ),
    focusedBorder: outlineInputBorder.copyWith(
      borderSide: BorderSide(
        width: 2,
        color: colorScheme.primary,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      backgroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          bBorderRadius,
        ),
      ),
      textStyle: TextStyle(
        fontSize: subtitle1["size"],
        fontWeight: FontWeight.w600,
        color: colorScheme.onPrimary,
      ),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          bBorderRadius,
        ),
      ),
      side: BorderSide(
        width: 1,
        color: colorScheme.primary,
      ),
      textStyle: TextStyle(
        fontSize: subtitle1["size"],
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
);
