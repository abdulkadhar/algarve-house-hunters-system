import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/action_model.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ActionContainerWidget extends StatelessWidget {
  final ActionModel actionModel;
  final VoidCallback? onTap;
  const ActionContainerWidget({
    super.key,
    required this.actionModel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      CustomerDashboardScreenController.getActionStatusColor(
                    actionModel.status,
                  ),
                  radius: 20,
                  child: Icon(
                    CustomerDashboardScreenController.getActionStatusIconData(
                      actionModel.status,
                    ),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actionModel.title,
                      style: ThemeController.normalTextStyle(
                        fontWeight: FontWeight.w800,
                        size: 14,
                      ),
                    ),
                    Text(
                      actionModel.description,
                      style: ThemeController.normalTextStyle(
                        fontWeight: FontWeight.w400,
                        size: 13,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
