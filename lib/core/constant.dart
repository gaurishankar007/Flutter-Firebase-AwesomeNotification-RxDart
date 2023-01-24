
import 'package:firebase_crud/config/themes/theme.dart';
import 'package:flutter/material.dart';

const double iconSize = 25;

const double cBorderRadius = 10;
const double bBorderRadius = 5;

double sWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double sHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

const Map<String, dynamic> h3 = {
  "size": 48.0,
  "weight": FontWeight.w400,
};

const Map<String, dynamic> h4 = {
  "size": 34.0,
  "weight": FontWeight.w400,
};

const Map<String, dynamic> h5 = {
  "size": 24.0,
  "weight": FontWeight.w400,
};

const Map<String, dynamic> h6 = {
  "size": 20.0,
  "weight": FontWeight.w500,
};

const Map<String, dynamic> subtitle1 = {
  "size": 16.0,
  "weight": FontWeight.w400, // Normal or Regular
};

const Map<String, dynamic> subtitle2 = {
  "size": 14.0,
  "weight": FontWeight.w500, // Medium
};

const Map<String, dynamic> body1 = {
  "size": 16.0,
  "weight": FontWeight.w400,
};

const Map<String, dynamic> button = {
  "size": 14.0,
  "weight": FontWeight.w500,
};

const Map<String, dynamic> body2 = {
  "size": 14.0,
  "weight": FontWeight.w400,
};

const Map<String, dynamic> caption = {
  "size": 12.0,
  "weight": FontWeight.w400,
};

TextStyle kXLTextStyle = TextStyle(
  color: colorScheme.onSurface,
  fontSize: h6["size"],
  fontWeight: subtitle2["weight"],
);

TextStyle kLTextStyle = TextStyle(
  color: colorScheme.onSurface,
  fontSize: h6["size"] - 2,
  fontWeight: subtitle2["weight"],
);

TextStyle kTextStyle = TextStyle(
  color: colorScheme.onSurface,
  fontSize: subtitle1["size"] + 2,
  fontWeight: subtitle2["weight"],
);

TextStyle kSTextStyle = TextStyle(
  color: colorScheme.onSurface,
  fontSize: subtitle1["size"],
  fontWeight: subtitle2["weight"],
);

TextStyle kSSTextStyle = TextStyle(
  color: colorScheme.onSurface,
  fontSize: subtitle2["size"],
  fontWeight: subtitle1["weight"],
);

TextStyle disabledTextStyle = TextStyle(
  color: colorScheme.onSurface.withOpacity(.6),
  fontSize: subtitle1["size"],
  fontWeight: subtitle2["weight"],
);
