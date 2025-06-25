import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ClientQuickActionWidget extends StatelessWidget {
  final CustomerDataModel userData;
  final VoidCallback onProfilePress;
  final bool isSelected;
  const ClientQuickActionWidget({
    super.key,
    required this.userData,
    required this.onProfilePress,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 5),
        InkWell(
          onTap: onProfilePress,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 5,
            ),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: NetworkImage(userData.basicData.profileImg),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData.basicData.userName,
                      style: ThemeController.normalTextStyle(
                        fontWeight: FontWeight.w800,
                        size: 14,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      userData.basicData.designation,
                      style: ThemeController.normalTextStyle(
                        fontWeight: FontWeight.w400,
                        size: 13,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
