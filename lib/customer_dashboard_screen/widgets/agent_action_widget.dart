import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/list_item_avatar.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AgentActionWidget extends StatelessWidget {
  final IconData iconData;
  final String actionName;
  final String actionValue;
  final VoidCallback onActionPress;
  const AgentActionWidget({
    super.key,
    required this.iconData,
    required this.actionName,
    required this.actionValue,
    required this.onActionPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onActionPress,
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        height: (MediaQuery.of(context).size.height * 0.86) * 0.1,
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: ThemeController.pageBackgroundSecondaryColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          children: [
            ListItemAvatar(
              iconData: iconData,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              actionName,
              style: ThemeController.normalTextStyle(
                size: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              actionValue,
              style: ThemeController.normalTextStyle(
                size: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
