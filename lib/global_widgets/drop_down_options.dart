import 'package:flutter/material.dart';

class HighlightDropdown extends StatefulWidget {
  final Map<String, dynamic> apiResponse;
  final Function(String) onOptionChanged;

  const HighlightDropdown({
    super.key,
    required this.apiResponse,
    required this.onOptionChanged,
  });

  @override
  State<HighlightDropdown> createState() => _HighlightDropdownState();
}

class _HighlightDropdownState extends State<HighlightDropdown> {
  String? selectedValue;
  late List<String> options;

  @override
  void initState() {
    super.initState();
    // Extract clientIds safely
    options = List<String>.from(widget.apiResponse['clientIds'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedValue,
      hint: const Text("Select an option"),
      isExpanded: true,
      items: options.map((String value) {
        final bool isSelected = value == selectedValue;
        return DropdownMenuItem<String>(
          value: value,
          child: Container(
            padding: const EdgeInsets.all(8),
            color: isSelected ? Colors.black12 : Colors.transparent,
            child: Text(
              value,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        if (newValue != null && newValue.isNotEmpty) {
          widget.onOptionChanged(newValue);
        }
      },
    );
  }
}
