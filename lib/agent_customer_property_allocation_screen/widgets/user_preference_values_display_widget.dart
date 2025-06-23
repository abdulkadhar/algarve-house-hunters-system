import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class UserPreferenceValuesDisplayWidget extends StatelessWidget {
  final String labelName;
  final String labelValue;
  const UserPreferenceValuesDisplayWidget({
    super.key,
    required this.labelName,
    required this.labelValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            labelName,
            style: ThemeController.normalTextStyle(),
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(10),
          // width: 200,
          child: Text(
            labelValue,
            style: ThemeController.smallTextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
