import 'dart:convert';

import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_widget.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/controller/customer_property_listing_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_user_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/manager_property_unit_tile_widget.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/quick_action_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomerPropertyListingScreen extends StatefulWidget {
  final String clientId;
  const CustomerPropertyListingScreen({
    super.key,
    required this.clientId,
  });

  @override
  State<CustomerPropertyListingScreen> createState() =>
      _CustomerPropertyListingScreenState();
}

class _CustomerPropertyListingScreenState
    extends State<CustomerPropertyListingScreen> {
// NOTE STATE - Internal Page Option
  CustomerListingOption pageOption = CustomerListingOption.recommendation;

// NOTE STATE - Recommended List
  List<Map<String, dynamic>> recommendedList = [];
  List<Map<String, dynamic>> likedList = [];
  List<Map<String, dynamic>> unLikedList = [];

// NOTE Method - page option

  void changePageOption(CustomerListingOption option) {
    pageOption = option;
    setState(() {});
  }

// NOTE Method - Dashboard Option
  CustomerDashboardOption dashboardOption = CustomerDashboardOption.listings;
  void changeDashboardOption(CustomerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  void getDashboardData() async {
    await ApiController.getClientRecommendedProperties(
      customerId: widget.clientId,
      onError: (errorData) {
        print('Error occured');
      },
      onSuccess: (successData) {
        final responseData = jsonDecode(successData);
        recommendedList =
            List<Map<String, dynamic>>.from(responseData["all_properties"]);
        likedList =
            List<Map<String, dynamic>>.from(responseData["liked_properties"]);
        unLikedList = List<Map<String, dynamic>>.from(
            responseData["un_liked_properties"]);

        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getDashboardData();
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
                          context.go('/customer_dashboard_screen');
                          // changeDashboardOption(
                          //   CustomerDashboardOption.dashboard,
                          // );
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
                            '/customer-property-listing-screen/${widget.clientId}',
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
              // Currently Listed Property
              const SizedBox(
                height: 20,
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
                        QuickActionWidget(
                          label: 'Recommended Listings',
                          onPress: () {
                            changePageOption(
                              CustomerListingOption.recommendation,
                            );
                          },
                          isSelected: pageOption ==
                              CustomerListingOption.recommendation,
                          icons: Icons.list,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        QuickActionWidget(
                          label: 'Liked Listings',
                          onPress: () {
                            changePageOption(
                              CustomerListingOption.liked,
                            );
                          },
                          isSelected: pageOption == CustomerListingOption.liked,
                          icons: Icons.favorite,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        QuickActionWidget(
                          label: 'No list listings',
                          onPress: () {
                            changePageOption(
                              CustomerListingOption.noList,
                            );
                          },
                          isSelected:
                              pageOption == CustomerListingOption.noList,
                          icons: Icons.cancel,
                        ),
                      ],
                    ),
                  ),
                  // NOTE Empty Gap
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
                          if (pageOption ==
                              CustomerListingOption.recommendation)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Recommended listings",
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: List.generate(
                                      recommendedList.length, (index) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 280,
                                          child: CustomerPropertyInfoWidget(
                                            option: CustomerListingOption
                                                .recommendation,
                                            propertyInfo:
                                                recommendedList[index],
                                            onViewMorePress: () {
                                              // context.go(
                                              //   '/agent-property-info-screen/${widget.agentId}/${allProperties[index]['propertyId']}',
                                              // );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  }),
                                )
                              ],
                            ),
                          if (pageOption == CustomerListingOption.liked)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Liked listings",
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children:
                                      List.generate(likedList.length, (index) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 280,
                                          child: CustomerPropertyInfoWidget(
                                            option: CustomerListingOption.liked,
                                            propertyInfo: likedList[index],
                                            onViewMorePress: () {
                                              // context.go(
                                              //   '/agent-property-info-screen/${widget.agentId}/${allProperties[index]['propertyId']}',
                                              // );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  }),
                                )
                              ],
                            ),
                          if (pageOption == CustomerListingOption.noList)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "No list listings",
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: List.generate(unLikedList.length,
                                      (index) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: 280,
                                          child: CustomerPropertyInfoWidget(
                                            option:
                                                CustomerListingOption.noList,
                                            propertyInfo: unLikedList[index],
                                            onViewMorePress: () {
                                              // context.go(
                                              //   '/agent-property-info-screen/${widget.agentId}/${allProperties[index]['propertyId']}',
                                              // );
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  }),
                                )
                              ],
                            ),
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
