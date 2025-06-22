import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class GetInTouchButton extends StatelessWidget {
  final VoidCallback? onBtnPress;
  final String btnLabel;
  final Color bgColor;
  final Color labelColor;
  const GetInTouchButton({
    super.key,
    required this.onBtnPress,
    required this.btnLabel,
    this.bgColor = Colors.black,
    this.labelColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBtnPress,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.all(10),
        child: Text(
          btnLabel,
          style: ThemeController.smallTextStyle(
            color: labelColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
