import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/model/unit_agent_checklist_model.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/model/customer_preference_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/dashboard_user_info_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/property_model.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';

enum PropertyAllocationOption {
  userPref,
  assignProperty,
  checklist,
}

class AgentControllerPropertyAllocationController {
  static List<UnitAgentChecklistModel> getSampleCheckListItems() => [
        UnitAgentChecklistModel(
          title: 'Client Completed JotForm',
          description: 'Ensure onboarding form is completed by client.',
        ),
        UnitAgentChecklistModel(
          title: 'First Call Confirmed',
          description: 'Confirm first call with client and mark as scheduled.',
        ),
        UnitAgentChecklistModel(
          title: 'Has Fiscal',
          description: 'Confirm the client has fiscal details (e.g., budget).',
        ),
        UnitAgentChecklistModel(
          title: 'Has Lawyer',
          description:
              'Confirm that the client has a lawyer or refer them to one.',
        ),
        UnitAgentChecklistModel(
          title: 'Search Started',
          description: 'Confirm that property search process has started.',
        ),
        UnitAgentChecklistModel(
          title: 'Viewings Confirmed',
          description: 'Confirm viewing appointments are set with the client.',
        ),
        UnitAgentChecklistModel(
          title: 'Viewings Booked',
          description: 'Confirm viewings are officially booked with agencies.',
        ),
        UnitAgentChecklistModel(
          title: 'Property Found',
          description: 'Confirm that the client has found a suitable property.',
        ),
        UnitAgentChecklistModel(
          title: 'Offer Made',
          description: 'Confirm an offer has been made on the property.',
        ),
        UnitAgentChecklistModel(
          title: 'Offer Confirmed',
          description: 'Confirm the offer has been accepted by the seller.',
        ),
        UnitAgentChecklistModel(
          title: 'CPCV Booked',
          description:
              'Confirm that the Contract of Purchase and Completion (CPCV) has been booked.',
        ),
        UnitAgentChecklistModel(
          title: 'KYC Requested',
          description:
              'Request and confirm that Know Your Customer (KYC) documents have been requested.',
        ),
        UnitAgentChecklistModel(
          title: 'Review Requested',
          description:
              'Ask client to review and give feedback on the process and property search.',
        ),
        UnitAgentChecklistModel(
          title: 'All Docs Received',
          description: 'Confirm all necessary documentation has been received.',
        ),
        UnitAgentChecklistModel(
          title: 'Deed Booked',
          description:
              'Confirm that the deed has been booked for the property transfer.',
        ),
        UnitAgentChecklistModel(
          title: 'Sale Completed',
          description: 'Confirm that the property sale has been completed.',
        ),
        UnitAgentChecklistModel(
          title: 'After Care Required?',
          description:
              'Confirm if any after-care services are required post-sale (e.g., moving support, additional advice).',
        ),
      ];

  static List<PropertyModel> getSampleSelectedPropertyList() => [
        PropertyModel(
          ourRef: 'https://infocasa.pt/realestates/7155424',
          listingRef: '322/M/02127',
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
          propertyDescription: "This the sample property description",
          propertyImages: propertyImagePaths,
          propertyName: 'Recently added property 1',
          propertyId: 'afshghgshagsh2',
        ),
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
          propertyDescription: "This the sample property description",
          propertyImages: propertyImagePaths,
          propertyName: 'Recently added property 8',
          propertyId: 'afshghgshagsh',
        ),
        PropertyModel(
          ourRef: 'https://infocasa.pt/realestates/7155424',
          listingRef: '322/M/02129',
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
          propertyDescription: "This the sample property description",
          propertyImages: propertyImagePaths,
          propertyName: 'Recently added property 3',
          propertyId: 'afshghgshagsh1',
        )
      ];

  static List<String> propertyImagePaths = [
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1686090449192-4ab1d00cb735?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1687960117069-567a456fe5f3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1483097365279-e8acd3bf9f18?q=80&w=2011&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1516156008625-3a9d6067fab5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1498373419901-52eba931dc4f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1472224371017-08207f84aaae?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  static String listToString(List<String> data) {
    return data.join(', ');
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
