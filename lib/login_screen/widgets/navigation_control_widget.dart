import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class NavigationControlWidget extends StatelessWidget {
  final VoidCallback onPress;
  final IconData iconData;
  const NavigationControlWidget({
    super.key,
    required this.onPress,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        icon: Icon(
          iconData,
          color: ThemeController.iconPrimaryColor,
        ),
        onPressed: onPress,
      ),
    );
  }
}
