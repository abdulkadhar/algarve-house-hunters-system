import 'dart:convert';

import 'package:algarve_house_hunters_system/api_controller.dart';

import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/property_addition_form.dart';
import 'package:algarve_house_hunters_system/global_widgets/property_features_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/controller/manager_property_management_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/quick_action_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManagerPropertyInfoScreen extends StatefulWidget {
  final String propertyId;
  final String managerId;
  const ManagerPropertyInfoScreen({
    super.key,
    required this.propertyId,
    required this.managerId,
  });

  @override
  State<ManagerPropertyInfoScreen> createState() =>
      _ManagerPropertyInfoScreenState();
}

class _ManagerPropertyInfoScreenState extends State<ManagerPropertyInfoScreen> {
  // NOTE Property State Management
  Map<String, dynamic>? propertyInfoData;
  PropertyManagementOption propertyManagementOption =
      PropertyManagementOption.listProperty;
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.listings;
  void changeDashboardOption(ManagerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  void changePropertyOption(PropertyManagementOption option) {
    propertyManagementOption = option;
    setState(() {});
  }

  // void setPropertyInfoData() {
  //   propertyInfoData =
  //       ManagerPropertyManagementScreenController.unitPropertyInfo;
  //   setState(() {});
  // }

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

  @override
  void initState() {
    super.initState();
    setPropertyInfoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                            dashboardOption == ManagerDashboardOption.dashboard,
                        iconData: Icons.dashboard,
                        optionLabel: 'Dashboard',
                        onTap: () {
                          context.go(
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
                          context.go('/manager-property-management-screen');
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
                          context.go(
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
                          context.go(
                              '/manager-client-info-screen/CLT-BLR-20221117-0001/basicInfo');
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
                          : propertyInfoData != null
                              ? PropertyFeaturesInfoWidget(
                                  propertyInfoData: propertyInfoData!,
                                  agentId: widget.managerId,
                                )
                              : SizedBox.shrink(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
