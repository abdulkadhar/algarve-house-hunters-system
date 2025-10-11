import 'package:flutter/material.dart';

class OfficeNotesDisplay extends StatelessWidget {
  final List<Map<String, String>> officeNotes;

  const OfficeNotesDisplay({
    super.key,
    required this.officeNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: officeNotes.map((note) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            title: Text(
              note["notesValue"] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Created By: ${note["createdBy"] ?? ""}"),
                Text("Created Time: ${note["createdTime"] ?? ""}"),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
