import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/model/unit_agent_checklist_model.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/toggle_switch_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CheckListUnitWidget extends StatefulWidget {
  final UnitAgentChecklistModel checkUnitData;
  final Function(bool) onTogglePress;
  const CheckListUnitWidget({
    super.key,
    required this.checkUnitData,
    required this.onTogglePress,
  });

  @override
  State<CheckListUnitWidget> createState() => _CheckListUnitWidgetState();
}

class _CheckListUnitWidgetState extends State<CheckListUnitWidget> {
  bool _isOn = false;

  void setStatus(bool data) {
    _isOn = data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.checkUnitData.title,
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w900,
                color: _isOn ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              widget.checkUnitData.description,
              style: ThemeController.smallTextStyle(
                  fontWeight: FontWeight.w500,
                  color: _isOn ? Colors.green : Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        ToggleSwitchWidget(
          onToggle: (data) {
            _isOn = !_isOn;
            setStatus(_isOn);
            widget.onTogglePress(data);
          },
        ),
      ],
    );
  }
}
