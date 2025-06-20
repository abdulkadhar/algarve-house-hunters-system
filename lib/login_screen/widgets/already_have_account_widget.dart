import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAccountWidget extends StatelessWidget {
  final String prefixText;
  final String actionName;
  final Color prefixTextColor;
  final Color suffixTextColor;
  final VoidCallback onClick;
  const AlreadyHaveAccountWidget({
    super.key,
    required this.prefixText,
    required this.actionName,
    required this.onClick,
    this.prefixTextColor = Colors.black,
    this.suffixTextColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: RichText(
        text: TextSpan(
          text: "$prefixText ",
          style: ThemeController.smallTextStyle(color: prefixTextColor),
          children: <TextSpan>[
            TextSpan(
              text: actionName,
              style: ThemeController.smallTextStyle(
                fontWeight: FontWeight.w700,
                color: suffixTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
