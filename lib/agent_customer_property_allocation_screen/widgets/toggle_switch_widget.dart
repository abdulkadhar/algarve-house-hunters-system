import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ToggleSwitchWidget extends StatefulWidget {
  final bool isOn;
  final Function(bool) onToggle;
  const ToggleSwitchWidget({
    super.key,
    this.isOn = false,
    required this.onToggle,
  });

  @override
  State<ToggleSwitchWidget> createState() => _ToggleSwitchWidgetState();
}

class _ToggleSwitchWidgetState extends State<ToggleSwitchWidget> {
  bool _isOn = false;

  void setStatus(bool data) {
    _isOn = data;
    setState(() {});
  }

  @override
  void initState() {
    setStatus(widget.isOn);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _isOn = !_isOn;
        setState(() {});
        // setStatus(_isOn);
        widget.onToggle(_isOn);
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          border: Border.all(
            color: _isOn ? Colors.green : Colors.grey,
            width: 0.4,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: _isOn
            ? Row(
                children: [
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    'Completed',
                    style: ThemeController.smallTextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.green,
                  ),
                  const SizedBox(
                    width: 3,
                  )
                ],
              )
            : Row(
                children: [
                  CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    'Not Started',
                    style: ThemeController.smallTextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  )
                ],
              ),
      ),
    );
  }
}
