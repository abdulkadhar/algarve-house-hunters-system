import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class FileContentTile extends StatelessWidget {
  final String fileName;
  final VoidCallback onDownloadPress;
  final IconData iconData;
  const FileContentTile({
    super.key,
    required this.fileName,
    this.iconData = Icons.download,
    required this.onDownloadPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            child: Icon(Icons.picture_as_pdf),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            fileName,
            style: ThemeController.normalTextStyle(),
          ),
          const Spacer(),
          InkWell(
            onTap: onDownloadPress,
            child: Icon(
              iconData,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
