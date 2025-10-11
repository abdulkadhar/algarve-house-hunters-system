import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_dashboard_screen/view/agent_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/view/agent_listing_screen.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_password_text_form_field.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/login_screen/widgets/testimonals_carousel_widget.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AgentLoginScreen extends StatefulWidget {
  const AgentLoginScreen({super.key});

  @override
  State<AgentLoginScreen> createState() => _AgentLoginScreenState();
}

class _AgentLoginScreenState extends State<AgentLoginScreen> {
  String? emailErrorText;
  String? passwordErrorText;

  void setEmailErrorText(String value) {
    emailErrorText = value;
    setState(() {});
  }

  void setPasswordErrorText(String value) {
    passwordErrorText = value;
    setState(() {});
  }

  void clearEmailErrorText() {
    emailErrorText = null;
    setState(() {});
  }

  void clearPasswordErrorText() {
    passwordErrorText = null;
    setState(() {});
  }

  Map<String, dynamic> loginRequest = {
    'email': '',
    'password': '',
  };
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
                    errorText: emailErrorText,
                    onChanged: (data) {
                      clearEmailErrorText();
                      if (data != null && data.isNotEmpty) {
                        loginRequest['email'] = data;
                      } else {
                        setEmailErrorText("Email cannot be empty !!!");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomPasswordTextField(
                    labelName: 'Password',
                    placeholderText: '',
                    errorText: passwordErrorText,
                    onChanged: (data) {
                      clearPasswordErrorText();
                      if (data != null && data.isNotEmpty) {
                        loginRequest['password'] = data;
                      } else {
                        setPasswordErrorText('Password cannot be empty !!!');
                      }
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SubmitButton(
                    onButtonPress: () async {
                      if (emailErrorText == null && passwordErrorText == null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.sendAgentLoginRequest(
                          loginRequest,
                          onSuccess: (data) {
                            var finaldata = jsonDecode(data);
                            context.go(
                                '/agent-dashboard-screen/${finaldata['manager_id']}');
                          },
                          onError: (data) {
                            ManagerLogInScreenController.hideDialogBox(context);
                            ManagerLogInScreenController.showError(
                              context,
                              data,
                            );
                          },
                        );
                      }
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
