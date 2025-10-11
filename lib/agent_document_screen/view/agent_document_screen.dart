import 'dart:convert';
import 'dart:html' as html;
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/toggle_switch_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_document_screen/widgets/file_content_tile.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/widgets/side_option_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AgentDocumentScreen extends StatefulWidget {
  final String agentId;
  const AgentDocumentScreen({
    super.key,
    this.agentId = '',
  });

  @override
  State<AgentDocumentScreen> createState() => _AgentDocumentScreenState();
}

class _AgentDocumentScreenState extends State<AgentDocumentScreen> {
  AgentDashboardOption dashboardOption = AgentDashboardOption.calendar;
  void changeDashboardOption(AgentDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  Map<String, dynamic>? filesData;

  void getAllFiles() async {
    await ApiController.getAllOnBoardingDocuments(
      onSuccess: (documentData) {
        final data = jsonDecode(documentData);
        filesData = data;
        setState(() {});
      },
      onError: (errorData) {
        print("Manager Documents Loading: Error ");
      },
    );
  }

  Map<String, dynamic>? agentInfo;

  List<dynamic>? assignedClients;
  void getAssignedClients() async {
    await ApiController.assignedClients(
      widget.agentId,
      onSuccess: (data) {
        assignedClients = jsonDecode(data);
        if (assignedClients != null && assignedClients!.isNotEmpty) {}

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
    getAllFiles();
    getAgentProfileData();
    getAssignedClients();
    super.initState();
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
                          context
                              .go('/agent-dashboard-screen/${widget.agentId}');
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
                        onTap: () {},
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
                          'Agent workspace',
                          style: ThemeController.normalTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SideOptionButton(
                          iconData: Icons.document_scanner,
                          isSelected: true,
                          label: "Training Document",
                          onTap: () {
                            // context.go(
                            //   '/manager-agent-onboarding-document-screen',
                            // );
                          },
                        )
                      ],
                    ),
                  ),
                  // NOTE Empty Space
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Expanded(
                    child: filesData != null && agentInfo != null
                        ? Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color:
                                  ThemeController.pageBackgroundSecondaryColor,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Available Documents",
                                      style: ThemeController.normalTextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Spacer(),
                                    ToggleSwitchWidget(
                                      isEnabled: agentInfo!['agent_status'] !=
                                          'on-boarded',
                                      onToggle: (data) async {
                                        if (agentInfo!['agent_status'] !=
                                            'on-boarded') {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .updateOnBoardStatus(
                                            widget.agentId,
                                            onSuccess: (data) async {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
                                              await Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  print(
                                                      "This runs after 2 seconds");
                                                  if (!mounted) {
                                                    return;
                                                  }
                                                  html.window.location.reload();
                                                },
                                              );
                                            },
                                            onError: (data) {
                                              ManagerLogInScreenController
                                                  .showError(context, data);
                                            },
                                          );
                                        }
                                      },
                                      isOn: agentInfo!['agent_status'] ==
                                          'on-boarded',
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                    children: List.generate(
                                  filesData!['documents-list'].length,
                                  (index) => Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      FileContentTile(
                                        fileName: filesData!['documents-list']
                                            [index]['document_title'],
                                        onDownloadPress: () async {
                                          await ApiController.downloadFileWeb(
                                              filesData!['documents-list']
                                                  [index]['document_title']);
                                          // await ApiController
                                          //     .trainingDocumentDownload(
                                          //   filesData!['documents-list'][index]
                                          //       ['document_title'],
                                          //   onSuccess: (data) {},
                                          //   onError: (data) {},
                                          // );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ))
                              ],
                            ),
                          )
                        : const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
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
