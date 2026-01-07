import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/property_model.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_feature_card.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_user_info_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/agent_info_sectIon.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/home_tour_request_section.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/property_slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnitPropertyInfoScreen extends StatefulWidget {
  final PropertyModel propertyData;
  const UnitPropertyInfoScreen({
    super.key,
    required this.propertyData,
  });

  @override
  State<UnitPropertyInfoScreen> createState() => _UnitPropertyInfoScreenState();
}

class _UnitPropertyInfoScreenState extends State<UnitPropertyInfoScreen> {
  CustomerDashboardOption dashboardOption = CustomerDashboardOption.favorites;

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
                          // changeDashboardOption(
                          //   CustomerDashboardOption.listings,
                          // );
                          context.go(
                            '/customer-property-listing-screen',
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
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeController.pageBackgroundSecondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PropertySliderWidget(
                          imagePaths: CustomerDashboardScreenController
                              .getSamplePropertyData.first.propertyImages,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // NOTE property name
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Property Name",
                                    style: ThemeController.titleTextStyle(),
                                  ),
                                  const Spacer(),
                                  Text(
                                    "200 Million",
                                    style: ThemeController.titleTextStyle(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.blue,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Sample location",
                                    style: ThemeController.normalTextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "sample description",
                                style: ThemeController.smallTextStyle(),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              const Row(
                                children: [
                                  const PropertyFeatureCard(
                                    bgColor: Colors.white,
                                    featureName: 'Beds',
                                    featureValue: '3',
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const PropertyFeatureCard(
                                    bgColor: Colors.white,
                                    featureName: 'Baths',
                                    featureValue: '3',
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const PropertyFeatureCard(
                                    bgColor: Colors.white,
                                    featureName: 'Coastal distance',
                                    featureValue: '30 mins',
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const PropertyFeatureCard(
                                    bgColor: Colors.white,
                                    featureName: 'Sq.ft',
                                    featureValue: '600 Sq.ft',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // NOTE Agent Info
                        AgentInfoSection(
                          agentData: CustomerDashboardScreenController
                              .getSampleAgentModel(),
                        ),
                        const SizedBox(height: 10),
                        HomeTourRequestSection(
                          requestData: CustomerDashboardScreenController
                              .getSampleHomeTourRequestModel(),
                        )
                      ],
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
