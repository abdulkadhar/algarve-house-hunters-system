import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';

class AgentModel {
  final String agentName;
  final String agentDesignation;
  final AgentStatus status;
  final String profileImgPath;
  final String agentDescription;

  AgentModel({
    required this.agentName,
    required this.agentDesignation,
    required this.status,
    required this.agentDescription,
    required this.profileImgPath,
  });
}
