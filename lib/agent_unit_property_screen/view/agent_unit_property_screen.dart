import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/controller/agent_controller_property_allocation_controller.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_unit_property_screen/widgets/assigned_user_info_widget.dart';
import 'package:algarve_house_hunters_system/agent_unit_property_screen/widgets/customer_info_section.dart';
import 'package:algarve_house_hunters_system/agent_unit_property_screen/widgets/upcoming_home_tour_request_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_feature_card.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/property_slider_widget.dart';
import 'package:flutter/material.dart';

class AgentUnitPropertyScreen extends StatefulWidget {
  const AgentUnitPropertyScreen({super.key});

  @override
  State<AgentUnitPropertyScreen> createState() =>
      _AgentUnitPropertyScreenState();
}

class _AgentUnitPropertyScreenState extends State<AgentUnitPropertyScreen> {
  AgentDashboardOption dashboardOption = AgentDashboardOption.listings;
  CustomerDataModel selectedUserData =
      AgentDashboardScreenController.getSampleAssignedUserModel().first;

  void changeDashboardOption(AgentDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  AssignmentStatus propertyStatus = AssignmentStatus.assign;

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
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeController.pageBackgroundSecondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PropertySliderWidget(
                          imagePaths: CustomerDashboardScreenController
                              .getSamplePropertyData.first.propertyImages,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // NOTE property name
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Property Name",
                                    style: ThemeController.normalTextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "200 Million",
                                    style: ThemeController.titleTextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.blue,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Sample location",
                                    style: ThemeController.normalTextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "sample description",
                                style: ThemeController.smallTextStyle(),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Row(
                                children: [
                                  const PropertyFeatureCard(
                                    bgColor: Colors.white,
                                    featureName: 'Beds',
                                    featureValue: '3',
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const PropertyFeatureCard(
                                    bgColor: Colors.white,
                                    featureName: 'Baths',
                                    featureValue: '3',
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const PropertyFeatureCard(
                                    bgColor: Colors.white,
                                    featureName: 'Coastal distance',
                                    featureValue: '30 mins',
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const PropertyFeatureCard(
                                    bgColor: Colors.white,
                                    featureName: 'Sq.ft',
                                    featureValue: '600 Sq.ft',
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Assigned Users",
                                style: ThemeController.normalTextStyle(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: List.generate(
                                    3,
                                    (index) => Column(
                                          children: [
                                            AssignedUserInfoWidget(
                                              indexNumber: index + 1,
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            )
                                          ],
                                        )),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NOTE Agent Info
                        // AgentInfoSection(
                        //   agentData: CustomerDashboardScreenController
                        //       .getSampleAgentModel(),
                        // ),
                        CustomerInfoSection(
                          assignmentStatus: propertyStatus,
                          onPress: () {
                            if (propertyStatus == AssignmentStatus.assign) {
                              propertyStatus = AssignmentStatus.unassign;
                            } else {
                              propertyStatus = AssignmentStatus.assign;
                            }
                            setState(() {});
                          },
                          customerData:
                              AgentControllerPropertyAllocationController
                                      .getSampleAssignedUserModel()
                                  .first,
                        ),
                        const SizedBox(height: 10),
                        UpcomingHomeTourRequestWidget(
                          requestData: CustomerDashboardScreenController
                              .getSampleHomeTourRequestModel(),
                        )
                      ],
                    ),
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
