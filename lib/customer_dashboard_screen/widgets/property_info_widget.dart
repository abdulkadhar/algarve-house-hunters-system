import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/list_item_avatar.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class PropertyInfoWidget extends StatelessWidget {
  final IconData iconData;
  final String infoValue;
  final String infoLabel;
  const PropertyInfoWidget({
    super.key,
    required this.iconData,
    required this.infoValue,
    required this.infoLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          ListItemAvatar(
            iconData: iconData,
          ),
          const SizedBox(
            width: 6,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                infoLabel,
                style: ThemeController.smallTextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Text(
                infoValue,
                style: ThemeController.smallTextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
