import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/list_item_avatar.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class PropertyInfoLabelWidget extends StatelessWidget {
  final IconData iconData;
  final String labelValue;
  final Color avatarBgColor;
  final Color bgColor;
  final Color avatarBorderColor;
  final Color labelBorderColor;
  const PropertyInfoLabelWidget({
    super.key,
    required this.iconData,
    required this.labelValue,
    this.avatarBgColor = ThemeController.containerPrimaryBorderColor,
    this.bgColor = ThemeController.containerSecondaryColor,
    this.avatarBorderColor = ThemeController.containerPrimaryBorderColor,
    this.labelBorderColor = ThemeController.containerPrimaryBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: bgColor,
        border: Border.all(
          color: labelBorderColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ListItemAvatar(
            iconData: iconData,
            bgColor: avatarBgColor,
            iconColor: ThemeController.iconPrimaryColor,
            borderColor: avatarBorderColor,
            borderWidth: 2,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            labelValue,
            style: ThemeController.normalTextStyle(),
          )
        ],
      ),
    );
  }
}
