import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:flutter/material.dart';

class AgentStatusWidget extends StatelessWidget {
  final AgentStatus status;
  const AgentStatusWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: CircleAvatar(
        backgroundColor: CustomerDashboardScreenController.getAgentStatusColor(
          status,
        ),
        radius: 8,
      ),
    );
  }
}
