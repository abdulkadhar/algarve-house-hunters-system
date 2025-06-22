import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/get_in_touch_button.dart';
import 'package:flutter/material.dart';

class AgentInfoSection extends StatelessWidget {
  final AgentModel agentData;
  final VoidCallback? onPress;
  const AgentInfoSection({
    super.key,
    required this.agentData,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeController.pageBackgroundSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agent Profile',
            style: ThemeController.normalTextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage(
                    agentData.profileImgPath,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              agentData.agentName,
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              agentData.agentDescription,
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w300,
                size: 14,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: GetInTouchButton(
              btnLabel: 'Get in touch',
              onBtnPress: onPress,
            ),
          )
        ],
      ),
    );
  }
}
