import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/view/agent_property_info_screen.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/widgets/side_option_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_password_text_form_field.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

class AgentInfoUpdateScreen extends StatefulWidget {
  final String agentId;
  const AgentInfoUpdateScreen({
    super.key,
    required this.agentId,
  });

  @override
  State<AgentInfoUpdateScreen> createState() => _AgentInfoUpdateScreenState();
}

class _AgentInfoUpdateScreenState extends State<AgentInfoUpdateScreen> {
  // Agent profile response
//   {
//     "agent_id": "AGT-BLR-20250818-0009",
//     "agent_name": "Fazil",
//     "agent_email_address": "fazil@powerscribe.com",
//     "agent_phone_number": "",
//     "agent_location_name": "",
//     "agent_lat_long": "",
//     "agent_profile_pic": "",
//     "agent_gender": "",
//     "agent_status": "on-boarded",
//     "agent_availability_status": "",
//     "agent_description": "",
//     "agent_designation": "",
//     "google_id": "",
//     "agent_password": "Boing1511!",
//     "password_updated": "true",
//     "last_login": "2025-08-20T11:11:17.435126",
//     "access_token": "",
//     "assigned_clients": [
//         "CLT-BLR-20250818-0021"
//     ]
// }

  Map<String, dynamic>? agentInfo;
  List<dynamic>? assignedClients;

  bool profileInformationReadOnly = true;
  bool contactInformationReadOnly = true;
  bool securityInformationReadOnly = true;

  String newPasswordHolder = '';
  String reEnterPasswordHolder = '';

  Map<String, dynamic> personalInformationData = {
    "agent_id": "",
    "agent_name": "",
    "agent_phone_number": "",
    "agent_location_name": "",
    "agent_description": "",
    "agent_designation": ""
  };

  Map<String, dynamic> contactInformationData = {
    "agent_id": "",
    "agent_email_address": ""
  };

  Map<String, dynamic> securityInformationData = {
    "agent_id": "",
    "agent_password": ""
  };

  void setProfileReadOnly(bool value) {
    profileInformationReadOnly = value;
    setState(() {});
  }

  void setContactReadOnly(bool value) {
    contactInformationReadOnly = value;
    setState(() {});
  }

  void setSecurityReadOnly(bool value) {
    securityInformationReadOnly = value;
    setState(() {});
  }

  void getAgentProfileData() async {
    await ApiController.getAgentInfoById(
      widget.agentId,
      onError: (data) {},
      onSuccess: (data) {
        agentInfo = jsonDecode(data);
        if (agentInfo != null) {
          personalInformationData['agent_id'] = agentInfo!['agent_id'];
          personalInformationData['agent_name'] = agentInfo!['agent_name'];
          personalInformationData['agent_phone_number'] =
              agentInfo!['agent_phone_number'];
          personalInformationData['agent_location_name'] =
              agentInfo!['agent_location_name'];
          personalInformationData['agent_description'] =
              agentInfo!['agent_description'];
          personalInformationData['agent_designation'] =
              agentInfo!['agent_designation'];

// contact information
          contactInformationData['agent_id'] = agentInfo!['agent_id'];
          contactInformationData['agent_email_address'] =
              agentInfo!['agent_email_address'];

// Security information
          securityInformationData['agent_id'] = agentInfo!['agent_id'];
        }

        setState(() {});
      },
    );
  }

  void getAssignedClients() async {
    await ApiController.assignedClients(
      widget.agentId,
      onSuccess: (data) {
        assignedClients = jsonDecode(data);
        // if (assignedClients != null && assignedClients!.isNotEmpty) {
        //   selectedUser = assignedClients![0];
        // }

        setState(() {});
      },
      onError: (data) {},
    );
  }

  Widget getButtonWidget({
    required VoidCallback onTap,
    required String buttonLabel,
    required Color buttonColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: buttonColor,
          ),
        ),
        child: Text(
          buttonLabel,
          style: ThemeController.smallTextStyle(
            color: buttonColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAgentProfileData();
    getAssignedClients();
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
                        isEnabled: false,
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
                        isEnabled: false,
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
                        isEnabled: false,
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
                        isEnabled: false,
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
                height: 20,
              ),
              SizedBox(
                child: Row(
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
                          SideOptionButton(
                            iconData: Icons.person,
                            isSelected: true,
                            label: "Agent profile update",
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    // NOTE Empty Space
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.01,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: ThemeController.pageBackgroundSecondaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: agentInfo != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Profile information",
                                        style: ThemeController.normalTextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const Spacer(),
                                      getButtonWidget(
                                        onTap: () {
                                          setProfileReadOnly(
                                              !profileInformationReadOnly);
                                        },
                                        buttonLabel: profileInformationReadOnly
                                            ? 'Edit personal information'
                                            : 'Discard',
                                        buttonColor: Colors.black,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          width: 200,
                                          child: CustomTextFormFiled(
                                            labelName: 'Name',
                                            placeholderText: '',
                                            initialValue:
                                                agentInfo!['agent_name'],
                                            readOnly:
                                                profileInformationReadOnly,
                                            onChanged: (data) {
                                              if (data != null && data != '') {
                                                personalInformationData[
                                                    "agent_name"] = data;
                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          width: 200,
                                          child: CustomTextFormFiled(
                                            labelName: 'Phone number',
                                            placeholderText: '',
                                            initialValue: agentInfo![
                                                'agent_phone_number'],
                                            isMandatory: false,
                                            readOnly:
                                                profileInformationReadOnly,
                                            onChanged: (data) {
                                              if (data != null && data != '') {
                                                personalInformationData[
                                                        "agent_phone_number"] =
                                                    data;
                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: CustomTextFormFiled(
                                            labelName: 'Location name',
                                            placeholderText: '',
                                            initialValue: agentInfo![
                                                'agent_location_name'],
                                            readOnly:
                                                profileInformationReadOnly,
                                            isMandatory: false,
                                            onChanged: (data) {
                                              if (data != null && data != '') {
                                                personalInformationData[
                                                        "agent_location_name"] =
                                                    data;
                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          child: CustomTextFormFiled(
                                            labelName: 'Agent description',
                                            placeholderText: '',
                                            initialValue:
                                                agentInfo!['agent_description'],
                                            isMandatory: false,
                                            readOnly:
                                                profileInformationReadOnly,
                                            onChanged: (data) {
                                              if (data != null && data != '') {
                                                personalInformationData[
                                                    "agent_description"] = data;
                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: CustomTextFormFiled(
                                            labelName: 'Designation',
                                            placeholderText: '',
                                            initialValue:
                                                agentInfo!['agent_designation'],
                                            readOnly:
                                                profileInformationReadOnly,
                                            isMandatory: false,
                                            onChanged: (data) {
                                              if (data != null && data != '') {
                                                personalInformationData[
                                                    "agent_designation"] = data;
                                                setState(() {});
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                  if (!profileInformationReadOnly)
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: SubmitButton(
                                            onButtonPress: () async {
                                              ManagerLogInScreenController
                                                  .showLoaderDialog(context);
                                              await ApiController
                                                  .updateAgentProfileInformation(
                                                      personalInformationData,
                                                      onSuccess: (resData) {
                                                ManagerLogInScreenController
                                                    .showSuccess(
                                                  context,
                                                  'Profile information has been updated',
                                                );
                                                Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }, onError: (errData) {
                                                ManagerLogInScreenController
                                                    .hideDialogBox(context);
                                                ManagerLogInScreenController
                                                    .showError(context,
                                                        jsonDecode(errData));
                                              });
                                            },
                                            buttonLabel: 'Save changes',
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Contact information",
                                        style: ThemeController.normalTextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const Spacer(),
                                      const Spacer(),
                                      getButtonWidget(
                                        onTap: () {
                                          setContactReadOnly(
                                              !contactInformationReadOnly);
                                        },
                                        buttonLabel: contactInformationReadOnly
                                            ? 'Edit contact information'
                                            : 'Discard',
                                        buttonColor: contactInformationReadOnly
                                            ? Colors.black
                                            : Colors.red,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: CustomTextFormFiled(
                                              labelName: 'Email',
                                              placeholderText: '',
                                              initialValue: agentInfo![
                                                  'agent_email_address'],
                                              readOnly:
                                                  contactInformationReadOnly,
                                              isMandatory: true,
                                              onChanged: (data) {
                                                if (data != null &&
                                                    data != '') {
                                                  contactInformationData[
                                                          "agent_email_address"] =
                                                      data;
                                                  setState(() {});
                                                }
                                              }),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                  if (!contactInformationReadOnly)
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: SubmitButton(
                                            onButtonPress: () async {
                                              ManagerLogInScreenController
                                                  .showLoaderDialog(context);
                                              await ApiController
                                                  .updateAgentContactInformation(
                                                      contactInformationData,
                                                      onSuccess: (resData) {
                                                ManagerLogInScreenController
                                                    .showSuccess(
                                                  context,
                                                  'Contact information has been updated',
                                                );
                                                Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }, onError: (errData) {
                                                ManagerLogInScreenController
                                                    .hideDialogBox(context);
                                                ManagerLogInScreenController
                                                    .showError(context,
                                                        jsonDecode(errData));
                                              });
                                            },
                                            buttonLabel: 'Save changes',
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Security information",
                                        style: ThemeController.normalTextStyle(
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      Spacer(),
                                      const Spacer(),
                                      getButtonWidget(
                                        onTap: () {
                                          setSecurityReadOnly(
                                              !securityInformationReadOnly);
                                        },
                                        buttonLabel: 'Update password',
                                        buttonColor: Colors.black,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          child: CustomPasswordTextField(
                                            labelName: 'New password',
                                            placeholderText: '',
                                            isMandatory: true,
                                            readOnly:
                                                securityInformationReadOnly,
                                            onChanged: (data) {
                                              if (data != null && data != '') {
                                                newPasswordHolder = data;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: SizedBox(
                                          child: CustomPasswordTextField(
                                            labelName: 'Re-enter password',
                                            placeholderText: '',
                                            isMandatory: true,
                                            readOnly:
                                                securityInformationReadOnly,
                                            onChanged: (data) {
                                              if (data != null && data != '') {
                                                reEnterPasswordHolder = data;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!securityInformationReadOnly)
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: SubmitButton(
                                            onButtonPress: () async {
                                              if (newPasswordHolder !=
                                                  reEnterPasswordHolder) {
                                                ManagerLogInScreenController
                                                    .showError(context,
                                                        'Both the password must be same !!');
                                              } else if (newPasswordHolder ==
                                                      '' ||
                                                  reEnterPasswordHolder == '') {
                                                ManagerLogInScreenController
                                                    .showError(context,
                                                        'password value cannot be empty!!');
                                              } else {
                                                securityInformationData[
                                                        'agent_password'] =
                                                    newPasswordHolder;
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .updateAgentProfilePassword(
                                                        securityInformationData,
                                                        onSuccess:
                                                            (resData) async {
                                                  ManagerLogInScreenController
                                                      .showSuccess(
                                                    context,
                                                    'Password has been updated. Please login again.',
                                                  );
                                                  Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                      if (!mounted) return;

                                                      context.go(
                                                          '/agent-login-screen');
                                                    },
                                                  );
                                                }, onError: (errData) {
                                                  ManagerLogInScreenController
                                                      .hideDialogBox(context);
                                                  ManagerLogInScreenController
                                                      .showError(context,
                                                          jsonDecode(errData));
                                                });
                                              }
                                            },
                                            buttonLabel: 'Save changes',
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              )
                            : const Center(
                                child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
