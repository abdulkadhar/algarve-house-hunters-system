import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AssignedUserInfoWidget extends StatelessWidget {
  final int indexNumber;
  const AssignedUserInfoWidget({
    super.key,
    required this.indexNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 15,
            child: Text(
              indexNumber.toString(),
              style: ThemeController.normalTextStyle(
                color: Colors.white,
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
                "Client Name",
                style: ThemeController.smallTextStyle(
                  fontWeight: FontWeight.w600,
                  size: 16,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                'Client Comments',
                style: ThemeController.smallTextStyle(
                  size: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Scheduled Time: 27 October 25, 09:00 PM',
                style: ThemeController.smallTextStyle(
                  size: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Duration: 30 Mins',
                style: ThemeController.smallTextStyle(
                  size: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Agent Name: Sample Agent',
                style: ThemeController.smallTextStyle(
                  size: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
