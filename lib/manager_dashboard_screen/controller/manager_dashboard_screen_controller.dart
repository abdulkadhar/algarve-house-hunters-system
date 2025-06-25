import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';

enum ManagerDashboardOption {
  dashboard,
  agents,
  clients,
  listings,
}

class ManagerDashboardScreenController {
  static AgentModel getSampleManagerModel() {
    return AgentModel(
      agentName: 'Rebecca',
      agentDesignation: 'Beginner',
      status: AgentStatus.available,
      agentDescription: "sample description",
      profileImgPath: 'https://randomuser.me/api/portraits/women/26.jpg',
    );
  }
}
