import 'package:flutter/material.dart';

enum UserState { newUser, existing }

class ManagerAddClientScreenController {
  static Color getUseStateTextColor(UserState state) {
    switch (state) {
      case UserState.newUser:
        return Colors.green;
      case UserState.existing:
        return const Color(0xFFCF6E46);
    }
  }

  static Color getUseStateBgColor(UserState state) {
    switch (state) {
      case UserState.newUser:
        return const Color(0xFFF0FDF4);
      case UserState.existing:
        return const Color(0xFFFDF6EF);
    }
  }

  static String getUserStateLabel(UserState state) {
    switch (state) {
      case UserState.newUser:
        return "New";
      case UserState.existing:
        return "Existing";
    }
  }
}
