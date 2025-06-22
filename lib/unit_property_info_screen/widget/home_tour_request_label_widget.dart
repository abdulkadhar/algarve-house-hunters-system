import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class HomeTourRequestLabelWidget extends StatelessWidget {
  final String labelName;
  final String labelValue;
  const HomeTourRequestLabelWidget({
    super.key,
    required this.labelName,
    required this.labelValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          labelName,
          style: ThemeController.normalTextStyle(),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.all(10),
          width: 200,
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
