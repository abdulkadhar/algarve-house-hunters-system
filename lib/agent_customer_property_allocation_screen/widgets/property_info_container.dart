import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class PropertyInfoContainer extends StatelessWidget {
  final String label;
  final Color bgColor;
  const PropertyInfoContainer({
    super.key,
    required this.label,
    this.bgColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(5),
      child: Text(
        label,
        style: ThemeController.smallTextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
