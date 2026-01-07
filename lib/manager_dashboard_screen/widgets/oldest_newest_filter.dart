import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

enum OldestFilterOption {
  oldest,
  newest,
}

class OldestNewestFilter extends StatefulWidget {
  final Function(OldestFilterOption) getOptionData;
  const OldestNewestFilter({
    super.key,
    required this.getOptionData,
  });

  @override
  State<OldestNewestFilter> createState() => _OldestNewestFilterState();
}

class _OldestNewestFilterState extends State<OldestNewestFilter> {
  OldestFilterOption option = OldestFilterOption.newest;

  void setOldestFilterOption(OldestFilterOption data) {
    option = data;
    setState(() {});
  }

  Widget getContainerWidget(
      {required String label,
      required bool isSelected,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          label,
          style: ThemeController.normalTextStyle(
            color: isSelected ? Colors.white : Colors.black,
            size: 10,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          getContainerWidget(
            label: 'Oldest',
            isSelected: option == OldestFilterOption.oldest,
            onTap: () {
              setOldestFilterOption(OldestFilterOption.oldest);
              widget.getOptionData(option);
            },
          ),
          getContainerWidget(
            label: 'Newest',
            isSelected: option == OldestFilterOption.newest,
            onTap: () {
              setOldestFilterOption(OldestFilterOption.newest);
              widget.getOptionData(option);
            },
          ),
        ],
      ),
    );
  }
}
