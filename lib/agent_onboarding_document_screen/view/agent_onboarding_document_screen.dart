import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_onboarding_document_screen/widgets/file_content_tile.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_screen/widgets/side_option_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AgentOnboardingDocumentScreen extends StatefulWidget {
  const AgentOnboardingDocumentScreen({super.key});

  @override
  State<AgentOnboardingDocumentScreen> createState() =>
      _AgentOnboardingDocumentScreenState();
}

class _AgentOnboardingDocumentScreenState
    extends State<AgentOnboardingDocumentScreen> {
  Map<String, dynamic>? filesData;
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.agents;
  void changeDashboardOption(ManagerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
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
                          isSelected: false,
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
                          isSelected: true,
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
                    child: filesData != null
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
                                Text(
                                  "Available Documents",
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
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
                        : Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width * 0.7,
                            decoration: BoxDecoration(
                              color:
                                  ThemeController.pageBackgroundSecondaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
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
