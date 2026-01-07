import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class OptionLabelSelectorWidget extends StatelessWidget {
  final String optionLabel;
  final VoidCallback onPress;
  final bool isEnabled;
  final Color enabledBorderColor;
  final Color disabledBorderColor;
  final Color enabledTextColor;
  final Color disabledTextColor;
  const OptionLabelSelectorWidget({
    super.key,
    required this.isEnabled,
    required this.onPress,
    required this.optionLabel,
    this.enabledBorderColor = Colors.black,
    this.disabledBorderColor = Colors.grey,
    this.enabledTextColor = Colors.black,
    this.disabledTextColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isEnabled ? enabledBorderColor : disabledBorderColor,
          ),
        ),
        child: Text(
          optionLabel,
          style: ThemeController.smallTextStyle(
            size: 12,
            fontWeight: FontWeight.w900,
            color: isEnabled ? enabledTextColor : disabledTextColor,
          ),
        ),
      ),
    );
  }
}
