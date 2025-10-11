import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_document_screen/view/agent_document_screen.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/property_addition_form.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/controller/manager_property_management_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/manager_property_unit_tile_widget.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/quick_action_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

class AgentListingScreen extends StatefulWidget {
  final String agentId;
  const AgentListingScreen({
    super.key,
    required this.agentId,
  });

  @override
  State<AgentListingScreen> createState() => _AgentListingScreenState();
}

class _AgentListingScreenState extends State<AgentListingScreen> {
  // NOTE State for internal page option
  PropertyManagementOption propertyManagementOption =
      PropertyManagementOption.addProperty;

  // NOTE over all dashboard option
  AgentDashboardOption dashboardOption = AgentDashboardOption.listings;

  // NOTE State for properties
  List<Map<String, dynamic>> allProperties = [];

  // NOTE method for changing the dashboard option
  void changeDashboardOption(AgentDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  // NOTE Method for changing the internal state
  void changePropertyOption(PropertyManagementOption option) {
    propertyManagementOption = option;
    setState(() {});
  }

  void getAllProperties() async {
    await ApiController.getAgentProperties(widget.agentId, onSuccess: (data) {
      final propertyData = jsonDecode(data);
      final List<Map<String, dynamic>> myList =
          List<Map<String, dynamic>>.from(propertyData);
      allProperties = myList;
      print(allProperties[0]);
      print("lenght of all properties:${allProperties.length}");
      setState(() {});
    }, onError: (errorData) {
      // print(jsonDecode(errorData));
    });
  }

  @override
  void initState() {
    super.initState();
    getAllProperties();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.pageBackgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const DashboardMainLogoSection(),
                  const Spacer(),
                  Row(
                    children: [
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == AgentDashboardOption.dashboard,
                        iconData: Icons.dashboard,
                        optionLabel: 'Dashboard',
                        onTap: () {
                          // changeDashboardOption(
                          //   AgentDashboardOption.dashboard,
                          // );
                          context
                              .go('/agent-dashboard-screen/${widget.agentId}');
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == AgentDashboardOption.listings,
                        iconData: Icons.list,
                        optionLabel: 'Listings',
                        onTap: () {},
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == AgentDashboardOption.calendar,
                        iconData: Icons.calendar_month,
                        optionLabel: 'Onboarding Document',
                        onTap: () {
                          context.go(
                              '/agent-onboarding-document-screen/${widget.agentId}');
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == AgentDashboardOption.customer,
                        iconData: Icons.dashboard_customize_rounded,
                        optionLabel: 'Client',
                        onTap: () {
                          context.go(
                            '/agent-customer-property-allocation/${widget.agentId}',
                          );
                          // changeDashboardOption(
                          //   AgentDashboardOption.customer,
                          // );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  AgentUserInfoWidget(
                    agentData:
                        AgentDashboardScreenController.getSampleAgentModel(),
                    onProfilePress: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.86,
                    decoration: BoxDecoration(
                      color: ThemeController.pageBackgroundSecondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(15),
                      children: [
                        QuickActionWidget(
                          label: 'Add Property',
                          onPress: () {
                            changePropertyOption(
                                PropertyManagementOption.addProperty);
                          },
                          isSelected: propertyManagementOption ==
                              PropertyManagementOption.addProperty,
                          icons: Icons.home,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        QuickActionWidget(
                          label: 'List Properties',
                          onPress: () {
                            changePropertyOption(
                              PropertyManagementOption.listProperty,
                            );
                          },
                          isSelected: propertyManagementOption ==
                              PropertyManagementOption.listProperty,
                          icons: Icons.menu,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  // NOTE Empty Gap
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ThemeController.pageBackgroundSecondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: propertyManagementOption ==
                              PropertyManagementOption.addProperty
                          ? PropertyAdditionForm(
                              onSubmitPress: (formData) async {
                                ManagerLogInScreenController.showLoaderDialog(
                                    context);
                                await ApiController.sendPropertyAdditionRequest(
                                  formData,
                                  onSuccess: (data) {
                                    ManagerLogInScreenController.showSuccess(
                                        context, 'Property has been added !!!');
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      html.window.location.reload();
                                    });
                                  },
                                  onError: (data) {},
                                );
                              },
                              propertyId: "PPT-BLR-20250625-0001",
                              initialValue: null,
                              agentId: widget.agentId,
                              // agentId: '',
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "All properties",
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: List.generate(
                                    allProperties.length,
                                    (index) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                            height: 280,
                                            child:
                                                ManagerPropertyUnitTileWidget(
                                              propertyInfo:
                                                  allProperties[index],
                                              onViewMorePress: () {
                                                context.go(
                                                  '/agent-property-info-screen/${widget.agentId}/${allProperties[index]['propertyId']}',
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
