import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/widgets/side_option_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AgentOnboardingScreen extends StatefulWidget {
  const AgentOnboardingScreen({super.key});

  @override
  State<AgentOnboardingScreen> createState() => _AgentOnboardingScreenState();
}

class _AgentOnboardingScreenState extends State<AgentOnboardingScreen> {
  String? agentId;
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.agents;

  Map<String, dynamic> agentOnboardData = {
    "agent_id": "",
    "agent_name": "",
    "agent_email_address": "",
    "agent_phone_number": "",
    "agent_location_name": "",
    "agent_lat_long": "",
    "agent_profile_pic": "",
    "agent_gender": "",
    "agent_status": "profile-created",
    "agent_availability_status": "",
    "agent_description": "",
    "agent_designation": "",
    "google_id": ""
  };

  void changeDashboardOption(ManagerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  void getAgentId() async {
    await ApiController.getCurrentAgentId(
      onSuccess: (data) {
        agentId = jsonDecode(data)['current_generate_id'];
        setState(() {});
      },
      onError: (data) {
        print("Error Occured in agent ID");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getAgentId();
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
                          changeDashboardOption(
                            ManagerDashboardOption.dashboard,
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
                          changeDashboardOption(
                            ManagerDashboardOption.agents,
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
                          changeDashboardOption(
                            ManagerDashboardOption.clients,
                          );
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
                          'Agent workspace',
                          style: ThemeController.normalTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SideOptionButton(
                          iconData: Icons.add,
                          isSelected: true,
                          label: "Add new agent",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SideOptionButton(
                          iconData: Icons.document_scanner,
                          isSelected: false,
                          label: "Training Document",
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
                      // width: MediaQuery.of(context).size.width * 0.7,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ThemeController.pageBackgroundSecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: agentId != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  agentId!,
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: CustomTextFormFiled(
                                        labelName: 'Agent name',
                                        placeholderText: '',
                                        onChanged: (agentName) {
                                          if (agentName != null) {
                                            if (agentName.isNotEmpty) {
                                              agentOnboardData['agent_name'] =
                                                  agentName;
                                            }
                                          }
                                        },
                                        isMandatory: false,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: CustomTextFormFiled(
                                        labelName: 'Agent email address',
                                        placeholderText: '',
                                        onChanged: (agentEmail) {
                                          if (agentEmail != null) {
                                            if (agentEmail.isNotEmpty) {
                                              agentOnboardData[
                                                      'agent_email_address'] =
                                                  agentEmail;
                                            }
                                          }
                                        },
                                        isMandatory: false,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: CustomTextFormFiled(
                                        labelName: 'Agent phone number',
                                        placeholderText: '',
                                        onChanged: (phoneNumber) {
                                          if (phoneNumber != null &&
                                              phoneNumber.isNotEmpty) {
                                            agentOnboardData[
                                                    'agent_phone_number'] =
                                                phoneNumber;
                                          }
                                        },
                                        isMandatory: false,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: CustomTextFormFiled(
                                        labelName: 'Agent location name',
                                        placeholderText: '',
                                        onChanged: (agentName) {
                                          if (agentName != null &&
                                              agentName.isNotEmpty) {
                                            agentOnboardData[
                                                    'agent_location_name'] =
                                                agentName;
                                          }
                                        },
                                        isMandatory: false,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: CustomTextFormFiled(
                                        labelName: 'Agent status',
                                        placeholderText: '',
                                        onChanged: (agentName) {},
                                        isMandatory: false,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: CustomTextFormFiled(
                                        labelName: 'Agent description',
                                        placeholderText: '',
                                        onChanged: (agentName) {
                                          if (agentName != null &&
                                              agentName.isNotEmpty) {
                                            agentOnboardData[
                                                    'agent_description'] =
                                                agentName;
                                          }
                                        },
                                        isMandatory: false,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: CustomTextFormFiled(
                                    labelName: 'Agent designation',
                                    placeholderText: '',
                                    onChanged: (agentName) {
                                      if (agentName != null &&
                                          agentName.isNotEmpty) {
                                        agentOnboardData['agent_designation'] =
                                            agentName;
                                      }
                                    },
                                    isMandatory: false,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                AddMoreButton(
                                  onButtonPress: () {
                                    ApiController.sendAddAgentRequest(
                                      agentOnboardData,
                                      onSuccess: (data) {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          '/manager-dashboard-screen',
                                        );
                                      },
                                      onError: (data) {
                                        print(
                                            'Agent Onboard Form: Error occured');
                                      },
                                    );
                                  },
                                  buttonLabel: 'Add Agent',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          : const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
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
