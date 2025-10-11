import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/global_widgets/paste_formatter.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CustomTextFormFiled extends StatefulWidget {
  final String labelName;
  final String placeholderText;
  final bool isMandatory;
  final Function(String)? onChanged;
  final String? errorText;
  final String? initialValue;
  final bool readOnly;
  final Function(String)? onPaste;

  const CustomTextFormFiled({
    super.key,
    required this.labelName,
    required this.placeholderText,
    this.isMandatory = true,
    this.onChanged,
    this.errorText,
    this.initialValue,
    this.readOnly = false,
    this.onPaste,
  });

  @override
  State<CustomTextFormFiled> createState() => _CustomTextFormFiledState();
}

class _CustomTextFormFiledState extends State<CustomTextFormFiled> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? "");

    _controller.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomTextFormFiled oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      // update without losing cursor
      _controller.value = _controller.value.copyWith(
        text: widget.initialValue ?? "",
        selection: TextSelection.collapsed(
          offset: (widget.initialValue ?? "").length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalWidgets.getTextLabelWidget(
          widget.labelName,
          isMandatory: widget.isMandatory,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller, // ✅ use controller instead of initialValue
          inputFormatters: [
            PasteDetector(
              onPaste: (text) {
                if (widget.onPaste != null) {
                  widget.onPaste!(text);
                }
              },
            ),
          ],
          readOnly: widget.readOnly,
          decoration: InputDecoration(
            labelText: widget.placeholderText,
            labelStyle: ThemeController.smallTextStyle(),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(ThemeController.textFieldBorderRadius),
              borderSide: ThemeController.getTextFieldBorderStyle(
                borderColor: widget.readOnly ? Colors.grey : Colors.black,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(ThemeController.textFieldBorderRadius),
              borderSide: ThemeController.getTextFieldBorderStyle(
                borderColor: ThemeController.disableTextFieldBorderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(ThemeController.textFieldBorderRadius),
              borderSide: ThemeController.getTextFieldBorderStyle(),
            ),
            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(ThemeController.textFieldBorderRadius),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 2),
          Text(
            widget.errorText!,
            style: ThemeController.smallTextStyle(color: Colors.red),
          ),
        ]
      ],
    );
  }
}
