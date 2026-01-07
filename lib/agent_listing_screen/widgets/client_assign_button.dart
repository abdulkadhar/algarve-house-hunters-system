import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ClientAssignButton extends StatelessWidget {
  final String clientName;
  final bool isSelected;
  final VoidCallback onPress;
  const ClientAssignButton({
    super.key,
    required this.clientName,
    required this.isSelected,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSelected ? null : onPress,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        child: Row(
          children: [
            if (isSelected)
              const Icon(
                Icons.done,
                color: Colors.black,
                size: 14,
              ),
            if (isSelected)
              const SizedBox(
                width: 5,
              ),
            Text(
              clientName,
              style: ThemeController.smallTextStyle(
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
