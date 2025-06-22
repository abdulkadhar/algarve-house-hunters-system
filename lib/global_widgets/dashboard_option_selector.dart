import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class DashboardOptionSelector extends StatelessWidget {
  final bool isEnabled;
  final IconData iconData;
  final String optionLabel;
  final VoidCallback onTap;
  const DashboardOptionSelector({
    super.key,
    required this.isEnabled,
    required this.iconData,
    required this.optionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: isEnabled
            ? BoxDecoration(
                color: ThemeController.containerPrimaryColor,
                borderRadius: BorderRadius.circular(100),
              )
            : null,
        padding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 18,
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: isEnabled
                  ? ThemeController.iconPrimaryColor
                  : ThemeController.iconSecondaryColor,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              optionLabel,
              style: ThemeController.smallTextStyle(
                fontWeight: FontWeight.w700,
                color: isEnabled
                    ? ThemeController.textTertiaryColor
                    : ThemeController.textPrimaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
