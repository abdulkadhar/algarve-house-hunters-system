import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/view/agent_customer_property_allocation_screen.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/view/agent_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/view/agent_listing_screen.dart';
import 'package:algarve_house_hunters_system/agent_unit_property_screen/view/agent_unit_property_screen.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/view/customer_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/view/customer_property_listing_screen.dart';
import 'package:algarve_house_hunters_system/login_screen/view/login_screen.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/view/manager_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/otp_screen/view/otp_screen.dart';
import 'package:algarve_house_hunters_system/sign_up_screen/view/sign_up_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AlgarveHouseHuntersSystem());
}

class AlgarveHouseHuntersSystem extends StatelessWidget {
  const AlgarveHouseHuntersSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Algarve House Hunters',
      initialRoute: '/manager-dashboard-screen',
      routes: {
        '/log-in': (context) => const LoginScreen(),
        '/sign-up': (context) => const SignUpScreen(),
        '/otp-screen': (context) => const OtpScreen(
              emailAddress: 's.abdulkadhar11@gmail.com',
            ),
        '/customer_dashboard_screen': (context) =>
            const CustomerDashboardScreen(),
        '/customer-property-listing-screen': (context) =>
            const CustomerPropertyListingScreen(),
        '/agent-dashboard-screen': (context) => const AgentDashboardScreen(),
        '/agent-listing-screen': (context) => const AgentListingScreen(),
        '/agent-customer-property-allocation': (context) =>
            const AgentCustomerPropertyAllocationScreen(),
        '/agent-unit-property-screen': (context) =>
            const AgentUnitPropertyScreen(),
        '/manager-dashboard-screen': (context) =>
            const ManagerDashboardScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
