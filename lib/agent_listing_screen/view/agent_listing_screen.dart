import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_document_screen/view/agent_document_screen.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/break_points.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_bottom_nav_bar.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/mobile_property_tile_widget.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // NOTE State for internal page option
  PropertyManagementOption propertyManagementOption =
      PropertyManagementOption.addProperty;

  // NOTE over all dashboard option
  AgentDashboardOption dashboardOption = AgentDashboardOption.listings;

  // NOTE State for properties
  List<Map<String, dynamic>> allProperties = [];

  // NOTE Agent data used by the mobile header + bottom nav guards.
  Map<String, dynamic>? agentInfo;
  List<dynamic>? assignedClients;

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

  void getAgentProfileData() async {
    await ApiController.getAgentInfoById(
      widget.agentId,
      onError: (data) {},
      onSuccess: (data) {
        agentInfo = jsonDecode(data);
        setState(() {});
      },
    );
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
    super.initState();
    getAllProperties();
    getAgentProfileData();
    getAssignedClients();
  }

  // NOTE Builds the avatar initials from the agent's name (first + last).
  String _agentInitials() {
    final String name = (agentInfo?['agent_name'] ?? '').toString();
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  // NOTE Mobile header banner — compact: logo, title, initials avatar, logout.
  Widget _buildMobileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
          Image.asset(
            AssetsController.mainLogoPath,
            height: 40,
            width: 40,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Algarve House Hunters",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ThemeController.normalTextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: Text(
              _agentInitials(),
              style: ThemeController.normalTextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                size: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () {
              context.replace('/agent-login-screen');
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                  size: 22,
                ),
                Text(
                  'Logout',
                  style: ThemeController.smallTextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w900,
                    size: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // NOTE Add Property form — agent API kept unchanged.
  Widget _buildAddPropertyForm() {
    return PropertyAdditionForm(
      onSubmitPress: (formData) async {
        ManagerLogInScreenController.showLoaderDialog(context);
        await ApiController.sendPropertyAdditionRequest(
          formData,
          onSuccess: (data) {
            ManagerLogInScreenController.showSuccess(
                context, 'Property has been added !!!');
            Future.delayed(const Duration(seconds: 2), () {
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
    );
  }

  // NOTE Mobile "List Properties" — same layout/components as the manager
  // (MobilePropertyTileWidget). Agent route/API kept unchanged.
  Widget _buildMobileListProperties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Properties',
          style: ThemeController.titleTextStyle(),
        ),
        const SizedBox(height: 16),
        if (allProperties.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          )
        else
          Column(
            children: List.generate(
              allProperties.length,
              (index) {
                final property = allProperties[index];
                final bool hasImages =
                    (property["propertyImages"] as List?)?.isNotEmpty ?? false;
                return MobilePropertyTileWidget(
                  propertyInfo: property,
                  onViewDetailsPress: () {
                    context.go(
                      '/agent-property-info-screen/${widget.agentId}/${property['propertyId']}',
                    );
                  },
                  onImagePress: hasImages
                      ? () {
                          final List<String> urls =
                              (property["propertyImages"] as List)
                                  .cast<String>();
                          GlobalWidgets.showImageViewerDialog(
                            context,
                            imageUrls: urls,
                            title: "Property glance",
                          );
                        }
                      : null,
                );
              },
            ),
          ),
      ],
    );
  }

  // NOTE Left navigation drawer — in-page options (same as the manager).
  Widget _drawerTile({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.grey.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(width: 16),
            Text(
              label,
              style: ThemeController.normalTextStyle(
                fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMobileDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                children: [
                  _drawerTile(
                    icon: Icons.home,
                    label: 'Add Property',
                    selected: propertyManagementOption ==
                        PropertyManagementOption.addProperty,
                    onTap: () {
                      changePropertyOption(
                          PropertyManagementOption.addProperty);
                      Navigator.pop(context);
                    },
                  ),
                  _drawerTile(
                    icon: Icons.menu,
                    label: 'List Properties',
                    selected: propertyManagementOption ==
                        PropertyManagementOption.listProperty,
                    onTap: () {
                      changePropertyOption(
                          PropertyManagementOption.listProperty);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NOTE Mobile View — stacked banner + toggle + management content.
  Widget _buildMobileView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMobileHeader(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: propertyManagementOption ==
                    PropertyManagementOption.listProperty
                ? _buildMobileListProperties()
                : _buildAddPropertyForm(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeController.pageBackgroundColor,
      drawer: getMobileDrawer(),
      bottomNavigationBar:
          MediaQuery.of(context).size.width < Breakpoints.mobile
              ? AgentBottomNavBar(
                  currentOption: AgentDashboardOption.listings,
                  agentId: widget.agentId,
                  agentInfo: agentInfo,
                  assignedClients: assignedClients,
                )
              : null,
      body: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        // NOTE Mobile View
        if (width < Breakpoints.mobile) {
          return _buildMobileView();
        }
        // NOTE Tablet View
        else if (width < Breakpoints.tablet) {
          return Container();
        }
        // NOTE Web View
        return SingleChildScrollView(
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
                            context.go(
                                '/agent-dashboard-screen/${widget.agentId}');
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
                                  await ApiController
                                      .sendPropertyAdditionRequest(
                                    formData,
                                    onSuccess: (data) {
                                      ManagerLogInScreenController.showSuccess(
                                          context,
                                          'Property has been added !!!');
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
        );
      }),
    );
  }
}
