import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_info_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_status_widget.dart';
import 'package:flutter/material.dart';

class AgentInfoContainer extends StatelessWidget {
  final AgentModel agentData;
  final VoidCallback onCallPress;
  const AgentInfoContainer({
    super.key,
    required this.agentData,
    required this.onCallPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: (MediaQuery.of(context).size.height * 0.86) * 0.3,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.black26, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20), // Optional
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          AgentInfoWidget(
            onCallPress: onCallPress,
            agentData: agentData,
          ),
          AgentStatusWidget(
            status: agentData.status,
          )
        ],
      ),
    );
  }
}
