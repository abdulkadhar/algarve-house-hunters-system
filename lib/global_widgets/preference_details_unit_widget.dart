import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class PreferenceDetailsUnitWidget extends StatelessWidget {
  final String title;
  final String value;
  final double width;
  const PreferenceDetailsUnitWidget({
    super.key,
    required this.title,
    required this.value,
    this.width = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: ThemeController.normalTextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            value,
            style: ThemeController.normalTextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
