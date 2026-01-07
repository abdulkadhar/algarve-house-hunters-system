import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter/material.dart';

class CsvDropZone extends StatefulWidget {
  final Function(dynamic fileId, String fileName) onFileDropped;

  const CsvDropZone({super.key, required this.onFileDropped});

  @override
  State<CsvDropZone> createState() => _CsvDropZoneState();
}

class _CsvDropZoneState extends State<CsvDropZone> {
  late DropzoneViewController controller;
  bool highlight = false;

  bool isCsvFile(String fileName) {
    final lower = fileName.toLowerCase();
    return lower.endsWith(".csv");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Stack(
        children: [
          DropzoneView(
            onCreated: (ctrl) => controller = ctrl,
            onDrop: (fileId) async {
              final name = await controller.getFilename(fileId);

              if (!isCsvFile(name)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Only CSV files allowed")),
                );
                return;
              }

              widget.onFileDropped(fileId, name);
            },
            onHover: () => setState(() => highlight = true),
            onLeave: () => setState(() => highlight = false),
          ),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: highlight ? Colors.blue : Colors.grey,
                width: 2,
              ),
            ),
            child: const Center(
              child: Text(
                "Drag & drop CSV file here\nor click to upload",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
