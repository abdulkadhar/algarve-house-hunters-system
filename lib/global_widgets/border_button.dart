import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CustomBorderButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color borderColor;
  final Color labelColor;
  const CustomBorderButton({
    super.key,
    required this.label,
    required this.onTap,
    this.borderColor = Colors.black,
    this.labelColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: ThemeController.smallTextStyle(
            color: labelColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
