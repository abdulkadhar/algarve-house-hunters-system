import 'package:algarve_house_hunters_system/agen_login_screen/view/agent_login_screen.dart';
import 'package:algarve_house_hunters_system/agent_client_info_screen/view/agent_client_info_screen.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/view/agent_customer_property_allocation_screen.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/view/agent_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/view/agent_listing_screen.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_document_screen/view/agent_onboarding_document_screen.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/view/agent_onboarding_screen.dart';
import 'package:algarve_house_hunters_system/agent_unit_property_screen/view/agent_unit_property_screen.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/view/customer_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/customer_preference_screen/view/customer_preference_screen.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/view/customer_property_listing_screen.dart';
import 'package:algarve_house_hunters_system/login_screen/view/login_screen.dart';
import 'package:algarve_house_hunters_system/manager_add_client_screen/view/manager_add_client_screen.dart';
import 'package:algarve_house_hunters_system/manager_agent_info_section_secreen/view/manager_agent_info_section_screen.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/view/manager_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/view/manager_log_in_screen.dart';
import 'package:algarve_house_hunters_system/otp_screen/view/otp_screen.dart';
import 'package:algarve_house_hunters_system/sign_up_screen/view/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:algarve_house_hunters_system/routes.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  usePathUrlStrategy();
  runApp(const AlgarveHouseHuntersSystem());
}

class AlgarveHouseHuntersSystem extends StatelessWidget {
  const AlgarveHouseHuntersSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routes.router,
      title: 'Algarve House Hunters',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const LoginScreen(),
    );
  }
}
