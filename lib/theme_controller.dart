import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeController {
  static Color pageBackgroundColor = Colors.white;
  static Color pageBackgroundSecondaryColor = const Color(0xFFf5f9fa);
  static const Color enabledTextFieldBorderColor = Colors.black;
  static const Color disableTextFieldBorderColor = Colors.grey;
  static const double textFieldBorderWidth = 1.0;
  static const double textFieldBorderRadius = 10;
  static const Color buttonColor = Colors.black;
  static const Color iconPrimaryColor = Colors.white;
  static const Color iconSecondaryColor = Colors.black;
  static const Color textSecondaryColor = Colors.grey;
  static const Color textPrimaryColor = Colors.black;
  static const Color textTertiaryColor = Colors.white;
  static const Color containerPrimaryColor = Colors.black;
  static const Color containerSecondaryColor = Color(0xFFe7f5ec);
  static const Color containerPrimaryBorderColor = Color(0xFF9DE58D);
  static const Color avatarPrimaryColor = Color(0xFF9DE58D);

  static BorderSide getTextFieldBorderStyle({
    borderColor = enabledTextFieldBorderColor,
    double borderWidth = textFieldBorderWidth,
  }) =>
      BorderSide(
        color: borderColor,
        width: borderWidth,
      );
  static TextStyle titleTextStyle({size = 24, color = Colors.black}) =>
      GoogleFonts.lato(
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w600,
      );
  static TextStyle normalTextStyle(
          {color = Colors.black, fontWeight = FontWeight.w500, size = 16}) =>
      GoogleFonts.lato(
        fontSize: size,
        color: color,
        fontWeight: fontWeight,
      );
  static TextStyle smallTextStyle(
          {color = Colors.black, fontWeight = FontWeight.w500, size = 14}) =>
      GoogleFonts.lato(
        fontSize: size,
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
