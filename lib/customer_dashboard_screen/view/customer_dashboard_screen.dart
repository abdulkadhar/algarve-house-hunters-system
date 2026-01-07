import 'dart:convert';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/agent_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/manager_gallery_widget.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/dashboard_user_info_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_action_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_section.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/agent_info_sectIon.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerDashboardScreen extends StatefulWidget {
  final String clientId;
  const CustomerDashboardScreen({
    super.key,
    required this.clientId,
  });

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  // NOTE STATE User info
  Map<String, dynamic>? userInfo;
  // NOTE STATE Agent Info
  List<dynamic>? assignedAgent = [];
  Map<String, dynamic>? selectedAgent;
  CustomerDataModel selectedUserData =
      AgentDashboardScreenController.getSampleAssignedUserModel().first;
  CustomerDashboardOption dashboardOption = CustomerDashboardOption.dashboard;

  void changeDashboardOption(CustomerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  Map<String, dynamic>? latestPropertyData;

  void getLatestPropertyData() async {
    await ApiController.getLatestPropertyData(
      onSuccess: (data) {
        latestPropertyData = jsonDecode(data);
        setState(() {});
      },
      onError: (data) {},
    );
  }

// NOTE API CALL - User Info GET
  void getUserInfo() async {
    await ApiController.getClientInfoByID(
      widget.clientId,
      onSuccess: (successData) {
        final responseData = jsonDecode(successData);
        userInfo = responseData;
        setState(() {});
      },
      onError: (errorData) {
        setState(() {});
      },
    );
  }

  void getAssignedAgents() async {
    await ApiController.getAvailableAgents(
      widget.clientId,
      onError: (errorData) {
        setState(() {});
      },
      onSuccess: (successData) {
        assignedAgent = jsonDecode(successData)['assigned_agents'];
        if (assignedAgent != null && assignedAgent!.isNotEmpty) {
          selectedAgent = assignedAgent![0];
        }
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getLatestPropertyData();
    getUserInfo();
    getAssignedAgents();
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
                        isEnabled: dashboardOption ==
                            CustomerDashboardOption.dashboard,
                        iconData: Icons.dashboard,
                        optionLabel: 'Dashboard',
                        onTap: () {
                          changeDashboardOption(
                            CustomerDashboardOption.dashboard,
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == CustomerDashboardOption.listings,
                        iconData: Icons.list,
                        optionLabel: 'Listings',
                        onTap: () {
                          context.go(
                            '/customer-property-listing-screen/${widget.clientId}',
                          );
                          // changeDashboardOption(
                          //   CustomerDashboardOption.listings,
                          // );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled: dashboardOption ==
                            CustomerDashboardOption.favorites,
                        iconData: Icons.assignment,
                        optionLabel: 'Favorites',
                        onTap: () {
                          changeDashboardOption(
                            CustomerDashboardOption.favorites,
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (userInfo != null)
                    DashboardUserInfoWidget(
                      userData: DashboardUserInfoModel(
                        designation: userInfo!['client_id'],
                        profileImg: userInfo!['client_profile_pic'],
                        userName: userInfo!['client_name'],
                        userId: userInfo!['client_profile_pic'],
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NOTE Action Section
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
                          'Assigned Agents',
                          style: ThemeController.normalTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (assignedAgent != null && assignedAgent!.isNotEmpty)
                          Column(
                            children:
                                List.generate(assignedAgent!.length, (index) {
                              return AgentQuickActionWidget(
                                isSelected: selectedAgent!['agent_id'] ==
                                    assignedAgent![index]['agent_id'],
                                userData: assignedAgent![index],
                                onProfilePress: () {
                                  selectedAgent = assignedAgent![index];
                                  setState(() {});
                                },
                              );
                            }),
                          )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Column(
                      children: [
                        // NOTE Agent Info
                        // TODO Alter this
                        AgentInfoSection(
                          agentData: AgentModel(
                            agentName: selectedAgent!['agent_name'],
                            agentDesignation:
                                selectedAgent!['agent_designation'],
                            status: CustomerDashboardScreenController
                                .getAgentStatusEnum(
                              selectedAgent!['agent_availability_status'],
                            ),
                            agentDescription:
                                selectedAgent!['agent_description'],
                            profileImgPath: selectedAgent!['agent_profile_pic'],
                          ),
                        ),
                        // ClientInfoSection(
                        //   clientData: {},
                        // ),
                        const SizedBox(
                          height: 25,
                        ),

                        AgentActionWidget(
                          actionName: 'Company',
                          iconData: Icons.cases,
                          actionValue: 'House Hunter',
                          onActionPress: () {},
                        ),
                        AgentActionWidget(
                          actionName: 'Email',
                          iconData: Icons.mail,
                          actionValue: selectedAgent!['agent_email_address'],
                          onActionPress: () {},
                        ),
                        AgentActionWidget(
                          actionName: 'Phone',
                          iconData: Icons.phone,
                          actionValue: selectedAgent!['agent_phone_number'],
                          onActionPress: () {},
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: (MediaQuery.of(context).size.height * 0.86) *
                              0.33,
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                AssetsController.mapRefImg,
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: AgentActionWidget(
                                  actionName: 'Location',
                                  iconData: Icons.location_city,
                                  actionValue:
                                      selectedAgent!['agent_location_name'],
                                  onActionPress: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.48,
                    height: MediaQuery.of(context).size.height * 0.86,
                    child: SingleChildScrollView(
                      child: latestPropertyData == null
                          ? const Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ManagerGalleryWidget(
                                  onPress: () {
                                    final List<String> urls =
                                        (latestPropertyData!["propertyImages"]
                                                as List)
                                            .cast<String>();
                                    GlobalWidgets.showImageViewerDialog(
                                      context,
                                      imageUrls: urls,
                                      title: "Property glance",
                                    );
                                  },
                                  // imagePaths: CustomerDashboardScreenController
                                  //     .propertyImagePaths,
                                  imagePaths:
                                      latestPropertyData!["propertyImages"],
                                  width: (MediaQuery.of(context).size.width *
                                          0.5) *
                                      0.67,
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                PropertyInfoSection(
                                  // propertyData:
                                  //     CustomerDashboardScreenController
                                  //         .getSamplePropertyData.first,
                                  propertyData: latestPropertyData!,
                                )
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
