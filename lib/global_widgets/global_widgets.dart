import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class GlobalWidgets {
  static Widget getTextLabelWidget(
    String labelText, {
    bool isMandatory = true,
  }) =>
      Text.rich(
        TextSpan(
          text: labelText,
          style: ThemeController.getFormLabelTextStyle(),
          children: isMandatory
              ? <InlineSpan>[
                  TextSpan(
                    text: ' *',
                    style: ThemeController.getFormLabelTextStyle(
                        textColor: Colors.red),
                  )
                ]
              : [],
        ),
      );
}
