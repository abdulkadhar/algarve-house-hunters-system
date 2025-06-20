import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController {
  static Color pageBackgroundColor = Colors.white;
  static const Color enabledTextFieldBorderColor = Colors.black;
  static const Color disableTextFieldBorderColor = Colors.grey;
  static const double textFieldBorderWidth = 1.0;
  static const double textFieldBorderRadius = 10;
  static const Color buttonColor = Colors.black;
  static const Color iconPrimaryColor = Colors.white;

  static BorderSide getTextFieldBorderStyle({
    borderColor = enabledTextFieldBorderColor,
    double borderWidth = textFieldBorderWidth,
  }) =>
      BorderSide(
        color: borderColor,
        width: borderWidth,
      );
  static TextStyle titleTextStyle({color = Colors.black}) => GoogleFonts.lato(
        fontSize: 24,
        color: color,
        fontWeight: FontWeight.w600,
      );
  static TextStyle normalTextStyle({
    color = Colors.black,
    fontWeight = FontWeight.w500,
  }) =>
      GoogleFonts.lato(
        fontSize: 16,
        color: color,
        fontWeight: fontWeight,
      );
  static TextStyle smallTextStyle(
          {color = Colors.black, fontWeight = FontWeight.w500}) =>
      GoogleFonts.lato(
        fontSize: 14,
        color: color,
        fontWeight: fontWeight,
      );
  static getFormLabelTextStyle({textColor = Colors.black}) => GoogleFonts.lato(
        fontSize: 14,
        color: textColor,
        fontWeight: FontWeight.w400,
      );
  static TextStyle buttonLabelTextStyle({
    color = Colors.black,
  }) =>
      GoogleFonts.lato(
        fontSize: 16,
        color: color,
        fontWeight: FontWeight.w700,
      );
}
