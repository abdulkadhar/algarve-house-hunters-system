import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class SideOptionButton extends StatelessWidget {
  final String label;
  final IconData iconData;
  final bool isSelected;
  const SideOptionButton({
    super.key,
    required this.label,
    required this.iconData,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: isSelected ? Colors.white : Colors.black,
            ),
            child: Icon(
              iconData,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: ThemeController.normalTextStyle(
              fontWeight: FontWeight.w800,
              size: 14,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
