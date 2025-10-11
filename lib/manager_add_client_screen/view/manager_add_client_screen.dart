import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_values_display_widget.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/widgets/side_option_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/manager_add_client_screen/model/form_response.dart';
import 'package:algarve_house_hunters_system/manager_add_client_screen/widget/collapsable_answer_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

enum ClientHandlingOption {
  addClient,
  jotformSubmission,
}

class ManagerAddClientScreen extends StatefulWidget {
  const ManagerAddClientScreen({super.key});

  @override
  State<ManagerAddClientScreen> createState() => _ManagerAddClientScreenState();
}

class _ManagerAddClientScreenState extends State<ManagerAddClientScreen> {
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.clients;
  ClientHandlingOption clientOption = ClientHandlingOption.addClient;

  void changeClientOption(ClientHandlingOption option) {
    clientOption = option;
    setState(() {});
  }

  void changeDashboardOption(ManagerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  String? clientId;
  Map<String, dynamic>? submissionData;

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

  void getJotFormSubmission() async {
    await ApiController.getJotFormData(
      onSuccess: (successData) {
        submissionData = jsonDecode(successData);
        setState(() {});
      },
      onError: (errorData) {
        ManagerLogInScreenController.showError(
            context, 'Error in fetching jotform submissions !!!');
      },
    );
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

  @override
  void initState() {
    super.initState();
    getCurrentClientId();
    getJotFormSubmission();
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
                          isSelected:
                              clientOption == ClientHandlingOption.addClient,
                          label: "Add new client",
                          onTap: () {
                            changeClientOption(ClientHandlingOption.addClient);
                            // context.go(
                            //   '/manager-agent-onboarding',
                            // );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SideOptionButton(
                          iconData: Icons.add,
                          isSelected: clientOption ==
                              ClientHandlingOption.jotformSubmission,
                          label: "Jot form submissions",
                          onTap: () {
                            changeClientOption(
                                ClientHandlingOption.jotformSubmission);
                            // context.go(
                            //   '/manager-agent-onboarding',
                            // );
                          },
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
                      child: clientOption ==
                              ClientHandlingOption.jotformSubmission
                          ? submissionData != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: List.generate(
                                      submissionData!["submissions"].length,
                                      (index) {
                                    return SizedBox(
                                      // height: 300,
                                      // child: Text(
                                      //   submissionData!["submissions"][index]
                                      //           ["answers"]["11"]["text"] ??
                                      //       'sample',
                                      // ),
                                      child: ExpansionTile(
                                        title: Text(
                                            submissionData!["submissions"]
                                                        [index]["answers"]["28"]
                                                    ["answer"] ??
                                                'No value'),
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0,
                                              vertical: 20.0,
                                            ),
                                            child: Column(
                                              children: [
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: 'Status',
                                                  labelValue: submissionData![
                                                              "submissions"]
                                                          [index]["status"] ??
                                                      '',
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["11"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["11"]["answer"] ??
                                                      'No Response',
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["12"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["12"]["answer"] ??
                                                      'No Response',
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["20"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["20"]["answer"] ??
                                                      'No Response',
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                // UserPreferenceValuesDisplayWidget(
                                                //   labelName: submissionData![
                                                //                   "submissions"]
                                                //               [index]["answers"]
                                                //           ["21"]["text"] ??
                                                //       'place holder value',
                                                //   labelValue: submissionData![
                                                //                   "submissions"]
                                                //               [index]["answers"]
                                                //           ["21"]["answer"] ??
                                                //       'No Response',
                                                //   labelWidth:
                                                //       MediaQuery.of(context)
                                                //               .size
                                                //               .width *
                                                //           0.4,
                                                // ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["26"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["26"]["answer"] ??
                                                      'No Response',
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["28"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["28"]["answer"] ??
                                                      'No Response',
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["29"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["29"]["answer"] ??
                                                      'No Response',
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["30"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["30"]["answer"] ??
                                                      'No Response',
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["31"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["31"]["answer"] ??
                                                      'No Response',
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["33"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["33"]["answer"] ??
                                                      'No Response',
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["34"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["34"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["35"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["35"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["36"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["36"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["38"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["38"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["39"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["39"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["40"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["40"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["41"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["41"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["42"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["42"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["43"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["43"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["44"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["44"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["45"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["45"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["46"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["46"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["47"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["47"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["50"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["50"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["51"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["51"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["52"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["52"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["53"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["53"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["54"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["54"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["57"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["57"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["55"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["55"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["58"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["58"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["62"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["62"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["63"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["63"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                // NOTE Signatur image is loading due to jotform error
                                                // const SizedBox(
                                                //   height: 10,
                                                // ),
                                                // UserPreferenceValuesDisplayWidget(
                                                //   labelName: 'Signature',
                                                //   labelValue: submissionData![
                                                //                   "submissions"]
                                                //               [index]["answers"]
                                                //           ["64"]["answer"]
                                                //       .toString(),
                                                //   isImage: true,
                                                //   labelWidth:
                                                //       MediaQuery.of(context)
                                                //               .size
                                                //               .width *
                                                //           0.4,
                                                // ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["67"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["67"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["68"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["68"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["69"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["69"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["70"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["70"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["71"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["71"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                                UserPreferenceValuesDisplayWidget(
                                                  labelName: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["72"]["text"] ??
                                                      'place holder value',
                                                  labelValue: submissionData![
                                                                  "submissions"]
                                                              [index]["answers"]
                                                          ["72"]["answer"]
                                                      .toString(),
                                                  labelWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      // child: RightPaneSubmissionsAccordion(
                                      //   formResponse: FormResponse.fromJson(
                                      //     submissionData!,
                                      //   ),
                                      // ),
                                    );
                                  }),
                                )
                              : const SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                          : clientId != null
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                                          'client_name'] =
                                                      agentName;
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
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
