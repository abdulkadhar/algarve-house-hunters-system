import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/action_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/dashboard_user_info_model.dart';
import 'package:flutter/material.dart';

enum CustomerDashboardOption {
  dashboard,
  listings,
  feedback,
}

enum ActionStatus {
  notStarted,
  inProgress,
  completed,
}

enum AgentStatus {
  available,
  offline,
  away,
}

class CustomerDashboardScreenController {
  static DashboardUserInfoModel getCurrentUserInfoModel() =>
      DashboardUserInfoModel(
        designation: 'Sr Software Engineer',
        userName: 'Abdul Kadhar',
        profileImg: 'https://randomuser.me/api/portraits/women/26.jpg',
      );

  static ActionModel getSampleActionModel() => ActionModel(
        status: ActionStatus.notStarted,
        title: 'First Login',
        description: 'Sample edit action',
        actionId: 'Sample ID',
      );

  static Color getActionStatusColor(ActionStatus status) {
    switch (status) {
      case ActionStatus.notStarted:
        return Colors.red;
      case ActionStatus.inProgress:
        return Colors.amber;
      case ActionStatus.completed:
        return Colors.green;
    }
  }

  static IconData getActionStatusIconData(ActionStatus status) {
    switch (status) {
      case ActionStatus.notStarted:
        return Icons.not_started;
      case ActionStatus.inProgress:
        return Icons.history;
      case ActionStatus.completed:
        return Icons.done;
    }
  }

  static Color getAgentStatusColor(AgentStatus status) {
    switch (status) {
      case AgentStatus.available:
        return const Color(0xFF5cd97f);
      case AgentStatus.offline:
        return Colors.grey;
      case AgentStatus.away:
        return Colors.amber;
    }
  }
}
