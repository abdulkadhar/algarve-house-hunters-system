import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/controller/agent_controller_property_allocation_controller.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/option_label_selector_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/property_info_container.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/property_unit_info_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/controller/agent_listing_screen_controller.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AgentCustomerPropertyAllocationScreen extends StatefulWidget {
  const AgentCustomerPropertyAllocationScreen({super.key});

  @override
  State<AgentCustomerPropertyAllocationScreen> createState() =>
      _AgentCustomerPropertyAllocationScreenState();
}

class _AgentCustomerPropertyAllocationScreenState
    extends State<AgentCustomerPropertyAllocationScreen> {
  AgentDashboardOption dashboardOption = AgentDashboardOption.customer;
  CustomerDataModel selectedUserData =
      AgentDashboardScreenController.getSampleAssignedUserModel().first;

  void changeDashboardOption(AgentDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  PropertyAllocationOption optionsData =
      PropertyAllocationOption.assignProperty;

  void changePropertyAllocationOption(PropertyAllocationOption data) {
    optionsData = data;
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
                              isSelected: AgentDashboardScreenController
                                          .getSampleAssignedUserModel()[index]
                                      .basicData
                                      .userId ==
                                  selectedUserData.basicData.userId,
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
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ThemeController.pageBackgroundSecondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OptionLabelSelectorWidget(
                                isEnabled: optionsData ==
                                    PropertyAllocationOption.userPref,
                                onPress: () {
                                  changePropertyAllocationOption(
                                    PropertyAllocationOption.userPref,
                                  );
                                },
                                optionLabel: 'User Preferences',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionsData ==
                                    PropertyAllocationOption.assignProperty,
                                onPress: () {
                                  changePropertyAllocationOption(
                                    PropertyAllocationOption.assignProperty,
                                  );
                                },
                                optionLabel: 'Assign Property',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionsData ==
                                    PropertyAllocationOption.checklist,
                                onPress: () {
                                  changePropertyAllocationOption(
                                    PropertyAllocationOption.checklist,
                                  );
                                },
                                optionLabel: 'Check List',
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (optionsData == PropertyAllocationOption.userPref)
                            UserPreferenceWidget(
                              customerData: selectedUserData,
                            ),
                          if (optionsData ==
                              PropertyAllocationOption.assignProperty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assigned Property',
                                  style: ThemeController.smallTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        AgentControllerPropertyAllocationController
                                                .getSampleSelectedPropertyList()
                                            .length,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4, // 2 columns
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemBuilder: (context, index) {
                                      return PropertyUnitInfoWidget(
                                        propertyData:
                                            AgentControllerPropertyAllocationController
                                                    .getSampleSelectedPropertyList()[
                                                index],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Listed Property',
                                style: ThemeController.smallTextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  itemCount: AgentListingScreenController
                                          .getSampleMyPropertyList()
                                      .length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4, // 2 columns
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.85,
                                  ),
                                  itemBuilder: (context, index) {
                                    return PropertyUnitInfoWidget(
                                      propertyData:
                                          AgentControllerPropertyAllocationController
                                                  .getSampleSelectedPropertyList()[
                                              index],
                                      isAssignButton: true,
                                    );
                                  },
                                ),
                              ),
                            ],
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
