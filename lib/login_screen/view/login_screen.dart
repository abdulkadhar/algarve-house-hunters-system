import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_password_text_form_field.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/login_screen/widgets/already_have_account_widget.dart';
import 'package:algarve_house_hunters_system/login_screen/widgets/testimonals_carousel_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.pageBackgroundColor,
      body: Row(
        children: [
          SizedBox(
            // decoration: const BoxDecoration(color: Colors.orange),
            width: MediaQuery.of(context).size.width / 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 80.0,
                vertical: 50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NOTE - Checking the asset added`
                  Image.asset(
                    AssetsController.mainLogoPath,
                    height: 100,
                    width: 100,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Welcome to Algarve House Hunters',
                    style: ThemeController.titleTextStyle(),
                  ),
                  Text(
                    'Manage Properties. Simplify Operations. Maximize ROI.',
                    style: ThemeController.smallTextStyle(),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const CustomTextFormFiled(
                    labelName: 'Email',
                    placeholderText: '',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CustomPasswordTextField(
                    labelName: 'Password',
                    placeholderText: '',
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SubmitButton(
                    onButtonPress: () {},
                    buttonLabel: 'Submit',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AlreadyHaveAccountWidget(
                    actionName: "Sign Up",
                    onClick: () {},
                  )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height,
            child: const TestimonialCarousel(),
          ),
        ],
      ),
    );
  }
}
