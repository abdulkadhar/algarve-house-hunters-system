import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/action_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/dashboard_user_info_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/property_model.dart';
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
  static List<String> propertyImagePaths = [
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1686090449192-4ab1d00cb735?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1687960117069-567a456fe5f3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1483097365279-e8acd3bf9f18?q=80&w=2011&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1516156008625-3a9d6067fab5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1498373419901-52eba931dc4f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1472224371017-08207f84aaae?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  static List<PropertyModel> getSamplePropertyData = [
    PropertyModel(
      ourRef: 'https://infocasa.pt/realestates/7155424',
      listingRef: '322/M/02128',
      contactEmail: 'vrsa@era.pt',
      price: 159900,
      propertyM2: 112,
      clientLink: 'https://url.infocasa.pt/cvwd3a30',
      location: 'Ribeira da Gafa',
      bedsNumber: 2,
      bathsNumber: 3,
      plotNumber: 515,
      distanceFromCoast: 12,
      googleMapLink: 'https://maps.app.goo.gl/jxNqTsRPYpVd9uTu9',
    )
  ];
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
