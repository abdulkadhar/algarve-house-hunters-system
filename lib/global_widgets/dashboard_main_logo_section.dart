import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class DashboardMainLogoSection extends StatelessWidget {
  final VoidCallback? onTap;
  const DashboardMainLogoSection({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Image.asset(
            AssetsController.mainLogoPath,
            height: 80,
            width: 80,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Algarve House Hunters",
            style: ThemeController.normalTextStyle(
              fontWeight: FontWeight.w900,
            ),
          )
        ],
      ),
    );
  }
}
