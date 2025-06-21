import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AgentInfoWidget extends StatelessWidget {
  final AgentModel agentData;
  final VoidCallback onCallPress;
  const AgentInfoWidget({
    super.key,
    required this.agentData,
    required this.onCallPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Lottie.asset(
              'assets/lottie/agent_lottie.json',
              height: 120,
              width: 180,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  agentData.agentName,
                  style: ThemeController.titleTextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  agentData.agentDesignation,
                  style: ThemeController.smallTextStyle(
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.verified,
                      color: Colors.green,
                      size: 20,
                      weight: 100,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Verified',
                      style: ThemeController.smallTextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        size: 12,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: onCallPress,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.duo,
                  color: Colors.black,
                  size: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "New Meeting",
                  style: ThemeController.smallTextStyle(),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
