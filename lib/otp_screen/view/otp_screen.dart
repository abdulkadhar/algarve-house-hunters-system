import 'dart:ui_web';

import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/login_screen/widgets/already_have_account_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  final String emailAddress;
  const OtpScreen({
    super.key,
    required this.emailAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.pageBackgroundSecondaryColor,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: ThemeController.pageBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Email Verification",
                    style: ThemeController.titleTextStyle(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "We have sent otp code to your $emailAddress",
                    style: ThemeController.smallTextStyle(
                      color: ThemeController.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Pinput(
                    onCompleted: (pin) => print(pin),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SubmitButton(
                    onButtonPress: () {},
                    buttonLabel: 'Verify Account',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AlreadyHaveAccountWidget(
                    prefixText: "Didn't receive code? ",
                    actionName: "Resend",
                    onClick: () {},
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 10),
              child: Image.asset(
                AssetsController.mainLogoPath,
                height: 100,
                width: 100,
              ),
            ),
          )
        ],
      ),
    );
  }
}
