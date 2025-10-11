import 'package:algarve_house_hunters_system/customer_preference_screen/widgets/selector_chip_container.dart';
import 'package:flutter/material.dart';

class SelectorGridWidget extends StatefulWidget {
  final List<String> optionsList;
  final Function(List<String>) getSelectedOptions;
  final bool isSelectOne;
  final double height;
  const SelectorGridWidget({
    super.key,
    required this.optionsList,
    required this.getSelectedOptions,
    this.isSelectOne = false,
    this.height = 400,
  });

  @override
  State<SelectorGridWidget> createState() => _SelectorGridWidgetState();
}

class _SelectorGridWidgetState extends State<SelectorGridWidget> {
  List<String> tempOption = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: MediaQuery.of(context).size.width * 0.6,
      child: GridView.count(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 3,
        children: List.generate(
          widget.optionsList.length,
          (index) => SelectorChipContainer(
            isSelected: tempOption.contains(widget.optionsList[index]),
            value: widget.optionsList[index],
            onSelectPress: () {
              if (widget.isSelectOne) {
                tempOption.clear();
                setState(() {});
              }
              if (tempOption.contains(widget.optionsList[index])) {
                tempOption.remove(widget.optionsList[index]);
              } else {
                tempOption.add(widget.optionsList[index]);
              }

              widget.getSelectedOptions(tempOption);
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
