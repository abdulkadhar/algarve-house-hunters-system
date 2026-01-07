import 'dart:convert';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_info_section.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/manager_gallery_widget.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_action_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
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
                          if (agentInfo != null &&
                              agentInfo!['agent_status'] == 'profile-created') {
                            ManagerLogInScreenController.showError(context,
                                'Please do complete the on boarding process in order to proceed to client section !!!');
                          } else if (assignedClients == null ||
                              assignedClients!.isEmpty) {
                            ManagerLogInScreenController.showError(context,
                                'No client has been assigned. Please do contact manager !!!');
                          } else {
                            context
                                .go('/agent-listing-screen/${widget.agentId}');
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
                              agentInfo!['agent_status'] == 'profile-created') {
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
                            context
                                .go('/agent-add-user-screen/${widget.agentId}');
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
                            actionValue: selectedUser!["client_email_address"],
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
                                      imageUrls: urls,
                                      title: "Property glance",
                                    );
                                  },
                                  // imagePaths: CustomerDashboardScreenController
                                  //     .propertyImagePaths,
                                  imagePaths:
                                      latestPropertyData!["propertyImages"],
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
      ),
    );
  }
}
