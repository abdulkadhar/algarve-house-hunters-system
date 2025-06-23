import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_info_section.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/action_container_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_action_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_info_container.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/gallery_grid_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_section.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_user_info_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/agent_info_sectIon.dart';
import 'package:flutter/material.dart';

class AgentDashboardScreen extends StatefulWidget {
  const AgentDashboardScreen({super.key});

  @override
  State<AgentDashboardScreen> createState() => _AgentDashboardScreenState();
}

class _AgentDashboardScreenState extends State<AgentDashboardScreen> {
  AgentDashboardOption dashboardOption = AgentDashboardOption.dashboard;
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
              // NOTE Dashboard Main Section
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
                        Text(
                          'Assigned Clients',
                          style: ThemeController.normalTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Column(
                          children: List.generate(
                            AgentDashboardScreenController
                                    .getSampleAssignedUserModel()
                                .length,
                            (index) => ClientQuickActionWidget(
                              userData: AgentDashboardScreenController
                                  .getSampleAssignedUserModel()[index],
                              onProfilePress: () {
                                selectedUserData =
                                    AgentDashboardScreenController
                                        .getSampleAssignedUserModel()[index];
                                setState(() {});
                              },
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
                  // NOTE Client Info Section
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Column(
                      children: [
                        // NOTE Agent Info
                        ClientInfoSection(
                          customerData: selectedUserData,
                        ),
                        const SizedBox(
                          height: 25,
                        ),

                        AgentActionWidget(
                          actionName: 'Amount Pref',
                          iconData: Icons.account_balance,
                          actionValue: selectedUserData
                              .preferenceData.valueSpendPreference
                              .toString(),
                          onActionPress: () {},
                        ),
                        AgentActionWidget(
                          actionName: 'Email',
                          iconData: Icons.mail,
                          actionValue: selectedUserData.preferenceData.email,
                          onActionPress: () {},
                        ),
                        AgentActionWidget(
                          actionName: 'Phone',
                          iconData: Icons.phone,
                          actionValue:
                              selectedUserData.preferenceData.phoneNumber,
                          onActionPress: () {},
                        ),
                        AgentActionWidget(
                          actionName: 'Agent status',
                          iconData: Icons.support_agent,
                          actionValue:
                              selectedUserData.preferenceData.otherAgentsStatus,
                          onActionPress: () {},
                        ),
                        AgentActionWidget(
                          actionName: 'Bank Status',
                          iconData: Icons.account_balance_wallet,
                          actionValue:
                              selectedUserData.preferenceData.bankStatus,
                          onActionPress: () {},
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.86,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GalleryGridWidget(
                            imagePaths: CustomerDashboardScreenController
                                .propertyImagePaths,
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
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
