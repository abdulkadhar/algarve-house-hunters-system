import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color optionColor;
  const OptionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.optionColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 25),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: optionColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: ThemeController.smallTextStyle(
            color: optionColor,
          ),
        ),
      ),
    );
  }
}
