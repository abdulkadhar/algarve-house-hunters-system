import 'dart:convert';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/agent_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/manager_gallery_widget.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/view/agent_onboarding_screen.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.dashboard;
  List<dynamic>? clientData;
  List<dynamic>? agentData;
  Map<String, dynamic>? latestPropertyData;

  void changeDashboardOption(ManagerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  void getLatestPropertyData() async {
    await ApiController.getLatestPropertyData(
      onSuccess: (data) {
        latestPropertyData = jsonDecode(data);
        setState(() {});
      },
      onError: (data) {},
    );
  }

  void getAgentData() async {
    await ApiController.getAllAgentData(
      onSuccess: (responseData) {
        agentData = jsonDecode(responseData) as List<dynamic>;
        setState(() {});
      },
      onError: (errorData) {
        print("Agent Data: Error has occured !!!");
      },
    );
  }

  void getClientData() async {
    await ApiController.getAllClientsData(
      onSuccess: (responseData) {
        clientData = jsonDecode(responseData) as List<dynamic>;
        setState(() {});
        print('Data has been loaded');
      },
      onError: (errorData) {
        print("Error has occured !!!");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getClientData();
    getAgentData();
    getLatestPropertyData();
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
              // NOTE Header
              Row(
                children: [
                  const DashboardMainLogoSection(),
                  const Spacer(),
                  Row(
                    children: [
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.dashboard,
                        iconData: Icons.dashboard,
                        optionLabel: 'Dashboard',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/manager-dashboard-screen',
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.listings,
                        iconData: Icons.list,
                        optionLabel: 'Listings',
                        onTap: () {
                          changeDashboardOption(
                            ManagerDashboardOption.listings,
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.agents,
                        iconData: Icons.support_agent,
                        optionLabel: 'Agents',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/manager-agent-info-section-screen',
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.clients,
                        iconData: Icons.dashboard_customize_rounded,
                        optionLabel: 'Clients',
                        onTap: () {
                          changeDashboardOption(
                            ManagerDashboardOption.clients,
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  ManagerInfoWidget(
                    onProfilePress: () {},
                    managerId: 'MNG-BLR-20250625-0001',
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NOTE Assigned Clients Section
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
                        Row(
                          children: [
                            Text(
                              'Clients',
                              style: ThemeController.normalTextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.add,
                              ),
                            )
                          ],
                        ),
                        if (clientData == null)
                          const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        if (clientData != null)
                          Column(
                            children: List.generate(
                              clientData!.length,
                              (index) => ClientQuickActionWidget(
                                userData: clientData![index],
                                isSelected: false,
                                onProfilePress: () {},
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  // NOTE Empty Space
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  // NOTE Agents Sections
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
                        Row(
                          children: [
                            Text(
                              'Agents',
                              style: ThemeController.normalTextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/manager-agent-onboarding',
                                );
                              },
                              child: const Icon(
                                Icons.add,
                              ),
                            )
                          ],
                        ),
                        if (agentData == null)
                          const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        if (agentData != null)
                          Column(
                            children: List.generate(
                              agentData!.length,
                              (index) => AgentQuickActionWidget(
                                userData: agentData![index],
                                isSelected: false,
                                onProfilePress: () {},
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.54,
                    height: MediaQuery.of(context).size.height * 0.86,
                    child: SingleChildScrollView(
                      child: latestPropertyData == null
                          ? const Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ManagerGalleryWidget(
                                  // imagePaths: CustomerDashboardScreenController
                                  //     .propertyImagePaths,
                                  imagePaths:
                                      latestPropertyData!["propertyImages"],
                                  width: (MediaQuery.of(context).size.width *
                                          0.5) *
                                      0.79,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                PropertyInfoSection(
                                  // propertyData:
                                  //     CustomerDashboardScreenController
                                  //         .getSamplePropertyData.first,
                                  propertyData: latestPropertyData!,
                                )
                              ],
                            ),
                    ),
                  ),
                  // NOTE
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
