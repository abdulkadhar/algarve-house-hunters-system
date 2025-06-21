// Status
// Acrtion title
// Action Description
// Action Id
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';

class ActionModel {
  final ActionStatus status;
  final String title;
  final String description;
  final String actionId;

  ActionModel({
    required this.status,
    required this.title,
    required this.description,
    required this.actionId,
  });
}
