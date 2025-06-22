import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/action_container_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_action_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_info_container.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/gallery_grid_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_user_info_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  CustomerDashboardOption dashboardOption = CustomerDashboardOption.dashboard;

  void changeDashboardOption(CustomerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
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
                          changeDashboardOption(
                            CustomerDashboardOption.listings,
                          );
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
                  DashboardUserInfoWidget(
                    userData: CustomerDashboardScreenController
                        .getCurrentUserInfoModel(),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
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
                          'Actions',
                          style: ThemeController.normalTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        ActionContainerWidget(
                          actionModel: CustomerDashboardScreenController
                              .getSampleActionModel(),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.86,
                    child: ListView(
                      children: [
                        // NOTE Agent Info
                        AgentInfoContainer(
                          agentData: CustomerDashboardScreenController
                              .getSampleAgentModel(),
                          onCallPress: () {},
                        ),
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
                          actionValue: 's.abdulkadhar11@gmail.com',
                          onActionPress: () {},
                        ),
                        AgentActionWidget(
                          actionName: 'Phone',
                          iconData: Icons.phone,
                          actionValue: '9080823869',
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
                                  actionValue: 'France',
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
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.86,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GalleryGridWidget(
                            imagePaths: CustomerDashboardScreenController
                                .propertyImagePaths,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          PropertyInfoSection(
                            propertyData: CustomerDashboardScreenController
                                .getSamplePropertyData.first,
                          )
                        ],
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
