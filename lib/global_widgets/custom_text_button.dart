import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final bool isEnabled;
  final String label;
  final VoidCallback onTap;
  final Color labelColor;
  const CustomTextButton({
    super.key,
    required this.isEnabled,
    required this.label,
    required this.onTap,
    this.labelColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: ThemeController.smallTextStyle(
          color: isEnabled ? labelColor : Colors.grey,
          fontWeight: isEnabled ? FontWeight.w900 : FontWeight.w400,
        ),
      ),
    );
  }
}
