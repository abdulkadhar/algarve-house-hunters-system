import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/break_points.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_password_text_form_field.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/login_screen/widgets/testimonals_carousel_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/view/manager_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  String? emailErrorText;
  String? passwordErrorText;

  void setEmailErrorTest(String errorText) {
    emailErrorText = errorText;
    setState(() {});
  }

  void clearEmailErrorText() {
    emailErrorText = null;
    setState(() {});
  }

  void setPasswordErrorTest(String errorText) {
    passwordErrorText = errorText;
    setState(() {});
  }

  void clearPasswordErrorText() {
    passwordErrorText = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          backgroundColor: ThemeController.pageBackgroundColor,
          body: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              // NOTE Mobile View
              if (width < Breakpoints.mobile) {
                return SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                          onChanged: (emailValue) {
                            clearEmailErrorText();
                            if (emailValue != null) {
                              if (emailValue.isNotEmpty) {
                                loginRequest['email'] = emailValue;
                              } else {
                                setEmailErrorTest("Email cannot be empty !!!");
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
                          onChanged: (passwordData) {
                            clearPasswordErrorText();
                            if (passwordData != null) {
                              if (passwordData.isNotEmpty) {
                                loginRequest['password'] = passwordData;
                              } else {
                                setPasswordErrorTest(
                                    "Password cannot be empty !!!");
                              }
                            }
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SubmitButton(
                          onButtonPress: () {
                            clearEmailErrorText();
                            clearPasswordErrorText();
                            setState(() {});
                            if (loginRequest['email'] == '' ||
                                loginRequest['email'] == null) {
                              setEmailErrorTest("Email cannot be empty !!!");
                            } else if (loginRequest['password'] == '' ||
                                loginRequest['password'] == null) {
                              setPasswordErrorTest(
                                  "Password cannot be empty !!!");
                            } else {
                              // NOTE Showing the loader
                              ManagerLogInScreenController.showLoaderDialog(
                                  context);
                              ApiController.sendLoginRequest(
                                loginRequest,
                                onSuccess: (responseData) {
                                  // NOTE Hiding the loader
                                  // ManagerLogInScreenController.hideDialogBox(context);
                                  if (!mounted) {
                                    return;
                                  }
                                  context.go(
                                    '/manager-dashboard-screen',
                                  );
                                },
                                onError: (error) {
                                  // NOTE Hiding the loader
                                  ManagerLogInScreenController.hideDialogBox(
                                      context);
                                  errorText = error;

                                  setState(() {});
                                  ManagerLogInScreenController.showError(
                                    context,
                                    errorText ?? "API: Unexpected Error",
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
                );
              } else if (width < Breakpoints.tablet) {
                return Container();
              } else {
                // NOTE Web View
                return Row(
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
                              onChanged: (emailValue) {
                                clearEmailErrorText();
                                if (emailValue != null) {
                                  if (emailValue.isNotEmpty) {
                                    loginRequest['email'] = emailValue;
                                  } else {
                                    setEmailErrorTest(
                                        "Email cannot be empty !!!");
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
                              onChanged: (passwordData) {
                                clearPasswordErrorText();
                                if (passwordData != null) {
                                  if (passwordData.isNotEmpty) {
                                    loginRequest['password'] = passwordData;
                                  } else {
                                    setPasswordErrorTest(
                                        "Password cannot be empty !!!");
                                  }
                                }
                              },
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            SubmitButton(
                              onButtonPress: () {
                                clearEmailErrorText();
                                clearPasswordErrorText();
                                setState(() {});
                                if (loginRequest['email'] == '' ||
                                    loginRequest['email'] == null) {
                                  setEmailErrorTest(
                                      "Email cannot be empty !!!");
                                } else if (loginRequest['password'] == '' ||
                                    loginRequest['password'] == null) {
                                  setPasswordErrorTest(
                                      "Password cannot be empty !!!");
                                } else {
                                  // NOTE Showing the loader
                                  ManagerLogInScreenController.showLoaderDialog(
                                      context);
                                  ApiController.sendLoginRequest(
                                    loginRequest,
                                    onSuccess: (responseData) {
                                      // NOTE Hiding the loader
                                      // ManagerLogInScreenController.hideDialogBox(context);
                                      if (!mounted) {
                                        return;
                                      }
                                      context.go(
                                        '/manager-dashboard-screen',
                                      );
                                    },
                                    onError: (error) {
                                      // NOTE Hiding the loader
                                      ManagerLogInScreenController
                                          .hideDialogBox(context);
                                      errorText = error;

                                      setState(() {});
                                      ManagerLogInScreenController.showError(
                                        context,
                                        errorText ?? "API: Unexpected Error",
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
                ); // Web / Large screens
              }
            },
          )),
    );
  }
}
