import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_client_info_screen/controller/agent_client_info_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/option_label_selector_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_values_display_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/manager_agent_info_section_secreen/widgets/checklist_unit_data_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AgentClientInfoScreen extends StatefulWidget {
  const AgentClientInfoScreen({super.key});

  @override
  State<AgentClientInfoScreen> createState() => _AgentClientInfoScreenState();
}

class _AgentClientInfoScreenState extends State<AgentClientInfoScreen> {
  List<dynamic>? clientData;
  AgentClientInfoOption optionData = AgentClientInfoOption.preferenceInfo;
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.clients;
  void changeDashboardOption(ManagerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  void changeAgentOption(AgentClientInfoOption data) {
    optionData = data;
    setState(() {});
  }

  Map<String, dynamic>? selectedClient;
  Map<String, dynamic>? selectedAgent;
  Map<String, dynamic>? currentUserChecklist;

  void getCurrentUserCheckListData(
    String agent_id,
    String user_id,
  ) async {
    await ApiController.getAllCheckListDataById(
      agent_id,
      user_id,
      onSuccess: (data) {
        currentUserChecklist = jsonDecode(data);
        setState(() {});
      },
      onError: (data) {
        print("CHECKLIST DATA ERROR: ");
      },
    );
  }

  void getAgentData(
    String agentId,
  ) async {
    await ApiController.getAgentInfoById(
      agentId,
      onSuccess: (data) {
        selectedAgent = jsonDecode(data);
        currentUserChecklist = null;
        setState(() {});
      },
      onError: (data) {
        print("Agent ClientInfo Screen: Agent Info Fetch Error");
      },
    );
  }

  void getClientData() async {
    await ApiController.getAllClientsData(
      onSuccess: (responseData) {
        clientData = jsonDecode(responseData) as List<dynamic>;
        selectedClient = clientData![0];
        currentUserChecklist = null;
        setState(() {});
        print('Data has been loaded');
      },
      onError: (errorData) {
        print("Error has occured !!!");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getClientData();
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
                          'Client list',
                          style: ThemeController.normalTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                        if (clientData != null && selectedClient != null)
                          Column(
                            children: List.generate(
                              clientData!.length,
                              (index) => ClientQuickActionWidget(
                                userData: clientData![index],
                                isSelected: clientData![index]['client_id'] ==
                                    selectedClient!['client_id'],
                                onProfilePress: () {
                                  selectedClient = clientData![index];
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
                          // NOTE Internal option
                          Row(
                            children: [
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentClientInfoOption.basicInfo,
                                onPress: () {
                                  changeAgentOption(
                                      AgentClientInfoOption.basicInfo);
                                },
                                optionLabel: 'Basic Info',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentClientInfoOption.preferenceInfo,
                                onPress: () {
                                  changeAgentOption(
                                    AgentClientInfoOption.preferenceInfo,
                                  );
                                },
                                optionLabel: 'Preference Info',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentClientInfoOption.agentInfo,
                                onPress: () {
                                  if (selectedClient != null) {
                                    // getCurrentUserCheckListData(
                                    //     selectedAgent!['agent_id']);
                                    getAgentData(selectedClient!['agent_id']);
                                    changeAgentOption(
                                      AgentClientInfoOption.agentInfo,
                                    );
                                  }
                                },
                                optionLabel: 'Agent Info',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentClientInfoOption.clientChecklist,
                                onPress: () async {
                                  if (selectedClient != null) {
                                    if (selectedClient!['agent_id'] != '') {
                                      getCurrentUserCheckListData(
                                        selectedClient!['agent_id'],
                                        selectedClient!['client_id'],
                                      );
                                      changeAgentOption(
                                        AgentClientInfoOption.clientChecklist,
                                      );
                                    }
                                  }
                                },
                                optionLabel: 'Checklist',
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // NOTE Basic Info
                          if (selectedClient != null &&
                              optionData == AgentClientInfoOption.basicInfo)
                            Column(
                              children: [
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Client ID',
                                  labelValue: selectedClient!['client_id'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Name',
                                  labelValue: selectedClient!['client_name'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Email address',
                                  labelValue:
                                      selectedClient!['client_email_address'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Phone number',
                                  labelValue:
                                      selectedClient!['client_phone_number'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Location name',
                                  labelValue:
                                      selectedClient!['client_location_name'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Designation',
                                  labelValue:
                                      selectedClient!['client_designation'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Company name',
                                  labelValue:
                                      selectedClient!['client_company_name'],
                                ),
                              ],
                            ),
                          // NOTE Preference Data
                          if (selectedClient != null &&
                              optionData ==
                                  AgentClientInfoOption.preferenceInfo)
                            Column(
                              children: [
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Finding preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['findingPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Bed number',
                                  labelValue: selectedClient!['preference_data']
                                          ['bedNumber']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Bath number',
                                  labelValue: selectedClient!['preference_data']
                                          ['bathNumber']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Requirement preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['requirementPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Other preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['otherPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'House regards preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['houseRegardsPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Neighbor preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['neighborPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Location Preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['locationPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'M2Preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['M2Preference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Buying preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['buyingPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Value spend preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['valueSpendPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Value spend preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['valueSpendPreference']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Tax Preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['taxPreference']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Residence Info',
                                  labelValue: selectedClient!['preference_data']
                                          ['residenceInfo']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Language Preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['languagePreference']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Viewing Preference',
                                  labelValue: selectedClient!['preference_data']
                                          ['viewingPreference']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Other Agents Status',
                                  labelValue: selectedClient!['preference_data']
                                          ['otherAgentsStatus']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Fiscal Status',
                                  labelValue: selectedClient!['preference_data']
                                          ['fiscalStatus']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Bank Status',
                                  labelValue: selectedClient!['preference_data']
                                          ['bankStatus']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Additional Info',
                                  labelValue: selectedClient!['preference_data']
                                          ['additionalInfo']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Email',
                                  labelValue: selectedClient!['preference_data']
                                          ['email']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Phone Number',
                                  labelValue: selectedClient!['preference_data']
                                          ['phoneNumber']
                                      .toString(),
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Appointment Info',
                                  labelValue: selectedClient!['preference_data']
                                          ['appointmentInfo']
                                      .toString(),
                                ),
                              ],
                            ),
                          // NOTE Agent Info Section
                          if (selectedClient != null &&
                              optionData == AgentClientInfoOption.agentInfo)
                            selectedClient!['agent_id'] == ''
                                ? Column(
                                    children: [
                                      Icon(Icons.edit_document),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Agent not assigned",
                                        style: ThemeController.normalTextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    ],
                                  )
                                : Column(
                                    children: [
                                      UserPreferenceValuesDisplayWidget(
                                        labelName: 'Agent Id',
                                        labelValue: selectedAgent!['agent_id'],
                                      ),
                                      const SizedBox(height: 10),
                                      UserPreferenceValuesDisplayWidget(
                                        labelName: 'Agent Name',
                                        labelValue:
                                            selectedAgent!['agent_name'],
                                      ),
                                      const SizedBox(height: 10),
                                      UserPreferenceValuesDisplayWidget(
                                        labelName: 'Agent email address',
                                        labelValue: selectedAgent![
                                            'agent_email_address'],
                                      ),
                                      const SizedBox(height: 10),
                                      UserPreferenceValuesDisplayWidget(
                                        labelName: 'Agent phone number',
                                        labelValue: selectedAgent![
                                            'agent_phone_number'],
                                      ),
                                      const SizedBox(height: 10),
                                      UserPreferenceValuesDisplayWidget(
                                        labelName: 'Agent location',
                                        labelValue: selectedAgent![
                                            'agent_location_name'],
                                      ),
                                      const SizedBox(height: 10),
                                      UserPreferenceValuesDisplayWidget(
                                        labelName: 'Agent Status',
                                        labelValue:
                                            selectedAgent!['agent_status'],
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
                          if (selectedClient != null &&
                              selectedAgent != null &&
                              currentUserChecklist != null)
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
