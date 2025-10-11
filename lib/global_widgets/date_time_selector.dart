import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class DateTimeSelector extends StatefulWidget {
  final void Function(DateTime selectedDateTime) onDateTimeSelected;

  const DateTimeSelector({
    Key? key,
    required this.onDateTimeSelected,
  }) : super(key: key);

  @override
  State<DateTimeSelector> createState() => _DateTimeSelectorState();
}

class _DateTimeSelectorState extends State<DateTimeSelector> {
  DateTime? _selectedDateTime;

  Future<void> _pickDateTime(BuildContext context) async {
    // Step 1: Pick a date
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    // Step 2: Pick a time
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null
          ? TimeOfDay.fromDateTime(_selectedDateTime!)
          : TimeOfDay.now(),
    );

    if (time == null) return;

    // Step 3: Combine date and time
    final DateTime combined = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      _selectedDateTime = combined;
    });

    // Step 4: Fire callback
    widget.onDateTimeSelected(combined);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => _pickDateTime(context),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _selectedDateTime == null
                  ? 'Select date & time'
                  : "Selected: ${_selectedDateTime!.day}/${_selectedDateTime!.month}/${_selectedDateTime!.year} "
                      "${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}",
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
