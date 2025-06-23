import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AddMoreButton extends StatelessWidget {
  final VoidCallback onButtonPress;
  final String buttonLabel;
  final IconData iconData;
  final double height;
  const AddMoreButton({
    super.key,
    required this.onButtonPress,
    required this.buttonLabel,
    this.iconData = Icons.add,
    this.height = 45,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onButtonPress,
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        height: height,
        width: 200,
        decoration: BoxDecoration(
          color: ThemeController.buttonColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              iconData,
              color: Colors.white,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              buttonLabel,
              style: ThemeController.buttonLabelTextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
