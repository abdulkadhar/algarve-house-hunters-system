import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/controller/customer_property_listing_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_unit_tile_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_user_info_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CustomerPropertyListingScreen extends StatefulWidget {
  const CustomerPropertyListingScreen({super.key});

  @override
  State<CustomerPropertyListingScreen> createState() =>
      _CustomerPropertyListingScreenState();
}

class _CustomerPropertyListingScreenState
    extends State<CustomerPropertyListingScreen> {
  CustomerDashboardOption dashboardOption = CustomerDashboardOption.listings;
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
                        isEnabled:
                            dashboardOption == CustomerDashboardOption.feedback,
                        iconData: Icons.assignment,
                        optionLabel: 'Feedback',
                        onTap: () {
                          changeDashboardOption(
                            CustomerDashboardOption.feedback,
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
              // Currently Listed Property
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeController.pageBackgroundSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Currently Listed Properties",
                      style: ThemeController.titleTextStyle(size: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            // PRoperty Title
                            List.generate(
                          CustomerPropertyListingScreenController
                              .recentlyAddedProperty.length,
                          (index) => PropertyUnitTileWidget(
                            propertyData:
                                CustomerPropertyListingScreenController
                                    .recentlyAddedProperty[index],
                            onViewMorePress: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Recommended Properties
              const SizedBox(
                height: 20,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height * 0.45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ThemeController.pageBackgroundSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recommended Properties",
                      style: ThemeController.titleTextStyle(size: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            // PRoperty Title
                            List.generate(
                          CustomerPropertyListingScreenController
                              .recentlyAddedProperty.length,
                          (index) => PropertyUnitTileWidget(
                            propertyData:
                                CustomerPropertyListingScreenController
                                    .recentlyAddedProperty[index],
                            onViewMorePress: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
