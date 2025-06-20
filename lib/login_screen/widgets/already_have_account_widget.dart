import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAccountWidget extends StatelessWidget {
  final String actionName;
  final VoidCallback onClick;
  const AlreadyHaveAccountWidget({
    super.key,
    required this.actionName,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: RichText(
        text: TextSpan(
          text: "Already have an account? ",
          style: ThemeController.smallTextStyle(),
          children: <TextSpan>[
            TextSpan(
              text: actionName,
              style: ThemeController.smallTextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
