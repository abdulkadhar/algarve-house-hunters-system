import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CustomPasswordTextField extends StatefulWidget {
  final String labelName;
  final bool isMandatory;
  final String placeholderText;
  const CustomPasswordTextField({
    super.key,
    required this.labelName,
    this.isMandatory = false,
    this.placeholderText = '',
  });

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlobalWidgets.getTextLabelWidget(
          widget.labelName,
          isMandatory: widget.isMandatory,
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          obscureText: _obscureText,
          decoration: InputDecoration(
            labelText: widget.placeholderText,
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
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
