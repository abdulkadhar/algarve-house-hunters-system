import 'package:algarve_house_hunters_system/global_controller/global_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class FirstCallStatusLabelWidget extends StatelessWidget {
  final FirstCallStatusData status;
  final bool isSelected;
  final VoidCallback onPressed;
  const FirstCallStatusLabelWidget({
    super.key,
    required this.status,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? GlobalController.getFirstCallStatusColor(status)
                : Colors.grey,
            width: 0.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: isSelected
                    ? GlobalController.getFirstCallStatusColor(status)
                    : Colors.grey,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: isSelected
                      ? GlobalController.getFirstCallStatusColor(status)
                      : Colors.grey,
                  width: 0.1,
                ),
              ),
            ),

            // NOTE Empty Space
            const SizedBox(
              width: 10,
            ),
            Text(
              GlobalController.getFirstCallStatusLabel(status),
              style: ThemeController.titleTextStyle(
                size: 16,
                color: isSelected
                    ? GlobalController.getFirstCallStatusColor(status)
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
