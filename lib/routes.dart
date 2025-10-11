import 'package:algarve_house_hunters_system/agen_login_screen/view/agent_login_screen.dart';
import 'package:algarve_house_hunters_system/agent_add_client_screen/view/agent_add_client_screen.dart';
import 'package:algarve_house_hunters_system/agent_client_info_screen/view/agent_client_info_screen.dart';
import 'package:algarve_house_hunters_system/agent_client_info_screen/view/agent_client_information_screen.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/view/agent_customer_property_allocation_screen.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/view/agent_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/agent_document_screen/view/agent_document_screen.dart';
import 'package:algarve_house_hunters_system/agent_info_update_screen/view/agent_info_update_screen.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/view/agent_listing_screen.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/view/agent_property_info_screen.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_document_screen/view/agent_onboarding_document_screen.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/view/agent_onboarding_screen.dart';
import 'package:algarve_house_hunters_system/agent_password_set_screen/view/agent_password_screen.dart';
import 'package:algarve_house_hunters_system/agent_unit_property_screen/view/agent_unit_property_screen.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/view/customer_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/customer_preference_screen/view/customer_preference_screen.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/view/customer_property_listing_screen.dart';
import 'package:algarve_house_hunters_system/login_screen/view/login_screen.dart';
import 'package:algarve_house_hunters_system/manager_add_client_screen/view/manager_add_client_screen.dart';
import 'package:algarve_house_hunters_system/manager_agent_info_section_secreen/view/manager_agent_info_section_screen.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/view/manager_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/view/manager_log_in_screen.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/view/manager_property_info_screen.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/view/manager_property_management_screen.dart';
import 'package:algarve_house_hunters_system/otp_screen/view/otp_screen.dart';
import 'package:algarve_house_hunters_system/sign_up_screen/view/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static final GoRouter router = GoRouter(
    initialLocation: '/manager-log-in-screen',
    routes: [
      GoRoute(
        path: '/log-in',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/otp-screen',
        builder: (context, state) => const OtpScreen(
          emailAddress: 's.abdulkadhar11@gmail.com',
        ),
      ),
      GoRoute(
        path: '/customer_dashboard_screen/:clientId',
        builder: (context, state) {
          final clientId = state.pathParameters['clientId']!;
          return CustomerDashboardScreen(
            clientId: clientId,
          );
        },
      ),
      GoRoute(
        path: '/customer-property-listing-screen/:clientId',
        builder: (context, state) {
          final clientId = state.pathParameters['clientId']!;
          return CustomerPropertyListingScreen(
            clientId: clientId,
          );
        },
      ),
      GoRoute(
        path: '/agent-dashboard-screen/:agentId',
        builder: (context, state) {
          final agent_id = state.pathParameters['agentId']!;
          return AgentDashboardScreen(
            agentId: agent_id,
          );
        },
      ),
      GoRoute(
        path: '/agent-listing-screen/:agent_id',
        builder: (context, state) {
          final agent_id = state.pathParameters['agent_id']!;
          print('agent id: ${agent_id}');
          return AgentListingScreen(
            agentId: agent_id,
          );
        },
      ),
      GoRoute(
        path: '/agent-customer-property-allocation/:agent_id',
        builder: (context, state) {
          final agent_id = state.pathParameters['agent_id']!;
          return AgentCustomerPropertyAllocationScreen(
            agentId: agent_id,
          );
        },
      ),
      GoRoute(
        path: '/agent-unit-property-screen',
        builder: (context, state) => const AgentUnitPropertyScreen(),
      ),
      GoRoute(
        path: '/manager-dashboard-screen',
        builder: (context, state) => const ManagerDashboardScreen(),
      ),
      GoRoute(
        path: '/manager-log-in-screen',
        builder: (context, state) => const ManagerLoginScreen(),
      ),
      GoRoute(
        path: '/manager-agent-onboarding',
        builder: (context, state) => const AgentOnboardingScreen(),
      ),
      GoRoute(
        path: '/manager-agent-onboarding-document-screen',
        builder: (context, state) => const AgentOnboardingDocumentScreen(),
      ),
      GoRoute(
        path: '/manager-agent-info-section-screen',
        builder: (context, state) {
          return ManagerAgentInfoSectionScreen();
        },
      ),
      GoRoute(
        path: '/manager-agent-info-section-screens/:agentId',
        builder: (context, state) {
          final agentId = state.pathParameters['agentId']!;
          return ManagerAgentInfoSectionScreen(
            agentId: agentId,
            key: ValueKey(agentId),
          );
        },
      ),
      GoRoute(
        path: '/manager-client-info-screen/:clientId',
        builder: (context, state) {
          final clientId = state.pathParameters['clientId']!;
          return AgentClientInfoScreen(
            clientId: clientId,
            key: ValueKey(clientId),
          );
        },
      ),
      GoRoute(
        path: '/agent-client-info-screen/:clientId/:agentId',
        builder: (context, state) {
          final clientId = state.pathParameters['clientId']!;
          final agentId = state.pathParameters['agentId']!;
          return AgentClientInformationScreen(
            clientId: clientId,
            agentId: agentId,
          );
        },
      ),
      GoRoute(
        path: '/manager-add-client-screen',
        builder: (context, state) => const ManagerAddClientScreen(),
      ),
      GoRoute(
        path: '/agent-login-screen',
        builder: (context, state) => const AgentLoginScreen(),
      ),
      GoRoute(
        path: '/customer-preference-screen',
        builder: (context, state) => CustomerPreferenceScreen(
          customerId: 'sampleID',
        ),
      ),
      GoRoute(
        path: '/manager-property-management-screen',
        builder: (context, state) => const MangerPropertyManagementScreen(),
      ),
      GoRoute(
        path: '/manager-property-info-screen/:propertyId/:managerId',
        builder: (context, state) {
          final propertyId = state.pathParameters['propertyId']!;
          final managerId = state.pathParameters['managerId']!;
          return ManagerPropertyInfoScreen(
            propertyId: propertyId,
            managerId: managerId,
          );
        },
      ),
      GoRoute(
        path: '/agent-info-update-screen/:agentId',
        builder: (context, state) {
          final agentId = state.pathParameters['agentId']!;
          return AgentInfoUpdateScreen(
            agentId: agentId,
          );
        },
      ),
      GoRoute(
        path: '/agent-property-info-screen/:agentId/:propertyId',
        builder: (context, state) {
          final agentId = state.pathParameters['agentId']!;
          final propertyId = state.pathParameters['propertyId']!;
          return AgentPropertyInfoScreen(
            agentId: agentId,
            propertyId: propertyId,
          );
        },
      ),
      GoRoute(
        path: '/agent-add-user-screen/:agentId',
        builder: (context, state) {
          final agentId = state.pathParameters['agentId']!;
          return AgentAddClientScreen(
            agentId: agentId,
          );
        },
      ),
      GoRoute(
        path: '/agent-set-password/:agentId',
        builder: (context, state) {
          final agentId = state.pathParameters['agentId']!;
          return AgentPasswordScreen(
            agentId: agentId,
          );
        },
      ),
      GoRoute(
        path: '/agent-onboarding-document-screen/:agentId',
        builder: (context, state) {
          final agentId = state.pathParameters['agentId']!;
          return AgentDocumentScreen(
            agentId: agentId,
          );
        },
      ),
    ],
  );
}
