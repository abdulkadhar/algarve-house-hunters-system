import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CustomTextFormFiled extends StatelessWidget {
  final String labelName;
  final String placeholderText;
  final bool isMandatory;
  final Function(String?)? onChanged;
  final String? errorText;
  const CustomTextFormFiled({
    super.key,
    required this.labelName,
    required this.placeholderText,
    this.isMandatory = true,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalWidgets.getTextLabelWidget(
          labelName,
          isMandatory: isMandatory,
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: placeholderText,
            labelStyle: ThemeController.smallTextStyle(),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(ThemeController.textFieldBorderRadius),
              borderSide: ThemeController.getTextFieldBorderStyle(),
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
          enabled: true,
        ),
        if (errorText != null)
          const SizedBox(
            height: 2,
          ),
        if (errorText != null)
          Text(
            errorText!,
            style: ThemeController.smallTextStyle(
              color: Colors.red,
            ),
          )
      ],
    );
  }
}
