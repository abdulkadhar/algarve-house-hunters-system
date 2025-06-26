import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/option_label_selector_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/toggle_switch_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_values_display_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/agent_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_document_screen/widgets/file_content_tile.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/manager_agent_info_section_secreen/controller/manager_agent_info_section_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_agent_info_section_secreen/widgets/checklist_unit_data_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ManagerAgentInfoSectionScreen extends StatefulWidget {
  const ManagerAgentInfoSectionScreen({super.key});

  @override
  State<ManagerAgentInfoSectionScreen> createState() =>
      _ManagerAgentInfoSectionScreenState();
}

class _ManagerAgentInfoSectionScreenState
    extends State<ManagerAgentInfoSectionScreen> {
  AgentInoOption optionData = AgentInoOption.agentInfo;
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.agents;
  Map<String, dynamic>? filesData;
  void changeDashboardOption(ManagerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  void changeAgentOption(AgentInoOption data) {
    optionData = data;
    setState(() {});
  }

  List<dynamic>? agentData;
  String currentAgentId = '';
  Map<String, dynamic>? selectedAgent;
  Map<String, dynamic>? currentUserChecklist;

  // void getCurrentUserCheckListData(String agent_id) async {
  //   await ApiController.getAllCheckListDataById(
  //     agent_id,
  //     onSuccess: (data) {
  //       currentUserChecklist = jsonDecode(data);
  //       setState(() {});
  //     },
  //     onError: (data) {
  //       print("CHECKLIST DATA ERROR: ");
  //     },
  //   );
  // }

  void getAgentData() async {
    await ApiController.getAllAgentData(
      onSuccess: (responseData) {
        agentData = jsonDecode(responseData) as List<dynamic>;
        currentAgentId = agentData![0]['agent_id'];
        selectedAgent = agentData![0];
        setState(() {});
      },
      onError: (errorData) {
        print("Agent Data: Error has occured !!!");
      },
    );
  }

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

  @override
  void initState() {
    getAgentData();
    getAllFiles();
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
                            dashboardOption == ManagerDashboardOption.dashboard,
                        iconData: Icons.dashboard,
                        optionLabel: 'Dashboard',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
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
                          Navigator.pushNamed(
                            context,
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
                          Navigator.pushNamed(
                              context, '/manager-client-info-screen');
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
                        Text(
                          'Agent list',
                          style: ThemeController.normalTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                                isSelected: agentData![index]['agent_id'] ==
                                    currentAgentId,
                                onProfilePress: () {
                                  currentAgentId =
                                      agentData![index]['agent_id'];
                                  selectedAgent = agentData![index];
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
                        children: [
                          Row(
                            children: [
                              OptionLabelSelectorWidget(
                                isEnabled:
                                    optionData == AgentInoOption.agentInfo,
                                onPress: () {
                                  changeAgentOption(AgentInoOption.agentInfo);
                                },
                                optionLabel: 'Agent Info',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentInoOption.onboardingDocument,
                                onPress: () {
                                  changeAgentOption(
                                    AgentInoOption.onboardingDocument,
                                  );
                                },
                                optionLabel: 'On boarding documents',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled:
                                    optionData == AgentInoOption.agentCheckList,
                                onPress: () {
                                  // if (selectedAgent != null) {
                                  //   getCurrentUserCheckListData(
                                  //       selectedAgent!['agent_id']);
                                  // }
                                  changeAgentOption(
                                      AgentInoOption.agentCheckList);
                                },
                                optionLabel: 'Check list',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentInoOption.assignedClients,
                                onPress: () {
                                  changeAgentOption(
                                      AgentInoOption.assignedClients);
                                },
                                optionLabel: 'Assigned Clients',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (optionData == AgentInoOption.agentInfo &&
                              selectedAgent != null)
                            Column(
                              children: [
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent Id',
                                  labelValue: selectedAgent!['agent_id'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent Name',
                                  labelValue: selectedAgent!['agent_name'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent email address',
                                  labelValue:
                                      selectedAgent!['agent_email_address'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent phone number',
                                  labelValue:
                                      selectedAgent!['agent_phone_number'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent location',
                                  labelValue:
                                      selectedAgent!['agent_location_name'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent Status',
                                  labelValue: selectedAgent!['agent_status'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent Designation',
                                  labelValue:
                                      selectedAgent!['agent_designation'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent Description',
                                  labelValue:
                                      selectedAgent!['agent_description'],
                                ),
                              ],
                            ),
                          // TODO Need work on this
                          if (optionData == AgentInoOption.assignedClients &&
                              selectedAgent != null)
                            selectedAgent!['agent_status'] == "profile-created"
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.pending_actions_sharp,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'Complete the onboarding document section to get assigned by clients'),
                                    ],
                                  )
                                : Container(
                                    child: Text('Assignment'),
                                  ),
                          // NOTE Onboarding Section
                          if (optionData == AgentInoOption.onboardingDocument &&
                              filesData != null &&
                              selectedAgent != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "On Boarding Documents",
                                      style: ThemeController.normalTextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Spacer(),
                                    ToggleSwitchWidget(
                                      isEnabled: false,
                                      isOn: selectedAgent!['agent_status'] !=
                                          'profile-created',
                                      onToggle: (data) {},
                                    ),
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
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          // NOTE - Check List Section
                          if (optionData == AgentInoOption.agentCheckList &&
                              currentUserChecklist != null &&
                              selectedAgent != null)
                            Column(
                              children: List.generate(
                                currentUserChecklist!['checklist_data'].length,
                                (index) => index == 0
                                    ? const SizedBox.shrink()
                                    : Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          CheckListUnitDataWidget(
                                            isEnabled: false,
                                            isOn: currentUserChecklist![
                                                        'checklist_data'][index]
                                                    ['status'] !=
                                                'Not-Started',
                                            onTogglePress: (data) {},
                                            title: currentUserChecklist![
                                                    'checklist_data'][index]
                                                ['title'],
                                            subtitle: currentUserChecklist![
                                                    'checklist_data'][index]
                                                ['subtitle'],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                              ),
                            )
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
