import 'dart:ui';
import 'package:algarve_house_hunters_system/manager_log_in_screen/model/manager_response_model.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ManagerLogInScreenController extends ChangeNotifier {
  ManagerResponseModel managerData = ManagerResponseModel(
    access_token: '',
    role: '',
    token_type: '',
    name: '',
    email: '',
    profile_pic: '',
  );

  void setManagerData(ManagerResponseModel data) {
    managerData = data;
    notifyListeners();
  }

  static void showLoaderDialog(BuildContext context,
      {String message = "Loading..."}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // Prevent back button dismiss
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black26,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.black,
                      ),
                      SizedBox(height: 20),
                      Text(
                        message,
                        style: ThemeController.smallTextStyle(
                          size: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void hideDialogBox(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: Colors.green.shade600,
      icon: Icons.check_circle,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(
      context,
      message: message,
      backgroundColor: Colors.red.shade600,
      icon: Icons.error,
    );
  }

  static void _showSnackbar(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16),
      backgroundColor: backgroundColor,
      duration: Duration(seconds: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ],
      ),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
