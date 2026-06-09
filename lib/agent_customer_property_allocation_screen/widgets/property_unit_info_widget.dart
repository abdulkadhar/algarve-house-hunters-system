import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/property_info_container.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/property_model.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class PropertyUnitInfoWidget extends StatelessWidget {
  final Map<String, dynamic> propertyData;
  final bool isAssignButton;
  final VoidCallback? onTap;
  const PropertyUnitInfoWidget({
    super.key,
    required this.propertyData,
    this.isAssignButton = false,
    this.onTap,
  });

  // NOTE Fallback tile shown when there is no image or the image fails to load.
  Widget _imagePlaceholder(String message, IconData icon) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFEFEFEF),
        border: Border.all(
          color: Colors.grey,
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey, size: 28),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: ThemeController.smallTextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
              size: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List images =
        (propertyData['propertyImages'] as List?) ?? const [];
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 0.6,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                margin: const EdgeInsets.only(
                  bottom: 5,
                ),
                child: images.isEmpty
                    ? _imagePlaceholder(
                        'No image available',
                        Icons.image_not_supported_outlined,
                      )
                    : Image.network(
                        images[0].toString(),
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 130,
                            width: double.infinity,
                            color: const Color(0xFFEFEFEF),
                            child: const Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            _imagePlaceholder(
                          'Something went wrong',
                          Icons.broken_image_outlined,
                        ),
                      ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              propertyData['propertyName'],
              style: ThemeController.smallTextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              propertyData['propertyLocationName'],
              style: ThemeController.smallTextStyle(
                fontWeight: FontWeight.w500,
                size: 12,
              ),
            ),
            Text(
              propertyData['propertyPrice'],
              style: ThemeController.smallTextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                PropertyInfoContainer(
                  label: 'Beds: ${propertyData['bedsNumber']}',
                ),
                const SizedBox(
                  width: 3,
                ),
                PropertyInfoContainer(
                  label: 'Baths: ${propertyData['bathsNumber']}',
                )
              ],
            ),
            if (isAssignButton)
              const SizedBox(
                height: 10,
              ),
            if (isAssignButton)
              InkWell(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Assign',
                    style: ThemeController.smallTextStyle(
                      color: Colors.white,
                      size: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
