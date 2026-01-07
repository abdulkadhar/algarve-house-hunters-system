import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:timezone/timezone.dart' as tz;

class DateTimeInlineScheduler extends StatefulWidget {
  final Function(String) getMeetingTime;
  const DateTimeInlineScheduler({
    super.key,
    required this.getMeetingTime,
  });
  @override
  State<DateTimeInlineScheduler> createState() =>
      _DateTimeInlineSchedulerState();
}

class _DateTimeInlineSchedulerState extends State<DateTimeInlineScheduler> {
  DateTime selectedDate = DateTime.now();
  String? selectedTime; // e.g., '2:30 PM'
  String selectedTimezone = 'UTC';

  final List<String> timezones = [
    'UTC',
    'Asia/Kolkata',
    'Europe/London',
    'America/New_York',
    'Asia/Tokyo',
    'Australia/Sydney',
  ];

  // Fixed time options
  final List<String> timeOptions = [
    '2:30 PM',
    '3:30 PM',
    '9:30 PM',
    '10:30 PM',
  ];

  /// Parse time option to DateTime (for today)
  DateTime parseTimeOption(String timeLabel, DateTime date) {
    final parsed = DateFormat('h:mm a').parse(timeLabel);
    return DateTime(
        date.year, date.month, date.day, parsed.hour, parsed.minute);
  }

  /// Get filtered time slots based on selected date & current time
  List<String> getAvailableTimeOptions() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // if selected date is today, remove past slots
    if (DateTime(selectedDate.year, selectedDate.month, selectedDate.day) ==
        today) {
      return timeOptions.where((label) {
        final slotDateTime = parseTimeOption(label, selectedDate);
        return slotDateTime.isAfter(now);
      }).toList();
    } else {
      // future date, keep all
      return timeOptions;
    }
  }

  String formatWithTimezone(DateTime date, String time, String timezone) {
    try {
      final localParsed = DateFormat('h:mm a').parse(time);
      final dt = DateTime(date.year, date.month, date.day, localParsed.hour,
          localParsed.minute);
      final location = tz.getLocation(timezone);
      final tzDateTime = tz.TZDateTime.from(dt, location);
      return DateFormat('yyyy-MM-dd hh:mm a').format(tzDateTime) +
          ' ($timezone)';
    } catch (e) {
      return '$time ($timezone)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final availableSlots = getAvailableTimeOptions();

    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Always visible calendar
          CalendarDatePicker(
            initialDate: selectedDate.isBefore(today) ? today : selectedDate,
            firstDate: today,
            lastDate: today.add(Duration(days: 365 * 2)),
            onDateChanged: (date) {
              setState(() {
                selectedDate = date;
                selectedTime = null; // reset time if date changes
              });
            },
          ),
          SizedBox(height: 16),

          // Single time selector
          Column(
            children: [
              Text('Select Time'),
              DropdownButton<String>(
                hint: Text('Select'),
                value: selectedTime,
                onChanged: (value) {
                  setState(() {
                    selectedTime = value;
                  });
                  widget.getMeetingTime(
                    'Date: ${selectedDate.toString()} Time: $selectedTime TimeZone:$selectedTimezone',
                  );
                },
                items: availableSlots.isNotEmpty
                    ? availableSlots
                        .map((slot) =>
                            DropdownMenuItem(value: slot, child: Text(slot)))
                        .toList()
                    : [
                        DropdownMenuItem(
                            value: null,
                            child: Text('No slots available today'))
                      ],
              ),
            ],
          ),
          SizedBox(height: 16),

          // Timezone selector
          DropdownButton<String>(
            value: selectedTimezone,
            onChanged: (value) {
              setState(() {
                selectedTimezone = value!;
              });
              widget.getMeetingTime(
                'Date: ${selectedDate.toString()} Time: $selectedTime TimeZone:$selectedTimezone',
              );
            },
            items: timezones.map((tz) {
              return DropdownMenuItem(value: tz, child: Text(tz));
            }).toList(),
          ),
          SizedBox(height: 16),

          if (selectedTime != null)
            Text(
              'Scheduled: ${formatWithTimezone(selectedDate, selectedTime!, selectedTimezone)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}
