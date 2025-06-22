import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';
import 'package:flutter/material.dart';

class AgentStatusWidget extends StatelessWidget {
  final AgentModel agentData;
  const AgentStatusWidget({
    super.key,
    required this.agentData,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: CircleAvatar(
        backgroundColor: CustomerDashboardScreenController.getAgentStatusColor(
          agentData.status,
        ),
        radius: 8,
      ),
    );
  }
}
