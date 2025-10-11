import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/property_model.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_feature_card.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_info_carousel.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class PropertyUnitTileWidget extends StatelessWidget {
  final PropertyModel propertyData;
  final VoidCallback onViewMorePress;
  const PropertyUnitTileWidget({
    super.key,
    required this.propertyData,
    required this.onViewMorePress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          PropertyInfoCarousel(
            imagePaths: propertyData.propertyImages,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Property Title',
                  style: ThemeController.titleTextStyle(
                    size: 18,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      'Location',
                      style: ThemeController.smallTextStyle(),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    PropertyFeatureCard(
                      featureName: 'Bedroom',
                      featureValue: propertyData.bedsNumber.toString(),
                    ),
                    PropertyFeatureCard(
                      featureName: 'Baths',
                      featureValue: propertyData.bathsNumber.toString(),
                    ),
                    PropertyFeatureCard(
                      featureName: 'Coastal distabce',
                      featureValue:
                          '${propertyData.distanceFromCoast.toString()} mins',
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  propertyData.propertyDescription,
                  style: ThemeController.smallTextStyle(size: 10),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      'Price:',
                      style: ThemeController.smallTextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '€${propertyData.price}',
                      style: ThemeController.smallTextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                    InkWell(
                      onTap: onViewMorePress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "View Details",
                          style: ThemeController.smallTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
