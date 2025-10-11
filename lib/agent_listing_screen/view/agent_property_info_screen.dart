import 'dart:convert';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_document_screen/view/agent_document_screen.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/client_assign_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/property_addition_form.dart';
import 'package:algarve_house_hunters_system/global_widgets/property_features_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/controller/manager_property_management_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/quick_action_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

class AgentPropertyInfoScreen extends StatefulWidget {
  final String agentId;
  final String propertyId;
  const AgentPropertyInfoScreen({
    super.key,
    required this.propertyId,
    required this.agentId,
  });

  @override
  State<AgentPropertyInfoScreen> createState() =>
      _AgentPropertyInfoScreenState();
}

class _AgentPropertyInfoScreenState extends State<AgentPropertyInfoScreen> {
  List<dynamic>? assignedClients;
  // NOTE State for holding property info data
  Map<String, dynamic> propertyInfoData = {};
  // NOTE State for internal page option
  PropertyManagementOption propertyManagementOption =
      PropertyManagementOption.listProperty;

  // NOTE over all dashboard option
  AgentDashboardOption dashboardOption = AgentDashboardOption.listings;

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

  // NOTE Method - Property Info Get
  void setPropertyInfoData() async {
    await ApiController.getAgentPropertyInfo(
      widget.propertyId,
      onSuccess: (successData) {
        final propertyData = jsonDecode(successData);
        propertyInfoData = propertyData;
      },
      onError: (errorData) {},
    );

    setState(() {});
  }

  void getAssignedClients() async {
    await ApiController.assignedClients(
      widget.agentId,
      onSuccess: (data) {
        assignedClients = jsonDecode(data);
        setState(() {});
      },
      onError: (data) {},
    );
  }

  @override
  void initState() {
    setPropertyInfoData();
    getAssignedClients();
    super.initState();
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
                        onTap: () {
                          context.go('/agent-listing-screen');
                        },
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => const AgentDocumentScreen(),
                            ),
                          );
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
                          changeDashboardOption(
                            AgentDashboardOption.customer,
                          );
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
                              onSubmitPress: (formData) {},
                              propertyId: "PPT-BLR-20250625-0001",
                              initialValue: null,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Assign to client",
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                if (assignedClients != null &&
                                    assignedClients!.isNotEmpty)
                                  Row(
                                      children: List.generate(
                                    assignedClients!.length,
                                    (index) => ClientAssignButton(
                                      clientName: assignedClients![index]
                                          ['client_name'],
                                      isSelected: List<String>.from(
                                        propertyInfoData['assignedTo'],
                                      ).contains(
                                        assignedClients![index]['client_id'],
                                      ),
                                      onPress: () async {
                                        await ApiController.assignProperty(
                                          propertyId: widget.propertyId,
                                          customerId: assignedClients![index]
                                              ['client_id'],
                                          onSuccess: (responseData) {},
                                          onError: (errorData) {},
                                        );
                                        html.window.location.reload();
                                      },
                                    ),
                                  )),
                                const SizedBox(
                                  height: 20,
                                ),
                                PropertyFeaturesInfoWidget(
                                  propertyInfoData: propertyInfoData,
                                  agentId: widget.agentId,
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
