import 'package:algarve_house_hunters_system/agent_dashboard_screen/model/customer_preference_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/dashboard_user_info_model.dart';

class CustomerDataModel {
  final DashboardUserInfoModel basicData;
  final CustomerPreferenceModel preferenceData;
  CustomerDataModel({
    required this.basicData,
    required this.preferenceData,
  });
}
