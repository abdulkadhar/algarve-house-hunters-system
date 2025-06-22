import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/property_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/list_item_avatar.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_label_widget.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/property_info_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class PropertyInfoSection extends StatelessWidget {
  final PropertyModel propertyData;
  const PropertyInfoSection({
    super.key,
    required this.propertyData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const ListItemAvatar(
              iconData: Icons.location_on,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              propertyData.location,
              style: ThemeController.normalTextStyle(),
            ),
            const SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                print('Copy for the location is pressed !!!');
              },
              child: const Icon(
                Icons.copy,
                color: ThemeController.iconSecondaryColor,
              ),
            ),
            const Spacer(),
            Text(
              '€${propertyData.price}',
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w800,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            PropertyInfoLabelWidget(
              iconData: Icons.bar_chart,
              labelValue: 'Listing Ref: ${propertyData.listingRef}',
            ),
            const SizedBox(
              width: 10,
            ),
            PropertyInfoLabelWidget(
              iconData: Icons.bar_chart,
              labelValue: 'Property M2: ${propertyData.listingRef}',
            ),
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          children: [
            Text(
              "Overview",
              style: ThemeController.titleTextStyle(),
            ),
            const SizedBox(
              width: 10,
            ),
            CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey.withOpacity(0.4),
              child: Text(
                "5",
                style: ThemeController.smallTextStyle(
                  fontWeight: FontWeight.w900,
                  size: 16,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PropertyInfoWidget(
              iconData: Icons.bed,
              infoLabel: 'Bedroom',
              infoValue: propertyData.bedsNumber.toString(),
            ),
            const SizedBox(
              width: 20,
            ),
            PropertyInfoWidget(
              iconData: Icons.bed,
              infoLabel: 'Baths',
              infoValue: propertyData.bathsNumber.toString(),
            ),
            const SizedBox(
              width: 20,
            ),
            PropertyInfoWidget(
              iconData: Icons.bathroom,
              infoLabel: 'Plot number',
              infoValue: propertyData.plotNumber.toString(),
            ),
            const SizedBox(
              width: 20,
            ),
            PropertyInfoWidget(
              iconData: Icons.beach_access,
              infoLabel: 'Coast distance',
              infoValue: propertyData.distanceFromCoast.toString(),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PropertyInfoWidget(
              iconData: Icons.price_change,
              infoLabel: 'Price',
              infoValue: propertyData.price.toString(),
            ),
            const SizedBox(
              width: 20,
            ),
            PropertyInfoWidget(
              iconData: Icons.list,
              infoLabel: 'Listing Ref',
              infoValue: propertyData.bathsNumber.toString(),
            ),
            const SizedBox(
              width: 20,
            ),
            PropertyInfoWidget(
              iconData: Icons.bathroom,
              infoLabel: 'Property M2',
              infoValue: propertyData.propertyM2.toString(),
            ),
            const SizedBox(
              width: 20,
            ),
            PropertyInfoWidget(
              iconData: Icons.beach_access,
              infoLabel: 'Coast distance',
              infoValue: propertyData.distanceFromCoast.toString(),
            ),
          ],
        ),
      ],
    );
  }
}
