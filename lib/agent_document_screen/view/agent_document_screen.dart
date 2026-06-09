import 'dart:convert';
import 'dart:html' as html;
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/toggle_switch_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_document_screen/widgets/file_content_tile.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/widgets/side_option_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/break_points.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_bottom_nav_bar.dart';
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

  // NOTE Available documents section — shared by web + mobile.
  Widget _buildDocumentsSection() {
    return filesData != null && agentInfo != null
        ? Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ThemeController.pageBackgroundSecondaryColor,
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
                      isEnabled: agentInfo!['agent_status'] != 'on-boarded',
                      onToggle: (data) async {
                        if (agentInfo!['agent_status'] != 'on-boarded') {
                          ManagerLogInScreenController.showLoaderDialog(
                              context);
                          await ApiController.updateOnBoardStatus(
                            widget.agentId,
                            onSuccess: (data) async {
                              ManagerLogInScreenController.showSuccess(
                                  context, 'Status has been updated !!!');
                              await Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  print("This runs after 2 seconds");
                                  if (!mounted) {
                                    return;
                                  }
                                  html.window.location.reload();
                                },
                              );
                            },
                            onError: (data) {
                              ManagerLogInScreenController.showError(
                                  context, data);
                            },
                          );
                        }
                      },
                      isOn: agentInfo!['agent_status'] == 'on-boarded',
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
                        fileName: filesData!['documents-list'][index]
                            ['document_title'],
                        onDownloadPress: () async {
                          await ApiController.downloadFileWeb(
                              filesData!['documents-list'][index]
                                  ['document_title']);
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
          );
  }

  // NOTE Mobile document card — same component as the manager agent-info
  // section's mobile documents view.
  Widget _documentCard(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.withOpacity(0.15),
              child: const Icon(
                Icons.description_outlined,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                  size: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () async {
                await ApiController.downloadFileWeb(title);
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.download,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // NOTE Mobile documents view — manager agent-info-section style. Keeps the
  // agent's interactive onboarding toggle + existing API calls.
  Widget _buildMobileDocuments() {
    if (filesData == null || agentInfo == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }
    final List docs = (filesData!['documents-list'] as List?) ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Documents",
              style: ThemeController.titleTextStyle(),
            ),
            const Spacer(),
            Text(
              "${docs.length} Files Total",
              style: ThemeController.smallTextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w700,
                size: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // NOTE Onboarding completion toggle (agent updates own status).
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Text(
                "Completed",
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              ToggleSwitchWidget(
                isEnabled: agentInfo!['agent_status'] != 'on-boarded',
                isOn: agentInfo!['agent_status'] == 'on-boarded',
                onToggle: (data) async {
                  if (agentInfo!['agent_status'] != 'on-boarded') {
                    ManagerLogInScreenController.showLoaderDialog(context);
                    await ApiController.updateOnBoardStatus(
                      widget.agentId,
                      onSuccess: (data) async {
                        ManagerLogInScreenController.showSuccess(
                            context, 'Status has been updated !!!');
                        await Future.delayed(const Duration(seconds: 2), () {
                          if (!mounted) {
                            return;
                          }
                          html.window.location.reload();
                        });
                      },
                      onError: (data) {
                        ManagerLogInScreenController.showError(context, data);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (docs.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "No documents available",
              style:
                  ThemeController.normalTextStyle(color: Colors.grey.shade600),
            ),
          )
        else
          ...docs.map<Widget>(
            (doc) => _documentCard((doc['document_title'] ?? '').toString()),
          ),
      ],
    );
  }

  // NOTE Mobile View — stacked banner + available documents.
  Widget _buildMobileView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildMobileHeader(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildMobileDocuments(),
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
                  currentOption: AgentDashboardOption.calendar,
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
                      child: _buildDocumentsSection(),
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
