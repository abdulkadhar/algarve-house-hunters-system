import 'package:flutter/material.dart';

class ListItemAvatar extends StatelessWidget {
  final IconData iconData;
  final Color borderColor;
  final Color bgColor;
  final Color iconColor;
  final double borderWidth;

  const ListItemAvatar({
    super.key,
    required this.iconData,
    this.borderColor = Colors.grey,
    this.bgColor = Colors.white,
    this.iconColor = Colors.grey,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: Icon(
        iconData,
        color: iconColor,
      ),
    );
  }
}
