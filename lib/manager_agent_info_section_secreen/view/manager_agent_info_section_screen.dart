import 'dart:convert';
import 'dart:html' as html;
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/option_label_selector_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/toggle_switch_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_values_display_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/agent_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_document_screen/widgets/file_content_tile.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_password_text_form_field.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/manager_agent_info_section_secreen/controller/manager_agent_info_section_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManagerAgentInfoSectionScreen extends StatefulWidget {
  final String? agentId;
  const ManagerAgentInfoSectionScreen({
    super.key,
    this.agentId,
  });

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
  List<dynamic>? assignedClients;

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

  // SECTION - Profile state
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

  //!SECTION

  void getAgentData() async {
    print("INFO:getting in agents details ");
    await ApiController.getAllAgentData(
      onSuccess: (responseData) {
        agentData = jsonDecode(responseData) as List<dynamic>;
        currentAgentId = agentData![0]['agent_id'];
        selectedAgent = agentData![0];
        assignedClients = null;
        setState(() {});
        setAgentId();
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

  void setAgentId() {
    print("INFO:entering the set agent id");
    if (widget.agentId != null && agentData != null) {
      print("agent id: ${widget.agentId}");
      currentAgentId = widget.agentId!;
      for (int i = 0; i < agentData!.length; i++) {
        if (agentData![i]["agent_id"] == widget.agentId) {
          currentAgentId = agentData![i]['agent_id'];
          selectedAgent = agentData![i];
          assignedClients = null;
        }
      }
      setState(() {});
    }
  }

  Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text(
            'Do you wish to proceed with deleting the agent?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // close dialog
                onConfirm(); // execute delete action
              },
              child: const Text('Delete'),
            ),
          ],
        );
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
                          context.go('/manager-property-management-screen');
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
                            '/manager-client-info-screen/CLT-BLR-20221117-0001/basicInfo',
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
                              '/manager-client-info-screen/CLT-BLR-20221117-0001/basicInfo');
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
                        Row(
                          children: [
                            Text(
                              'Agent list',
                              style: ThemeController.normalTextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                context.go(
                                  '/manager-agent-onboarding',
                                );
                              },
                              child: const Icon(
                                Icons.add,
                              ),
                            )
                          ],
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
                                  changeAgentOption(AgentInoOption.agentInfo);
                                  print("INFO:option data: ${optionData}");
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
                                onPress: () async {
                                  if (selectedAgent != null &&
                                      selectedAgent!['agent_id'] != '') {
                                    await ApiController.assignedClients(
                                      selectedAgent!['agent_id'],
                                      onSuccess: (data) {
                                        assignedClients = jsonDecode(data);
                                        setState(() {});
                                      },
                                      onError: (data) {},
                                    );
                                  }
                                  changeAgentOption(
                                      AgentInoOption.assignedClients);
                                },
                                optionLabel: 'Assigned Clients',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                enabledTextColor: Colors.green,
                                enabledBorderColor: Colors.green,
                                disabledBorderColor: Colors.green,
                                disabledTextColor: Colors.green,
                                isEnabled:
                                    optionData == AgentInoOption.profileEdit,
                                onPress: () {
                                  changeAgentOption(AgentInoOption.profileEdit);
                                },
                                optionLabel: 'Edit Profile',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  showDeleteConfirmationDialog(
                                    context: context,
                                    onConfirm: () {
                                      ApiController.deleteAgentData(
                                        currentAgentId,
                                        onSuccess: (response) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Agent deleted successfully',
                                              ),
                                            ),
                                          );
                                          html.window.location.reload();
                                        },
                                        onError: (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error deleting agent: $error')),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.red,
                                    ),
                                  ),
                                  child: Text(
                                    "Delete Agent",
                                    style: ThemeController.smallTextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              )
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
                          if (optionData == AgentInoOption.profileEdit)
                            Column(
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
                                              selectedAgent!['agent_name'],
                                          readOnly: profileInformationReadOnly,
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
                                          initialValue: selectedAgent![
                                              'agent_phone_number'],
                                          isMandatory: false,
                                          readOnly: profileInformationReadOnly,
                                          onChanged: (data) {
                                            if (data != null && data != '') {
                                              personalInformationData[
                                                  "agent_phone_number"] = data;
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
                                          initialValue: selectedAgent![
                                              'agent_location_name'],
                                          readOnly: profileInformationReadOnly,
                                          isMandatory: false,
                                          onChanged: (data) {
                                            if (data != null && data != '') {
                                              personalInformationData[
                                                  "agent_location_name"] = data;
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
                                          initialValue: selectedAgent![
                                              'agent_description'],
                                          isMandatory: false,
                                          readOnly: profileInformationReadOnly,
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
                                          initialValue: selectedAgent![
                                              'agent_designation'],
                                          readOnly: profileInformationReadOnly,
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
                                            if (selectedAgent!['agent_id'] !=
                                                null) {
                                              personalInformationData[
                                                      'agent_id'] =
                                                  selectedAgent!['agent_id'];
                                            }
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
                                                  html.window.location.reload();
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
                                            initialValue: selectedAgent![
                                                'agent_email_address'],
                                            readOnly:
                                                contactInformationReadOnly,
                                            isMandatory: true,
                                            onChanged: (data) {
                                              if (data != null && data != '') {
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
                                            if (selectedAgent!['agent_id'] !=
                                                null) {
                                              contactInformationData[
                                                      'agent_id'] =
                                                  selectedAgent!['agent_id'];
                                            }
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
                                                  html.window.location.reload();
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
                                          readOnly: securityInformationReadOnly,
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
                                          readOnly: securityInformationReadOnly,
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
                                              if (selectedAgent!['agent_id'] !=
                                                  null) {
                                                securityInformationData[
                                                        'agent_id'] =
                                                    selectedAgent!['agent_id'];
                                              }
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
                                            }
                                          },
                                          buttonLabel: 'Save changes',
                                        ),
                                      ),
                                    ],
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
                                : SizedBox.shrink(),
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
                          if (optionData == AgentInoOption.assignedClients &&
                              assignedClients != null &&
                              selectedAgent != null)
                            Column(
                              children: List.generate(
                                assignedClients!.length,
                                (index) => Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            assignedClients![index]
                                                ['client_id'],
                                          ),
                                          Text(
                                            assignedClients![index]
                                                ['client_name'],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      AddMoreButton(
                                        onButtonPress: () async {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          // NOTE  Un Assign
                                          await ApiController.unAssignAgent(
                                            agentId: selectedAgent!['agent_id'],
                                            clientId: assignedClients![index]
                                                ['client_id'],
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(
                                                context,
                                                'Client has been un assigned.',
                                              );
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-agent-info-section-screens/${selectedAgent!['agent_id']}');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                        },
                                        buttonLabel: 'Un Assign',
                                        iconData: Icons.cancel,
                                      )
                                    ],
                                  ),
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
