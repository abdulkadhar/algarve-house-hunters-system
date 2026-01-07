import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class ImageUploadWidget extends StatefulWidget {
  final String baseUrl; // e.g. https://systems.algarvehousehunters.com
  final ValueChanged<List<Map<String, dynamic>>>? onUploadComplete;

  const ImageUploadWidget({
    super.key,
    required this.baseUrl,
    this.onUploadComplete,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  late DropzoneViewController dropzoneController;
  bool highlighted = false;
  bool isUploading = false;

  List<Map<String, dynamic>> uploadedFiles = [];

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      for (var file in result.files) {
        if (file.bytes != null) {
          await _uploadFile(file.name, file.bytes!);
        }
      }
    }
  }

  Future<void> _uploadFile(String filename, List<int> fileBytes) async {
    setState(() => isUploading = true);

    try {
      var uri = Uri.parse("${widget.baseUrl}/upload");
      var request = http.MultipartRequest("POST", uri);

      request.files.add(
        http.MultipartFile.fromBytes("files", fileBytes, filename: filename),
      );

      var response = await request.send();
      var body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var data = jsonDecode(body);
        var newFiles = List<Map<String, dynamic>>.from(data["uploaded_files"]);

        setState(() {
          uploadedFiles.addAll(newFiles);
        });

        // 🔔 Notify parent
        if (widget.onUploadComplete != null) {
          widget.onUploadComplete!(uploadedFiles);
        }
      } else {
        debugPrint("Upload failed: ${response.statusCode} $body");
      }
    } finally {
      setState(() => isUploading = false);
    }
  }

  Future<void> _deleteFile(String storedFilename) async {
    var uri = Uri.parse("${widget.baseUrl}/delete/$storedFilename");
    var response = await http.delete(uri);

    if (response.statusCode == 200) {
      setState(() {
        uploadedFiles
            .removeWhere((f) => f["stored_filename"] == storedFilename);
      });

      // 🔔 Notify parent about updated list
      if (widget.onUploadComplete != null) {
        widget.onUploadComplete!(uploadedFiles);
      }
    } else {
      debugPrint("Delete failed: ${response.body}");
    }
  }

  Future<void> _handleDrop(dynamic ev) async {
    final bytes = await dropzoneController.getFileData(ev);
    final name = await dropzoneController.getFilename(ev);
    await _uploadFile(name, bytes);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Drag & Drop Zone
        InkWell(
          onTap: _pickImages,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: highlighted ? Colors.blue : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                DropzoneView(
                  mime: ["image/png", "image/jpeg"],
                  onCreated: (controller) => dropzoneController = controller,
                  onDrop:
                      _handleDrop, // fires once per file, so multi-select just means multiple calls
                  onHover: () => setState(() => highlighted = true),
                  onLeave: () => setState(() => highlighted = false),
                ),
                Center(
                  child: Text(
                    "Drag & Drop images here or click to select",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Button to pick images
        // ElevatedButton.icon(
        //   onPressed: _pickImages,
        //   icon: const Icon(Icons.photo_library),
        //   label: const Text("Select Images"),
        // ),

        // Loader
        if (isUploading)
          const LinearProgressIndicator(
            color: Colors.black12,
          ),
      ],
    );
  }
}
