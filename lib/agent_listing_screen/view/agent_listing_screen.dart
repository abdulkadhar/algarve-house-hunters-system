import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/controller/agent_listing_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_unit_tile_widget.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AgentListingScreen extends StatefulWidget {
  const AgentListingScreen({super.key});

  @override
  State<AgentListingScreen> createState() => _AgentListingScreenState();
}

class _AgentListingScreenState extends State<AgentListingScreen> {
  AgentDashboardOption dashboardOption = AgentDashboardOption.listings;
  CustomerDataModel selectedUserData =
      AgentDashboardScreenController.getSampleAssignedUserModel().first;

  void changeDashboardOption(AgentDashboardOption option) {
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
                          changeDashboardOption(
                            AgentDashboardOption.dashboard,
                          );
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
                          changeDashboardOption(
                            AgentDashboardOption.listings,
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == AgentDashboardOption.calendar,
                        iconData: Icons.calendar_month,
                        optionLabel: 'Calendar',
                        onTap: () {
                          changeDashboardOption(
                            AgentDashboardOption.calendar,
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
                        optionLabel: 'Customer',
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
              Align(
                alignment: Alignment.centerRight,
                child: AddMoreButton(
                  buttonLabel: 'Add new listing',
                  onButtonPress: () {},
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeController.pageBackgroundSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Currently Listed Properties",
                      style: ThemeController.titleTextStyle(size: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            // PRoperty Title
                            List.generate(
                          AgentListingScreenController
                                  .getSampleRecentlyAddedPropertyList()
                              .length,
                          (index) => PropertyUnitTileWidget(
                            propertyData: AgentListingScreenController
                                .getSampleRecentlyAddedPropertyList()[index],
                            onViewMorePress: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeController.pageBackgroundSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Most Liked Properties",
                      style: ThemeController.titleTextStyle(size: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            // PRoperty Title
                            List.generate(
                          AgentListingScreenController
                                  .getSampleRecentlyAddedPropertyList()
                              .length,
                          (index) => PropertyUnitTileWidget(
                            propertyData: AgentListingScreenController
                                .getSampleRecentlyAddedPropertyList()[index],
                            onViewMorePress: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeController.pageBackgroundSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Listings",
                      style: ThemeController.titleTextStyle(size: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            // PRoperty Title
                            List.generate(
                          AgentListingScreenController
                                  .getSampleRecentlyAddedPropertyList()
                              .length,
                          (index) => PropertyUnitTileWidget(
                            propertyData: AgentListingScreenController
                                .getSampleMyPropertyList()[index],
                            onViewMorePress: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
