import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

enum FirstCallStatusData {
  notStarted,
  accepted,
  rejected,
  cancelled,
}

class GlobalController {
  static String getPreferenceFormatter(String data) {
    if (data == "[]" || data == "") {
      return "None";
    } else {
      if (data.contains("[")) {
        return data.substring(1, data.length - 1);
      }
      return data;
    }
  }

  // SECTION
  /// Single entry point – handles all 3 formats as String.
  static String formatAppointment(String input) {
    final trimmed = input.trim();

    // Type 3 – map-like string: {implementation: ..., date: ..., duration: ..., timezone: ...}
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      return _formatType3MapString(trimmed);
    }

    // Type 1 – "yyyy-MM-dd HH:mm Europe/London (GMT+01:00)"
    if (_looksLikeType1(trimmed)) {
      return _formatType1(trimmed);
    }

    // Type 2 – "Saturday, Aug 23, 2025 11:00 AM-12:00 PM - Europe/London Time"
    if (_looksLikeType2(trimmed)) {
      return _formatType2(trimmed);
    }

    // Fallback
    return input;
  }

  // ---------- TYPE DETECTION (string) ----------

  static bool _looksLikeType1(String input) {
    // e.g. "2025-09-02 17:00 Europe/London (GMT+01:00)"
    return RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2} ').hasMatch(input);
  }

  static bool _looksLikeType2(String input) {
    // crude but works for:
    // "Saturday, Aug 23, 2025 11:00 AM-12:00 PM - Europe/London Time"
    return input.contains('- Europe') && input.contains(',');
  }

  // ---------- TYPE 1 ----------

  /// "2025-09-02 17:00 Europe/London (GMT+01:00)"
  static String _formatType1(String input) {
    try {
      final parts = input.split(' ');
      // 0: 2025-09-02
      // 1: 17:00
      // 2: Europe/London
      // 3: (GMT+01:00) (optional)
      final datePart = '${parts[0]} ${parts[1]}';
      final tzName = parts[2]; // "Europe/London"

      final dt = DateFormat('yyyy-MM-dd HH:mm').parse(datePart);
      final formatted = DateFormat('EEE, MMM d · h:mm a').format(dt);
      return '$formatted ($tzName)';
    } catch (_) {
      return input;
    }
  }

  // ---------- TYPE 2 ----------

  /// "Saturday, Aug 23, 2025 11:00 AM-12:00 PM - Europe/London Time"
  static String _formatType2(String input) {
    try {
      final parts = input.split(' - ');
      final main = parts[0]; // "Saturday, Aug 23, 2025 11:00 AM-12:00 PM"
      final tzName = parts.length > 1 ? parts[1] : ''; // "Europe/London Time"

      final mainParts = main.split(' ');
      // Example: ["Saturday,", "Aug", "23,", "2025", "11:00", "AM-12:00", "PM"]

      // Date: "Aug 23, 2025"
      final dateStr = mainParts.sublist(1, 4).join(' ');
      // Time range: "11:00 AM-12:00 PM"
      final timeRange =
          main.substring(main.indexOf(dateStr) + dateStr.length).trim();
      final timeRangeClean = timeRange.replaceFirst(',', '').trim();

      final timePieces = timeRangeClean.split('-');
      final startTimeStr = timePieces[0].trim(); // "11:00 AM"
      final endTimeStr = timePieces.length > 1 ? timePieces[1].trim() : '';

      final start =
          DateFormat('MMM d, yyyy h:mm a').parse('$dateStr $startTimeStr');

      DateTime? end;
      if (endTimeStr.isNotEmpty) {
        // If "12:00" (no AM/PM), reuse AM/PM from start
        String endFull = endTimeStr;
        if (!endTimeStr.toLowerCase().contains('am') &&
            !endTimeStr.toLowerCase().contains('pm')) {
          final ampm = startTimeStr.split(' ').last;
          endFull = '$endTimeStr $ampm';
        }
        end = DateFormat('MMM d, yyyy h:mm a').parse('$dateStr $endFull');
      }

      final dateLabel = DateFormat('EEE, MMM d').format(start);
      final startLabel = DateFormat('h:mm a').format(start);
      String result = '$dateLabel · $startLabel';

      if (end != null) {
        final endLabel = DateFormat('h:mm a').format(end);
        result += ' – $endLabel';
      }

      if (tzName.isNotEmpty) {
        result += ' ($tzName)';
      }

      return result;
    } catch (_) {
      return input;
    }
  }

  // ---------- TYPE 3 (MAP-LIKE STRING) ----------

  /// "{implementation: new, date: 2025-10-31 09:00, duration: 60, timezone: Europe/London (GMT+01:00)}"
  static String _formatType3MapString(String input) {
    try {
      final trimmed = input.trim();

      // Remove enclosing { }
      final inner = trimmed.substring(1, trimmed.length - 1).trim();
      if (inner.isEmpty) return input;

      // Split on commas at top level (safe here because values don't contain commas)
      final parts = inner.split(',');

      final map = <String, String>{};
      for (var part in parts) {
        final segment = part.trim();
        if (segment.isEmpty) continue;

        final colonIndex = segment.indexOf(':');
        if (colonIndex == -1) continue;

        final key = segment.substring(0, colonIndex).trim();
        final value = segment.substring(colonIndex + 1).trim();
        map[key] = value;
      }

      final dateStr = (map['date'] ?? ''); // "2025-10-31 09:00"
      final durationStr = (map['duration'] ?? '0'); // "60"
      final timezoneRaw =
          (map['timezone'] ?? ''); // "Europe/London (GMT+01:00)"

      final durationMinutes = int.tryParse(durationStr) ?? 0;

      // Extract cleaner tz label: "Europe/London (GMT+01:00)" -> "Europe/London"
      final tzLabel = timezoneRaw.contains('(')
          ? timezoneRaw.split('(').first.trim()
          : timezoneRaw.trim();

      final start = DateFormat('yyyy-MM-dd HH:mm').parse(dateStr);
      final end = start.add(Duration(minutes: durationMinutes));

      final dateLabel = DateFormat('EEE, MMM d').format(start);
      final startLabel = DateFormat('h:mm a').format(start);
      final endLabel = DateFormat('h:mm a').format(end);

      return '$dateLabel · $startLabel – $endLabel ($tzLabel)';
    } catch (_) {
      return input;
    }
  } //!SECTION

  // SECTION First Call Status Helper Function
  static String getFirstCallStatusLabel(FirstCallStatusData data) {
    switch (data) {
      case FirstCallStatusData.accepted:
        return "Accepted";
      case FirstCallStatusData.rejected:
        return "Rejected";
      case FirstCallStatusData.cancelled:
        return "Cancelled";
      case FirstCallStatusData.notStarted:
        return "Not Started";
    }
  }

  static Color getFirstCallStatusColor(FirstCallStatusData data) {
    switch (data) {
      case FirstCallStatusData.accepted:
        return Colors.green;
      case FirstCallStatusData.rejected:
        return Colors.red;
      case FirstCallStatusData.cancelled:
        return Colors.orange;
      case FirstCallStatusData.notStarted:
        return Colors.grey;
    }
  }

  static FirstCallStatusData getFirstCallStatusFromResponse(String response) {
    if (response == "not-started") {
      return FirstCallStatusData.notStarted;
    } else if (response == "accepted") {
      return FirstCallStatusData.accepted;
    } else if (response == "cancelled") {
      return FirstCallStatusData.cancelled;
    } else {
      return FirstCallStatusData.rejected;
    }
  }
  //!SECTION
}
