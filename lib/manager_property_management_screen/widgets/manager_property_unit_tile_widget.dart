import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_feature_card.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_info_carousel.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ManagerPropertyUnitTileWidget extends StatelessWidget {
  final Map<String, dynamic> propertyInfo;
  final VoidCallback onViewMorePress;
  final VoidCallback? onCarouselPress;
  const ManagerPropertyUnitTileWidget({
    super.key,
    required this.propertyInfo,
    required this.onViewMorePress,
    this.onCarouselPress,
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
          if (propertyInfo["propertyImages"].isEmpty)
            Container(
              height: double.infinity,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  "No Image Data",
                  style: ThemeController.normalTextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (propertyInfo["propertyImages"].isNotEmpty)
            InkWell(
              onTap: onCarouselPress,
              child: PropertyInfoCarousel(
                imagePaths: List<String>.from(
                  propertyInfo["propertyImages"],
                ),
              ),
            ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  propertyInfo["propertyName"],
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
                      propertyInfo["propertyLocationName"],
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
                      featureValue: propertyInfo["bedsNumber"],
                    ),
                    PropertyFeatureCard(
                      featureName: 'Baths',
                      featureValue: propertyInfo["bathsNumber"],
                    ),
                    PropertyFeatureCard(
                      featureName: 'Coastal distance',
                      featureValue: '${propertyInfo["distanceFromCoast"]} mins',
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  propertyInfo["propertyDescription"],
                  style: ThemeController.smallTextStyle(
                    size: 10,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Text(
                      'Created By:',
                      style: ThemeController.smallTextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      propertyInfo["createdBy"],
                      style: ThemeController.smallTextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
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
                      '€${propertyInfo["propertyPrice"]}',
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
