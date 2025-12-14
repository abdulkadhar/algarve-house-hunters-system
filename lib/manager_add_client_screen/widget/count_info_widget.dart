import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CountInfoWidget extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color iconBgColor;
  const CountInfoWidget({
    super.key,
    required this.count,
    required this.label,
    this.icon = Icons.add,
    this.iconBgColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: iconBgColor,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 15,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                label,
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            count.toString(),
            style: ThemeController.titleTextStyle(
              size: 30,
            ),
          )
        ],
      ),
    );
  }
}
