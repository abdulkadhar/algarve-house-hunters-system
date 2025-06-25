import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/controller/agent_controller_property_allocation_controller.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/get_in_touch_button.dart';
import 'package:flutter/material.dart';

class CustomerInfoSection extends StatelessWidget {
  final CustomerDataModel customerData;
  final AssignmentStatus assignmentStatus;
  final VoidCallback onPress;
  const CustomerInfoSection({
    super.key,
    required this.customerData,
    required this.assignmentStatus,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
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
              'User Profile',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetInTouchButton(
                  btnLabel: assignmentStatus == AssignmentStatus.assign
                      ? 'Assign'
                      : 'Unassign',
                  onBtnPress: onPress,
                  bgColor: assignmentStatus == AssignmentStatus.assign
                      ? Colors.green
                      : Colors.red,
                  borderColor: assignmentStatus == AssignmentStatus.assign
                      ? Colors.green
                      : Colors.grey,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
