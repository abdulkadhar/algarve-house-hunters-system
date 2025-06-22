import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/dashboard_user_info_model.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class DashboardUserInfoWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final DashboardUserInfoModel userData;
  const DashboardUserInfoWidget({
    super.key,
    required this.userData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              userData.profileImg,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData.userName,
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                userData.designation,
                style: ThemeController.smallTextStyle(
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
