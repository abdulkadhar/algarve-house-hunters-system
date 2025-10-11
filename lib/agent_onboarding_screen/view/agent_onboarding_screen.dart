import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/widgets/side_option_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

class AgentOnboardingScreen extends StatefulWidget {
  const AgentOnboardingScreen({super.key});

  @override
  State<AgentOnboardingScreen> createState() => _AgentOnboardingScreenState();
}

class _AgentOnboardingScreenState extends State<AgentOnboardingScreen> {
  String? agentId;
  String? agentNameErrorText;
  String? agentEmailErrorText;
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.agents;

  void setAgentNameErrorText(String errorText) {
    agentNameErrorText = errorText;
    setState(() {});
  }

  void setAgentEmailErrorText(String errorText) {
    agentEmailErrorText = errorText;
    setState(() {});
  }

  void clearAgentNameErrorText() {
    agentNameErrorText = null;
    setState(() {});
  }

  void clearAgentEmailErrorText() {
    agentEmailErrorText = null;
    setState(() {});
  }

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
    "google_id": "",
    "agent_password": "Test@123",
    "password_updated": "false",
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
                              '/manager-client-info-screen/CLT-BLR-20221117-0001');
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
                          onTap: () {
                            context.go(
                              '/manager-agent-onboarding',
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SideOptionButton(
                          iconData: Icons.document_scanner,
                          isSelected: false,
                          label: "Training Document",
                          onTap: () {
                            context.go(
                              '/manager-agent-onboarding-document-screen',
                            );
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
                                        errorText: agentNameErrorText,
                                        initialValue:
                                            agentOnboardData['agent_name'],
                                        onChanged: (agentName) {
                                          clearAgentNameErrorText();
                                          if (agentName != null) {
                                            if (agentName.isNotEmpty) {
                                              agentOnboardData['agent_name'] =
                                                  agentName;
                                            }
                                          } else {
                                            setAgentNameErrorText(
                                                "Agent name cannot be empty");
                                          }
                                        },
                                        isMandatory: true,
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
                                        errorText: agentEmailErrorText,
                                        initialValue: agentOnboardData[
                                            'agent_email_address'],
                                        onChanged: (agentEmail) {
                                          clearAgentEmailErrorText();
                                          if (agentEmail != null) {
                                            if (agentEmail.isNotEmpty) {
                                              agentOnboardData[
                                                      'agent_email_address'] =
                                                  agentEmail;
                                            }
                                          } else {
                                            setAgentEmailErrorText(
                                                "Agent email cannot be empty !!!");
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
                                        initialValue: agentOnboardData[
                                            'agent_phone_number'],
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
                                        initialValue: agentOnboardData[
                                            'agent_location_name'],
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
                                        initialValue: agentOnboardData[
                                            'agent_description'],
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
                                    initialValue:
                                        agentOnboardData['agent_designation'],
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
                                    if (agentOnboardData["agent_name"] == '' ||
                                        agentOnboardData["agent_name"] ==
                                            null) {
                                      setAgentNameErrorText(
                                          'Agent name cannot be empty !!!');
                                    } else if (agentOnboardData[
                                                "agent_email_address"] ==
                                            '' ||
                                        agentOnboardData[
                                                "agent_email_address"] ==
                                            null) {
                                      setAgentEmailErrorText(
                                          'Agent email cannot be empty !!!');
                                    } else {
                                      ManagerLogInScreenController
                                          .showLoaderDialog(context);
                                      ApiController.sendAddAgentRequest(
                                        agentOnboardData,
                                        onSuccess: (data) async {
                                          ManagerLogInScreenController.showSuccess(
                                              context,
                                              'Email sent successfully to agent !!!');
                                          await Future.delayed(
                                              const Duration(seconds: 2), () {
                                            print("This runs after 2 seconds");
                                          });
                                          html.window.location.reload();
                                        },
                                        onError: (data) {
                                          ManagerLogInScreenController.showError(
                                              context,
                                              'Error occured in sending mail');
                                          print(
                                              'Agent Onboard Form: Error occured');
                                        },
                                      );
                                    }
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
