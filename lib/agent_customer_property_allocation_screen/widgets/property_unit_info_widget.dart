import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/property_info_container.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/property_model.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class PropertyUnitInfoWidget extends StatelessWidget {
  final PropertyModel propertyData;
  final bool isAssignButton;
  const PropertyUnitInfoWidget({
    super.key,
    required this.propertyData,
    this.isAssignButton = false,
  });

  @override
  Widget build(BuildContext context) {
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
                child: Image.network(
                  propertyData.propertyImages.first,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              propertyData.propertyName,
              style: ThemeController.smallTextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              propertyData.location,
              style: ThemeController.smallTextStyle(
                fontWeight: FontWeight.w500,
                size: 12,
              ),
            ),
            Text(
              propertyData.price.toString(),
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
                  label: 'Beds: ${propertyData.bedsNumber}',
                ),
                const SizedBox(
                  width: 3,
                ),
                PropertyInfoContainer(
                  label: 'Baths: ${propertyData.bathsNumber}',
                )
              ],
            ),
            if (isAssignButton)
              const SizedBox(
                height: 10,
              ),
            if (isAssignButton)
              Container(
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
              )
          ],
        ),
      ),
    );
  }
}
