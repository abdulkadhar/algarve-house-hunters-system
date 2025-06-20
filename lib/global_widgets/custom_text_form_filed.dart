import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CustomTextFormFiled extends StatelessWidget {
  final String labelName;
  final String placeholderText;
  final bool isMandatory;
  const CustomTextFormFiled({
    super.key,
    required this.labelName,
    required this.placeholderText,
    this.isMandatory = true,
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
        )
      ],
    );
  }
}
