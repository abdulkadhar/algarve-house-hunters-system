import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class PropertyFeatureCard extends StatelessWidget {
  final String featureName;
  final String featureValue;
  const PropertyFeatureCard({
    super.key,
    required this.featureName,
    required this.featureValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
          color: ThemeController.pageBackgroundSecondaryColor,
          borderRadius: BorderRadius.circular(100)),
      child: Text(
        '$featureName: $featureValue',
        style: ThemeController.smallTextStyle(
          size: 12,
        ),
      ),
    );
  }
}
