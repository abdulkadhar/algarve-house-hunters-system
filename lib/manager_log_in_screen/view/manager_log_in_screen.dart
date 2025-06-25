import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_password_text_form_field.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/login_screen/widgets/testimonals_carousel_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/view/manager_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ManagerLoginScreen extends StatefulWidget {
  const ManagerLoginScreen({super.key});

  @override
  State<ManagerLoginScreen> createState() => _ManagerLoginScreenState();
}

class _ManagerLoginScreenState extends State<ManagerLoginScreen> {
  Map<String, dynamic> loginRequest = {
    'email': '',
    'password': '',
  };
  String? errorText;
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
                  CustomTextFormFiled(
                    labelName: 'Email',
                    placeholderText: '',
                    onChanged: (emailValue) {
                      if (emailValue != null) {
                        if (emailValue.isNotEmpty) {
                          loginRequest['email'] = emailValue;
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomPasswordTextField(
                    labelName: 'Password',
                    placeholderText: '',
                    onChanged: (passwordData) {
                      if (passwordData != null) {
                        if (passwordData.isNotEmpty) {
                          loginRequest['password'] = passwordData;
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SubmitButton(
                    onButtonPress: () {
                      print('submit btn is pressed');
                      ApiController.sendLoginRequest(
                        loginRequest,
                        onSuccess: (responseData) {
                          Navigator.pushNamed(
                            context,
                            '/manager-dashboard-screen',
                          );
                        },
                        onError: (error) {
                          errorText = error;
                          setState(() {});
                        },
                      );
                    },
                    buttonLabel: 'Submit',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height,
            child: const TestimonialCarousel(),
          ),
        ],
      ),
    );
  }
}
