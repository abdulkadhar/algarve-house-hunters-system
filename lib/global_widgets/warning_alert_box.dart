import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class GetAlertDialogBox {
  static Future<void> warningAlertDialogBox(
    BuildContext context, {
    required VoidCallback onConfirm,
    required String title,
    required String warningText,
    required VoidCallback onCancel,
    required Text cancelTextWidget,
    required String confirmLabel,
    Color confirmButtonColor = Colors.black,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(title),
          content: Text(
            warningText,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                onCancel();
              },
              child: cancelTextWidget,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: confirmButtonColor,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              child: Text(
                confirmLabel,
                style: ThemeController.smallTextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
