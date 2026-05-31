import 'dart:convert';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/agent_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/manager_gallery_widget.dart';

import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/break_points.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/global_widgets/manager_bottom_nav_bar.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/mobile_agent_tile_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/mobile_client_tile_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/oldest_newest_filter.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/property_overview_section.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum ClientTypeOption {
  unAssigned,
  assigned,
}

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  ClientTypeOption clientTypeOption = ClientTypeOption.unAssigned;
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.dashboard;
  List<dynamic>? clientData;
  List<dynamic>? unAssignedClients;
  List<dynamic>? agentData;
  Map<String, dynamic>? latestPropertyData;

  List<dynamic> unassignedClientSearchResult = [];
  List<dynamic> assignedClientSearchResult = [];

  String unassignedQuery = '';
  String assignedQuery = '';

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
      onError: (data) {
        ManagerLogInScreenController.showError(
            context, "Error fetching latest property data !!!!");
      },
    );
  }

  void getAgentData() async {
    await ApiController.getAllAgentData(
      onSuccess: (responseData) {
        agentData = jsonDecode(responseData) as List<dynamic>;
        setState(() {});
      },
      onError: (errorData) {
        ManagerLogInScreenController.showError(
            context, "Error fetching agent data !!!!");
        // print("Agent Data: Error has occured !!!");
      },
    );
  }

  void getUnAssignedClientsData() async {
    await ApiController.getUnAssignedClientsData(
      onSuccess: (responseData) {
        unAssignedClients = jsonDecode(responseData) as List<dynamic>;
        unAssignedClients = unAssignedClients!.reversed.toList();
        setState(() {});
      },
      onError: (errorData) {
        ManagerLogInScreenController.showError(
            context, "Error fetching un assigned data !!!!");
        print("Error has occured !!!");
      },
    );
  }

  void getClientData() async {
    await ApiController.getAllClientsData(
      onSuccess: (responseData) {
        clientData = jsonDecode(responseData) as List<dynamic>;
        clientData = clientData!.reversed.toList();
        setState(() {});
        print('Data has been loaded');
      },
      onError: (errorData) {
        ManagerLogInScreenController.showError(
            context, "Error fetching client data !!!!");
        print("Error has occured !!!");
      },
    );
  }

  void setClientOptionType(ClientTypeOption option) {
    clientTypeOption = option;
    setState(() {});
  }

  Widget getClientOptionSelectorWidget() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (clientTypeOption != ClientTypeOption.unAssigned)
            InkWell(
              onTap: () {
                setClientOptionType(ClientTypeOption.unAssigned);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Unassigned Clients",
                  style: ThemeController.normalTextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w800,
                    size: 12,
                  ),
                ),
              ),
            ),
          if (clientTypeOption == ClientTypeOption.unAssigned)
            InkWell(
              onTap: () {
                setClientOptionType(ClientTypeOption.unAssigned);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Unassigned Clients",
                  style: ThemeController.normalTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    size: 12,
                  ),
                ),
              ),
            ),
          if (clientTypeOption == ClientTypeOption.assigned)
            InkWell(
              onTap: () {
                setClientOptionType(ClientTypeOption.assigned);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Assigned Clients",
                  style: ThemeController.normalTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    size: 12,
                  ),
                ),
              ),
            ),
          if (clientTypeOption != ClientTypeOption.assigned)
            InkWell(
              onTap: () {
                setClientOptionType(ClientTypeOption.assigned);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Assigned Clients",
                  style: ThemeController.normalTextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w800,
                    size: 12,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  List<dynamic> searchClients(List<dynamic> clients, String query) {
    if (query.isEmpty) return clients;

    final lowerQuery = query.toLowerCase();

    return clients.where((client) {
      if (client is Map<String, dynamic>) {
        final name = (client['client_name'] ?? '').toString().toLowerCase();
        final email =
            (client['client_email_address'] ?? '').toString().toLowerCase();
        return name.contains(lowerQuery) || email.contains(lowerQuery);
      }
      return false;
    }).toList();
  }

  // NOTE Mobile clients section — simple list of the latest clients.
  Widget getMobileClientsSection() {
    // Show the latest 10 clients (clientData is already newest-first).
    final List<dynamic> latestClients =
        (clientData ?? const []).take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Clients',
              style: ThemeController.titleTextStyle(),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                if (clientData != null && clientData!.isNotEmpty) {
                  context.go(
                      '/manager-client-info-screen/${clientData!.first['client_id']}/basicInfo');
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: ThemeController.normalTextStyle(
                      fontWeight: FontWeight.w800,
                      size: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (clientData == null)
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
              latestClients.length,
              (index) {
                final client = latestClients[index];
                return MobileClientTileWidget(
                  userData: client,
                  onProfilePress: () {
                    context.go(
                        '/manager-client-info-screen/${client['client_id']}/basicInfo');
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  // NOTE Mobile agents section — simple list of the latest agents.
  Widget getMobileAgentsSection() {
    // Show the latest 10 agents.
    final List<dynamic> latestAgents =
        (agentData ?? const []).take(10).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Agents',
              style: ThemeController.titleTextStyle(),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                context.go('/manager-agent-info-section-screen');
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'View All',
                    style: ThemeController.normalTextStyle(
                      fontWeight: FontWeight.w800,
                      size: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (agentData == null)
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
              latestAgents.length,
              (index) {
                final agent = latestAgents[index];
                return MobileAgentTileWidget(
                  userData: agent,
                  onProfilePress: () {
                    context.go(
                        '/manager-agent-info-section-screens/${agent['agent_id']}');
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    getClientData();
    getAgentData();
    getLatestPropertyData();
    getUnAssignedClientsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.pageBackgroundColor,
      bottomNavigationBar:
          MediaQuery.of(context).size.width < Breakpoints.mobile
              ? const ManagerBottomNavBar(
                  currentOption: ManagerDashboardOption.dashboard,
                )
              : null,
      body: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        // NOTE Mobile View
        if (width < Breakpoints.mobile) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // NOTE Mobile Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AssetsController.mainLogoPath,
                        height: 48,
                        width: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Algarve House Hunters",
                          style: ThemeController.normalTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ManagerInfoWidget(
                        onProfilePress: () {},
                        managerId: 'MNG-BLR-20250625-0001',
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // NOTE Property Overview Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: latestPropertyData == null
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(40),
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          ),
                        )
                      : PropertyOverviewSection(
                          propertyData: latestPropertyData!,
                        ),
                ),
                const SizedBox(height: 30),
                // NOTE Clients Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: getMobileClientsSection(),
                ),
                const SizedBox(height: 30),
                // NOTE Agents Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: getMobileAgentsSection(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
        // NOTE Tablet View
        else if (width < Breakpoints.tablet) {
          return Container();
        }
        // NOTE Web View
        else {
          return SingleChildScrollView(
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
                            isEnabled: dashboardOption ==
                                ManagerDashboardOption.dashboard,
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
                            isEnabled: dashboardOption ==
                                ManagerDashboardOption.listings,
                            iconData: Icons.list,
                            optionLabel: 'Listings',
                            onTap: () {
                              changeDashboardOption(
                                ManagerDashboardOption.listings,
                              );
                              // NOTE addition of route for the listing screen
                              context.go('/manager-property-management-screen');
                            },
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          DashboardOptionSelector(
                            isEnabled: dashboardOption ==
                                ManagerDashboardOption.agents,
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
                            isEnabled: dashboardOption ==
                                ManagerDashboardOption.clients,
                            iconData: Icons.dashboard_customize_rounded,
                            optionLabel: 'Clients',
                            onTap: () {
                              if (clientData != null &&
                                  clientData!.isNotEmpty) {
                                context.go(
                                    '/manager-client-info-screen/CLT-BLR-20221117-0001/basicInfo');
                              }
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
                                  onTap: () {
                                    context.go(
                                      '/manager-add-client-screen',
                                    );
                                  },
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
                            if (unAssignedClients != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  getClientOptionSelectorWidget(),
                                  // NOTE List of unassigned client
                                  if (clientTypeOption ==
                                      ClientTypeOption.unAssigned)
                                    Column(
                                      children: [
                                        CustomTextFormFiled(
                                          isMandatory: false,
                                          labelName: '',
                                          placeholderText: 'Search',
                                          onChanged: (data) {
                                            unassignedQuery = data;
                                            unassignedClientSearchResult = [];
                                            setState(() {});
                                            unassignedClientSearchResult =
                                                searchClients(
                                              unAssignedClients!,
                                              unassignedQuery,
                                            );
                                            setState(() {});
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        if (unassignedQuery.isEmpty)
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: OldestNewestFilter(
                                              getOptionData: (data) {
                                                unAssignedClients =
                                                    unAssignedClients!.reversed
                                                        .toList();

                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        if (unassignedQuery.isEmpty)
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        Column(
                                          children: List.generate(
                                            unassignedQuery.isEmpty
                                                ? unAssignedClients!.length
                                                : unassignedClientSearchResult
                                                    .length,
                                            (index) => ClientQuickActionWidget(
                                              userData: unassignedQuery.isEmpty
                                                  ? unAssignedClients![index]
                                                  : unassignedClientSearchResult[
                                                      index],
                                              isSelected: false,
                                              onProfilePress: () {
                                                String clientTemp = unassignedQuery
                                                        .isEmpty
                                                    ? unAssignedClients![index]
                                                        ['client_id']
                                                    : unassignedClientSearchResult[
                                                        index]['client_id'];
                                                print(clientTemp);
                                                context.go(
                                                    '/manager-client-info-screen/$clientTemp/basicInfo');
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  if (clientTypeOption ==
                                      ClientTypeOption.assigned)
                                    Column(
                                      children: [
                                        CustomTextFormFiled(
                                          isMandatory: false,
                                          labelName: '',
                                          placeholderText: 'Search',
                                          onChanged: (data) {
                                            assignedQuery = data;
                                            assignedClientSearchResult = [];
                                            setState(() {});
                                            assignedClientSearchResult =
                                                searchClients(
                                              clientData!,
                                              assignedQuery,
                                            );
                                            setState(() {});
                                          },
                                        ),
                                        if (assignedQuery.isEmpty)
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        if (assignedQuery.isEmpty)
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: OldestNewestFilter(
                                              getOptionData: (data) {
                                                clientData = clientData!
                                                    .reversed
                                                    .toList();

                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        if (assignedQuery.isEmpty)
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        Column(
                                          children: List.generate(
                                            assignedQuery.isEmpty
                                                ? clientData!.length
                                                : assignedClientSearchResult
                                                    .length,
                                            (index) => ClientQuickActionWidget(
                                              userData: assignedQuery.isEmpty
                                                  ? clientData![index]
                                                  : assignedClientSearchResult[
                                                      index],
                                              isSelected: false,
                                              onProfilePress: () {
                                                String clientIdTemp = assignedQuery
                                                        .isEmpty
                                                    ? clientData![index]
                                                        ['client_id']
                                                    : assignedClientSearchResult[
                                                        index]['client_id'];
                                                context.go(
                                                  '/manager-client-info-screen/$clientIdTemp/basicInfo',
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
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
                                    context.go(
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
                                    onProfilePress: () {
                                      context.go(
                                          '/manager-agent-info-section-screens/${agentData![index]['agent_id']}');
                                    },
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
                                      onPress: () {
                                        final List<String> urls =
                                            (latestPropertyData![
                                                    "propertyImages"] as List)
                                                .cast<String>();
                                        GlobalWidgets.showImageViewerDialog(
                                          context,
                                          imageUrls: urls.isEmpty
                                              ? [
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-00001694FC1B.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016359DAF.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A03.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A04.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A05.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A06.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A07.JPG",
                                                ]
                                              : urls,
                                          title: "Property glance",
                                        );
                                      },
                                      // imagePaths: CustomerDashboardScreenController
                                      //     .propertyImagePaths,
                                      imagePaths:
                                          latestPropertyData!["propertyImages"]
                                                  .isEmpty
                                              ? [
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-00001694FC1B.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016359DAF.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A03.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A04.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A05.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A06.JPG",
                                                  "https://images.egorealestate.com/Z640x480/OAYES/S5/C2585/P27440974/TPHOTO/ID4EB7A201-0000-0500-0000-000016945A07.JPG",
                                                ]
                                              : latestPropertyData![
                                                  "propertyImages"],
                                      width:
                                          (MediaQuery.of(context).size.width *
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
          );
        }
      }),
    );
  }
}
