import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback? onButtonPress;
  final String buttonLabel;
  const SubmitButton({
    super.key,
    required this.onButtonPress,
    required this.buttonLabel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onButtonPress,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: ThemeController.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          buttonLabel,
          style: ThemeController.buttonLabelTextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
