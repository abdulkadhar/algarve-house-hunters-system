import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/widgets/side_option_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

class AgentAddClientScreen extends StatefulWidget {
  final String agentId;
  const AgentAddClientScreen({
    super.key,
    required this.agentId,
  });

  @override
  State<AgentAddClientScreen> createState() => _AgentAddClientScreenState();
}

class _AgentAddClientScreenState extends State<AgentAddClientScreen> {
  Map<String, dynamic>? agentInfo;
  AgentDashboardOption dashboardOption = AgentDashboardOption.customer;
  String? clientId;

  void changeDashboardOption(AgentDashboardOption option) {
    dashboardOption = option;
    setState(() {});
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

  void getCurrentClientId() async {
    await ApiController.getCurrentCustomerId(
      onSuccess: (data) {
        clientId = jsonDecode(data)['current_generate_id'];

        setState(() {});
      },
      onError: (data) {
        print("Current user id fetch");
      },
    );
  }

  String? nameErrorText;
  String? emailErrorText;

  void setNameErrorText(String errorText) {
    nameErrorText = errorText;
    setState(() {});
  }

  void setEmailErrorText(String errorText) {
    emailErrorText = errorText;
    setState(() {});
  }

  void clearNameErrorText() {
    nameErrorText = null;
    setState(() {});
  }

  void clearEmailErrorText() {
    emailErrorText = null;
    setState(() {});
  }

  Map<String, dynamic> clientAdditionData = {
    "client_id": "CLT-BLR-20250625-0001",
    "client_name": "",
    "client_email_address": "",
    "client_phone_number": "",
    "client_location_name": "",
    "client_lat_long": "",
    "client_profile_pic": "https://randomuser.me/api/portraits/man/28.jpg",
    "client_gender": "Male",
    "client_description": "",
    "client_designation": "",
    "client_company_name": "",
    "google_id": "",
    "preference_data": {
      "findingPreference": [],
      "bedNumber": 2,
      "bathNumber": 4,
      "requirementPreference": [],
      "otherPreference": [],
      "houseRegardsPreference": [],
      "neighborPreference": [],
      "locationPreference": [],
      "areaInterestPreference": "",
      "M2Preference": "",
      "buyingPreference": [],
      "valueSpendPreference": 4,
      "taxPreference": [],
      "residenceInfo": "",
      "languagePreference": [],
      "viewingPreference": "",
      "otherAgentsStatus": "",
      "fiscalStatus": "",
      "bankStatus": "",
      "additionalInfo": "",
      "email": "",
      "phoneNumber": "",
      "appointmentInfo": ""
    },
    "agent_id": []
  };

  @override
  void initState() {
    super.initState();
    getAgentProfileData();
    getCurrentClientId();
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
                          // context.go('/agent-listing-screen');
                          context.go('/agent-listing-screen/${widget.agentId}');
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
                          context.go(
                            '/agent-customer-property-allocation/${widget.agentId}',
                          );
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (ctx) =>
                          //             const AgentCustomerPropertyAllocationScreen()));
                          // context.go( '/agent-customer-property-allocation');
                          changeDashboardOption(
                            AgentDashboardOption.customer,
                          );
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
              // NOTE Info Section
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
                          'Client workspace',
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
                          label: "Add new client",
                          onTap: () {
                            // context.go(
                            //   '/manager-agent-onboarding',
                            // );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  // NOTE Empty Space
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  // NOTE Clint info filling section
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ThemeController.pageBackgroundSecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: clientId != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  clientId!,
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
                                        labelName: 'Name',
                                        placeholderText: '',
                                        errorText: nameErrorText,
                                        onChanged: (agentName) {
                                          clearNameErrorText();
                                          if (agentName != null) {
                                            if (agentName.isNotEmpty) {
                                              clientAdditionData[
                                                  'client_name'] = agentName;
                                            } else {
                                              setNameErrorText(
                                                  "Name cannot be empty !!!");
                                            }
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
                                        labelName: 'Email address',
                                        placeholderText: '',
                                        errorText: emailErrorText,
                                        onChanged: (agentEmail) {
                                          clearEmailErrorText();
                                          if (agentEmail != null) {
                                            if (agentEmail.isNotEmpty) {
                                              clientAdditionData[
                                                      'client_email_address'] =
                                                  agentEmail;
                                            } else {
                                              setEmailErrorText(
                                                  "Client email cannot be empty !!!");
                                            }
                                          }
                                        },
                                        isMandatory: true,
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
                                        labelName: 'Phone number',
                                        placeholderText: '',
                                        onChanged: (phoneNumber) {
                                          if (phoneNumber != null &&
                                              phoneNumber.isNotEmpty) {
                                            clientAdditionData[
                                                    'client_phone_number'] =
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
                                        labelName: 'Location name',
                                        placeholderText: '',
                                        onChanged: (agentName) {
                                          if (agentName != null &&
                                              agentName.isNotEmpty) {
                                            clientAdditionData[
                                                    'client_location_name'] =
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
                                        labelName: 'Designation',
                                        placeholderText: '',
                                        onChanged: (agentName) {
                                          if (agentName != null &&
                                              agentName.isNotEmpty) {
                                            clientAdditionData[
                                                    'client_designation'] =
                                                agentName;
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
                                        labelName: 'Description',
                                        placeholderText: '',
                                        onChanged: (agentName) {
                                          if (agentName != null &&
                                              agentName.isNotEmpty) {
                                            clientAdditionData[
                                                    'client_description'] =
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
                                const SizedBox(
                                  height: 20,
                                ),
                                AddMoreButton(
                                  onButtonPress: () {
                                    if (clientAdditionData['client_name'] ==
                                            '' ||
                                        clientAdditionData['client_name'] ==
                                            null) {
                                      setNameErrorText(
                                          "Client name cannot be empty !!!");
                                    } else if (clientAdditionData[
                                                'client_email_address'] ==
                                            null ||
                                        clientAdditionData[
                                                'client_email_address'] ==
                                            '') {
                                      setEmailErrorText(
                                        'Client email cannot be empty !!!',
                                      );
                                    } else {
                                      ManagerLogInScreenController
                                          .showLoaderDialog(context);
                                      ApiController.requestClient(
                                        clientAdditionData,
                                        onSuccess: (data) {
                                          ManagerLogInScreenController
                                              .hideDialogBox(context);
                                          ManagerLogInScreenController.showSuccess(
                                              context,
                                              'Email with form sent to client');
                                          html.window.location.reload();
                                        },
                                        onError: (data) {
                                          ManagerLogInScreenController
                                              .hideDialogBox(context);

                                          print(
                                              'Agent Onboard Form: Error occured');
                                        },
                                      );
                                    }
                                  },
                                  buttonLabel: 'Add Client',
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                    ),
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
