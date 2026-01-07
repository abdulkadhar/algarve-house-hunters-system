import 'package:algarve_house_hunters_system/agent_dashboard_screen/model/customer_preference_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/dashboard_user_info_model.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'dart:math';
import 'package:intl/intl.dart';

enum AgentDashboardOption {
  dashboard,
  listings,
  actions,
  calendar,
  customer,
}

class AgentDashboardScreenController {
  static String formatNoIntl(String iso) {
    final dt = DateTime.parse(iso);
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final dd = dt.day.toString().padLeft(2, '0');
    final mmm = months[dt.month - 1];
    final yyyy = dt.year.toString();
    final h12 = (dt.hour % 12 == 0) ? 12 : dt.hour % 12;
    final mm = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$dd/$mmm/$yyyy $h12:$mm $ampm';
  }

  static String formatIsoToCustom(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
    return DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(dateTime);
  }

  static String formatIsoToCustomTime(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
    return DateFormat("yyyy-MM-dd HH:mm").format(dateTime);
  }

  static String generateCustomId({String prefix = 'CMT', int length = 8}) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random.secure();
    final code =
        List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
    return '$prefix-$code';
  }

  static AgentModel getSampleAgentModel() {
    return AgentModel(
      agentName: 'Richard',
      agentDesignation: 'Beginner',
      status: AgentStatus.available,
      agentDescription: "sample description",
      profileImgPath: 'https://randomuser.me/api/portraits/women/26.jpg',
    );
  }

  static List<CustomerDataModel> getSampleAssignedUserModel() => [
        CustomerDataModel(
          basicData: DashboardUserInfoModel(
            designation: 'Manager',
            profileImg: 'https://randomuser.me/api/portraits/women/28.jpg',
            userName: 'Rebecca',
            userId: 'ID23',
          ),
          preferenceData: CustomerPreferenceModel(
            findingPreference: ['Apartment', 'House', 'villa'],
            bedNumber: 4,
            bathNumber: 5,
            requirementPreference: [
              'Pool',
              'Garden',
              'Garage',
            ],
            otherPreference: [
              'A new build',
              'Relative new',
              'Full renovation is OK',
            ],
            houseRegardsPreference: ['Detached'],
            neighborPreference: ['Never mind'],
            locationPreference: ['East Algarve'],
            areaInterestPreference: 'None',
            M2Preference: 'bxk1234',
            buyingPreference: ['Immediately'],
            valueSpendPreference: 120000,
            taxPreference: ['No taxes will be on top'],
            residenceInfo: 'Yes I live here',
            languagePreference: ['English', 'Spanish'],
            viewingPreference: '',
            otherAgentsStatus: 'Yes, I am working with other agents',
            fiscalStatus: 'Yes',
            bankStatus: 'Yes',
            additionalInfo: '',
            email: 'sample@gmail.com',
            phoneNumber: '+919080823869',
            appointmentInfo: 'October 26, 9:00 PM',
          ),
        ),
        CustomerDataModel(
          basicData: DashboardUserInfoModel(
            designation: 'Business Man',
            profileImg: 'https://randomuser.me/api/portraits/man/8.jpg',
            userName: 'Aldrin',
            userId: 'ID24',
          ),
          preferenceData: CustomerPreferenceModel(
            findingPreference: ['Apartment', 'House', 'villa'],
            bedNumber: 4,
            bathNumber: 5,
            requirementPreference: [
              'Pool',
              'Garden',
              'Garage',
            ],
            otherPreference: [
              'A new build',
              'Relative new',
              'Full renovation is OK',
            ],
            houseRegardsPreference: ['Detached'],
            neighborPreference: ['Never mind'],
            locationPreference: ['East Algarve'],
            areaInterestPreference: 'None',
            M2Preference: 'bxk1234',
            buyingPreference: ['Immediately'],
            valueSpendPreference: 120000,
            taxPreference: ['No taxes will be on top'],
            residenceInfo: 'Yes I live here',
            languagePreference: ['English', 'Spanish'],
            viewingPreference: '',
            otherAgentsStatus: 'Yes, I am working with other agents',
            fiscalStatus: 'Yes',
            bankStatus: 'Yes',
            additionalInfo: '',
            email: 'sample@gmail.com',
            phoneNumber: '+919843978280',
            appointmentInfo: 'October 26, 9:00 PM',
          ),
        ),
        CustomerDataModel(
          basicData: DashboardUserInfoModel(
            designation: 'Business Man',
            profileImg: 'https://randomuser.me/api/portraits/man/8.jpg',
            userName: 'Aldrin',
            userId: 'ID24',
          ),
          preferenceData: CustomerPreferenceModel(
            findingPreference: ['Apartment', 'House', 'villa'],
            bedNumber: 4,
            bathNumber: 5,
            requirementPreference: [
              'Pool',
              'Garden',
              'Garage',
            ],
            otherPreference: [
              'A new build',
              'Relative new',
              'Full renovation is OK',
            ],
            houseRegardsPreference: ['Detached'],
            neighborPreference: ['Never mind'],
            locationPreference: ['East Algarve'],
            areaInterestPreference: 'None',
            M2Preference: 'bxk1234',
            buyingPreference: ['Immediately'],
            valueSpendPreference: 120000,
            taxPreference: ['No taxes will be on top'],
            residenceInfo: 'Yes I live here',
            languagePreference: ['English', 'Spanish'],
            viewingPreference: '',
            otherAgentsStatus: 'Yes, I am working with other agents',
            fiscalStatus: 'Yes',
            bankStatus: 'Yes',
            additionalInfo: '',
            email: 'sample@gmail.com',
            phoneNumber: '+91850856148',
            appointmentInfo: 'October 26, 9:00 PM',
          ),
        ),
      ];
}
