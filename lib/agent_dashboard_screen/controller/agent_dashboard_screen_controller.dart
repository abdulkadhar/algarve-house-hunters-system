import 'package:algarve_house_hunters_system/agent_dashboard_screen/model/customer_preference_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/dashboard_user_info_model.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';

enum AgentDashboardOption {
  dashboard,
  listings,
  actions,
  calendar,
  customer,
}

class AgentDashboardScreenController {
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
            designation: 'Sr Engineer',
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
