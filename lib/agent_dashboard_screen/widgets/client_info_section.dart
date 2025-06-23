import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/get_in_touch_button.dart';
import 'package:flutter/material.dart';

class ClientInfoSection extends StatelessWidget {
  final CustomerDataModel customerData;
  final VoidCallback? onProfilePress;
  const ClientInfoSection({
    super.key,
    required this.customerData,
    this.onProfilePress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeController.pageBackgroundSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Profile',
            style: ThemeController.normalTextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: DecorationImage(
                  image: NetworkImage(
                    customerData.basicData.profileImg,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              customerData.basicData.userName,
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              customerData.basicData.designation,
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w300,
                size: 14,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: GetInTouchButton(
              btnLabel: 'Proceed to profile',
              onBtnPress: onProfilePress,
            ),
          )
        ],
      ),
    );
  }
}
