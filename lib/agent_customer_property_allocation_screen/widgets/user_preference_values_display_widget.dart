import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserPreferenceValuesDisplayWidget extends StatefulWidget {
  final String labelName;
  final String labelValue;
  final bool isLink;
  final double labelWidth;
  final bool isImage;
  final double labelSize;
  final bool isEdit;
  final VoidCallback? onEditPress;
  const UserPreferenceValuesDisplayWidget({
    super.key,
    required this.labelName,
    required this.labelValue,
    this.labelWidth = 400,
    this.isLink = false,
    this.isImage = false,
    this.labelSize = 16,
    this.isEdit = false,
    this.onEditPress,
  });

  @override
  State<UserPreferenceValuesDisplayWidget> createState() =>
      _UserPreferenceValuesDisplayWidgetState();
}

class _UserPreferenceValuesDisplayWidgetState
    extends State<UserPreferenceValuesDisplayWidget> {
  void openLink(String link) async {
    final Uri url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication, // Opens in a new tab
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.labelWidth,
          child: Text(
            widget.labelName,
            style: ThemeController.normalTextStyle(
              size: widget.labelSize,
            ),
          ),
        ),
        const SizedBox(
          width: 50,
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(10),
            // width: 200,
            child: widget.isImage
                ? Image.network(widget.labelValue)
                : InkWell(
                    onTap: widget.isLink
                        ? () async {
                            openLink(widget.labelValue);
                          }
                        : null,
                    child: Text(
                      widget.labelValue,
                      style: ThemeController.smallTextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 5,
                    ),
                  ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        if (widget.isEdit)
          InkWell(
            onTap: widget.onEditPress,
            child: Icon(
              Icons.edit,
              size: 18,
            ),
          )
      ],
    );
  }
}
