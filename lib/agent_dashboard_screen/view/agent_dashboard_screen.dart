import 'dart:convert';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_info_section.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/manager_gallery_widget.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/break_points.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_action_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_bottom_nav_bar.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/mobile_client_tile_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/property_overview_section.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AgentDashboardScreen extends StatefulWidget {
  final String agentId;
  const AgentDashboardScreen({
    super.key,
    this.agentId = '',
  });

  @override
  State<AgentDashboardScreen> createState() => _AgentDashboardScreenState();
}

class _AgentDashboardScreenState extends State<AgentDashboardScreen> {
  AgentDashboardOption dashboardOption = AgentDashboardOption.dashboard;

  void changeDashboardOption(AgentDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  List<dynamic>? assignedClients;
  Map<String, dynamic>? agentInfo;
  Map<String, dynamic>? selectedUser;
  Map<String, dynamic>? latestPropertyData;

  void getLatestPropertyData() async {
    await ApiController.getLatestPropertyData(
      onSuccess: (data) {
        latestPropertyData = jsonDecode(data);
        setState(() {});
      },
      onError: (data) {},
    );
  }

  void getAssignedClients() async {
    await ApiController.assignedClients(
      widget.agentId,
      onSuccess: (data) {
        assignedClients = jsonDecode(data);
        if (assignedClients != null && assignedClients!.isNotEmpty) {
          selectedUser = assignedClients![0];
        }

        setState(() {});
      },
      onError: (data) {},
    );
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

  @override
  void initState() {
    super.initState();
    getAssignedClients();
    getAgentProfileData();
    getLatestPropertyData();
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

  // NOTE Shared empty/info state used by the mobile assigned-clients section.
  Widget _buildClientsPlaceholder(IconData icon, String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: ThemeController.normalTextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  // NOTE Mobile assigned-clients section — same states as the web column.
  Widget _buildMobileAssignedClients() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Assigned Clients',
              style: ThemeController.titleTextStyle(),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                context.go('/agent-add-user-screen/${widget.agentId}');
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Add',
                    style: ThemeController.normalTextStyle(
                      fontWeight: FontWeight.w800,
                      size: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.add,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (agentInfo == null)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          )
        else if (agentInfo!['agent_status'] == 'profile-created')
          _buildClientsPlaceholder(
            Icons.document_scanner,
            'Complete the onboarding process',
          )
        else if (assignedClients != null && assignedClients!.isNotEmpty)
          Column(
            children: List.generate(
              assignedClients!.length,
              (index) {
                final client = assignedClients![index];
                return MobileClientTileWidget(
                  userData: client,
                  onProfilePress: () {
                    context.go(
                        '/agent-client-info-screen/${client['client_id']}/${widget.agentId}');
                  },
                );
              },
            ),
          )
        else
          _buildClientsPlaceholder(
            Icons.dangerous,
            'No client has been assigned yet',
          ),
      ],
    );
  }

  // NOTE Mobile View — stacked banner + property overview + clients.
  Widget _buildMobileView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMobileHeader(),
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
          // NOTE Assigned Clients Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildMobileAssignedClients(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.pageBackgroundColor,
      bottomNavigationBar:
          MediaQuery.of(context).size.width < Breakpoints.mobile
              ? AgentBottomNavBar(
                  currentOption: AgentDashboardOption.dashboard,
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
                            if (agentInfo != null &&
                                agentInfo!['agent_status'] ==
                                    'profile-created') {
                              ManagerLogInScreenController.showError(context,
                                  'Please do complete the on boarding process in order to proceed to client section !!!');
                            } else if (assignedClients == null ||
                                assignedClients!.isEmpty) {
                              ManagerLogInScreenController.showError(context,
                                  'No client has been assigned. Please do contact manager !!!');
                            } else {
                              context.go(
                                  '/agent-listing-screen/${widget.agentId}');
                            }
                            // context.go('/agent-listing-screen');
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        DashboardOptionSelector(
                          isEnabled:
                              dashboardOption == AgentDashboardOption.calendar,
                          iconData: Icons.document_scanner,
                          optionLabel: 'Onboarding Document',
                          onTap: () {
                            context.go(
                                '/agent-onboarding-document-screen/${agentInfo!['agent_id']}');
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
                            if (agentInfo != null &&
                                agentInfo!['agent_status'] ==
                                    'profile-created') {
                              ManagerLogInScreenController.showError(context,
                                  'Please do complete the on boarding process in order to proceed to client section !!!');
                            } else if (assignedClients == null ||
                                assignedClients!.isEmpty) {
                              ManagerLogInScreenController.showError(context,
                                  'No client has been assigned. Please do contact manager !!!');
                            } else {
                              context.go(
                                '/agent-customer-property-allocation/${widget.agentId}',
                              );
                            }

                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (ctx) =>
                            //             const AgentCustomerPropertyAllocationScreen()));
                            // context.go( '/agent-customer-property-allocation');
                            // changeDashboardOption(
                            //   AgentDashboardOption.customer,
                            // );
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    AgentUserInfoWidget(
                      agentId: widget.agentId,
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
                          InkWell(
                            onTap: () {
                              context.go(
                                  '/agent-add-user-screen/${widget.agentId}');
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Add new client',
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.add,
                                  color: Colors.black,
                                  size: 18,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Assigned Clients',
                            style: ThemeController.normalTextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (agentInfo != null)
                            agentInfo!['agent_status'] == 'profile-created'
                                ? Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                      ),
                                      Icon(
                                        Icons.document_scanner,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Complete the onboarding process',
                                        style: ThemeController.normalTextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  )
                                : assignedClients != null &&
                                        assignedClients!.isNotEmpty
                                    ? Column(
                                        children: List.generate(
                                          assignedClients!.length,
                                          (index) => ClientQuickActionWidget(
                                            userData: assignedClients![index],
                                            isSelected: assignedClients![index]
                                                    ["client_id"] ==
                                                selectedUser!["client_id"],
                                            onProfilePress: () {
                                              selectedUser =
                                                  assignedClients![index];
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      )
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.3,
                                          ),
                                          Icon(
                                            Icons.dangerous,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'No client has been assigned yet',
                                            style:
                                                ThemeController.normalTextStyle(
                                              fontWeight: FontWeight.w900,
                                            ),
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
                    // NOTE Client Info Section
                    if (selectedUser != null)
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Column(
                          children: [
                            // NOTE Agent Info
                            ClientInfoSection(
                              clientData: selectedUser!,
                              onProfilePress: () {
                                print('OnProfile press is done !!!!');
                                context.go(
                                    '/agent-customer-property-allocation/${agentInfo!['agent_id']}');
                              },
                            ),
                            const SizedBox(
                              height: 25,
                            ),

                            AgentActionWidget(
                              actionName: 'Amount Pref',
                              iconData: Icons.account_balance,
                              actionValue: selectedUser!["preference_data"]
                                      ["valueSpendPreference"]
                                  .toString(),
                              onActionPress: () {},
                            ),
                            AgentActionWidget(
                              actionName: 'Email',
                              iconData: Icons.mail,
                              actionValue:
                                  selectedUser!["client_email_address"],
                              onActionPress: () {},
                            ),
                            AgentActionWidget(
                              actionName: 'Phone',
                              iconData: Icons.phone,
                              actionValue: selectedUser!["client_phone_number"],
                              onActionPress: () {},
                            ),
                            AgentActionWidget(
                              actionName: 'Agent status',
                              iconData: Icons.support_agent,
                              actionValue: selectedUser!["preference_data"]
                                      ["otherAgentsStatus"]
                                  .toString(),
                              onActionPress: () {},
                            ),
                            AgentActionWidget(
                              actionName: 'Bank Status',
                              iconData: Icons.account_balance_wallet,
                              actionValue: selectedUser!["preference_data"]
                                      ["bankStatus"]
                                  .toString(),
                              onActionPress: () {},
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.48,
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
                                          (latestPropertyData!["propertyImages"]
                                                  as List)
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
                                    imagePaths: latestPropertyData![
                                                "propertyImages"]
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
                                        : latestPropertyData!["propertyImages"],
                                    width: (MediaQuery.of(context).size.width *
                                            0.5) *
                                        0.67,
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
      }),
    );
  }
}
