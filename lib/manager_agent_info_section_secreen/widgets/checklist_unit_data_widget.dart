import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/toggle_switch_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CheckListUnitDataWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isOn;
  final Function(bool) onTogglePress;
  final bool isEnabled;
  const CheckListUnitDataWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTogglePress,
    required this.isOn,
    this.isEnabled = true,
  });

  @override
  State<CheckListUnitDataWidget> createState() =>
      _CheckListUnitDataWidgetState();
}

class _CheckListUnitDataWidgetState extends State<CheckListUnitDataWidget> {
  bool _isOn = false;

  void setStatus(bool data) {
    _isOn = data;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setStatus(widget.isOn);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w900,
                color: _isOn ? Colors.green : Colors.grey,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              widget.subtitle,
              style: ThemeController.smallTextStyle(
                  fontWeight: FontWeight.w500,
                  color: _isOn ? Colors.green : Colors.grey),
            ),
          ],
        ),
        const Spacer(),
        ToggleSwitchWidget(
          isEnabled: widget.isEnabled,
          isOn: _isOn,
          onToggle: widget.isEnabled
              ? (data) {
                  _isOn = !_isOn;
                  setStatus(_isOn);
                  widget.onTogglePress(data);
                }
              : (data) {
                  print('false is pressed');
                },
        ),
      ],
    );
  }
}
