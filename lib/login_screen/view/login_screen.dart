import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_password_set_screen/view/agent_password_screen.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_password_text_form_field.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/login_screen/widgets/already_have_account_widget.dart';
import 'package:algarve_house_hunters_system/login_screen/widgets/testimonals_carousel_widget.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Map<String, dynamic> loginRequest = {
    'email': '',
    'password': '',
  };
  String? emailErrorText;
  String? passwordErrorText;

  void setEmailErrorText(String errorText) {
    emailErrorText = errorText;
    setState(() {});
  }

  void setPasswordErrorText(String errorText) {
    passwordErrorText = errorText;
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
                    onChanged: (valueData) {
                      clearEmailErrorText();
                      if (valueData != null) {
                        if (valueData.isNotEmpty && valueData != '') {
                          loginRequest['email'] = valueData;
                        } else {
                          setEmailErrorText('Email cannot be empty !!!');
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
                    errorText: passwordErrorText,
                    onChanged: (valueData) {
                      clearPasswordErrorText();
                      if (valueData != null) {
                        if (valueData.isNotEmpty && valueData != '') {
                          loginRequest['password'] = valueData;
                        } else {
                          setPasswordErrorText('Password cannot be empty !!!!');
                        }
                      }
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SubmitButton(
                    onButtonPress: () async {
                      if (loginRequest['email'] != '' &&
                          loginRequest['password'] != '') {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.sendClientLoginRequest(
                          loginRequest,
                          onSuccess: (responseData) {
                            final resultData = jsonDecode(responseData);
                            context.go(
                              '/customer_dashboard_screen/${resultData['client_id']}',
                            );
                          },
                          onError: (error) {
                            // errorText = error;
                            ManagerLogInScreenController.hideDialogBox(context);
                            ManagerLogInScreenController.showError(
                              context,
                              jsonDecode(error),
                            );
                          },
                        );
                      } else {
                        if (loginRequest['email'] == '') {
                          setEmailErrorText('Email cannot be empty !!!');
                        }
                        if (loginRequest['password'] == '') {
                          setPasswordErrorText('Password cannot be empty !!!');
                        }
                      }
                    },
                    buttonLabel: 'Submit',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  AlreadyHaveAccountWidget(
                    prefixText: "Don't have an account? ",
                    actionName: "Sign Up",
                    onClick: () {
                      context.go('/sign-up');
                    },
                  )
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
