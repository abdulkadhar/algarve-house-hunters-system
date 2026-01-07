import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class QuickActionWidget extends StatelessWidget {
  final VoidCallback onPress;
  final String label;
  final bool isSelected;
  final IconData icons;

  const QuickActionWidget({
    super.key,
    required this.isSelected,
    required this.label,
    required this.onPress,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        InkWell(
          onTap: onPress,
          child: Container(
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
                  ),
                  child: Icon(
                    icons,
                    color: isSelected ? Colors.white : Colors.black,
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
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
