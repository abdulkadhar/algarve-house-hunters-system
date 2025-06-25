import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/gallery_grid_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.dashboard;

  void changeDashboardOption(ManagerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
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
                          changeDashboardOption(
                            ManagerDashboardOption.dashboard,
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
                          changeDashboardOption(
                            ManagerDashboardOption.agents,
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
                  AgentUserInfoWidget(
                    agentData: ManagerDashboardScreenController
                        .getSampleManagerModel(),
                    onProfilePress: () {},
                  ),
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
                        Column(
                          children: List.generate(
                            AgentDashboardScreenController
                                    .getSampleAssignedUserModel()
                                .length,
                            (index) => ClientQuickActionWidget(
                              userData: AgentDashboardScreenController
                                  .getSampleAssignedUserModel()[index],
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
                              onTap: () {},
                              child: const Icon(
                                Icons.add,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: List.generate(
                            AgentDashboardScreenController
                                    .getSampleAssignedUserModel()
                                .length,
                            (index) => ClientQuickActionWidget(
                              userData: AgentDashboardScreenController
                                  .getSampleAssignedUserModel()[index],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GalleryGridWidget(
                            imagePaths: CustomerDashboardScreenController
                                .propertyImagePaths,
                            width: (MediaQuery.of(context).size.width * 0.5) *
                                0.79,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          PropertyInfoSection(
                            propertyData: CustomerDashboardScreenController
                                .getSamplePropertyData.first,
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
