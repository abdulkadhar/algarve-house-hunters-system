import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class SelectorChipContainer extends StatefulWidget {
  final String value;
  final bool isSelected;
  final VoidCallback onSelectPress;
  const SelectorChipContainer({
    super.key,
    required this.value,
    required this.isSelected,
    required this.onSelectPress,
  });

  @override
  State<SelectorChipContainer> createState() => _SelectorChipContainerState();
}

class _SelectorChipContainerState extends State<SelectorChipContainer> {
  @override
  void initState() {
    super.initState();
    // initialiseSelectState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onSelectPress();
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.isSelected ? Colors.black : Colors.grey,
            width: 1,
          ),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.isSelected)
              const Icon(
                Icons.done,
                color: Colors.black,
                size: 14,
              ),
            if (widget.isSelected)
              const SizedBox(
                width: 5,
              ),
            Expanded(
              child: Text(
                widget.value,
                style: ThemeController.smallTextStyle(
                    color: widget.isSelected ? Colors.black : Colors.grey),
              ),
            )
          ],
        ),
      ),
    );
  }
}
