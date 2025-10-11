import 'dart:convert';

import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_password_text_form_field.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum PasswordStatus {
  notUpdated,
  updated,
  exists,
}

class AgentPasswordScreen extends StatefulWidget {
  final String agentId;
  const AgentPasswordScreen({
    super.key,
    required this.agentId,
  });

  @override
  State<AgentPasswordScreen> createState() => _AgentPasswordScreenState();
}

class _AgentPasswordScreenState extends State<AgentPasswordScreen> {
  String? passwordErrorText;
  String? confirmPasswordErrorText;

  String passwordHolder = '';
  String confirmPassword = '';

  Map<String, dynamic> payload = {
    "agent_id": "",
    "password": "",
  };

  PasswordStatus status = PasswordStatus.notUpdated;

  void setPasswordErrorText(String errorText) {
    passwordErrorText = errorText;
    setState(() {});
  }

  void setConfirmPasswordErrorText(String errorText) {
    confirmPasswordErrorText = errorText;
    setState(() {});
  }

  void clearPasswordErrorText() {
    passwordErrorText = null;
    setState(() {});
  }

  void clearConfirmPasswordErrorText() {
    confirmPasswordErrorText = null;
    setState(() {});
  }

  void setPasswordStatus(PasswordStatus statusSet) {
    status = statusSet;
    setState(() {});
  }

  void fetchUserPasswordStats() async {
    await ApiController.getAgentPasswordUpdateStatus(
      widget.agentId,
      onSuccess: (resData) {
        final data = jsonDecode(resData);
        print("INFO: STATUS: ${data['status']}");
        if (data['status'] == "true") {
          setPasswordStatus(PasswordStatus.exists);
        } else {
          setPasswordStatus(PasswordStatus.notUpdated);
        }
      },
      onError: (errorData) {},
    );
  }

  @override
  void initState() {
    super.initState();
    fetchUserPasswordStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.pageBackgroundColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: Row(
                  children: [
                    Image.asset(
                      AssetsController.mainLogoPath,
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Update your password',
                      style: ThemeController.titleTextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const SizedBox(
              height: 10,
            ),
            if (status == PasswordStatus.notUpdated)
              Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: CustomPasswordTextField(
                        labelName: 'Enter password',
                        placeholderText: '',
                        errorText: passwordErrorText,
                        onChanged: (nameData) {
                          clearPasswordErrorText();
                          if (nameData != null) {
                            passwordHolder = nameData;
                          }
                        },
                        isMandatory: true,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: CustomPasswordTextField(
                        labelName: 'Confirm password',
                        placeholderText: '',
                        errorText: confirmPasswordErrorText,
                        onChanged: (nameData) {
                          clearConfirmPasswordErrorText();
                          if (nameData != null) {
                            confirmPassword = nameData;
                          }
                        },
                        isMandatory: true,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 200,
                      child: SubmitButton(
                        onButtonPress: () async {
                          if (passwordHolder.isEmpty) {
                            setPasswordErrorText(
                                "Password cannot be empty !!!");
                          } else if (confirmPassword.isEmpty) {
                            setConfirmPasswordErrorText(
                                "Confirm password cannot be empty !!!");
                          } else if (confirmPassword != passwordHolder) {
                            setConfirmPasswordErrorText(
                                "Password and confirm password must be same !!!!");
                          } else {
                            ManagerLogInScreenController.showLoaderDialog(
                                context);
                            payload["agent_id"] = widget.agentId;
                            payload["password"] = passwordHolder;
                            await ApiController.updateAgentPassword(
                              payload,
                              onSuccess: (resData) {
                                ManagerLogInScreenController.hideDialogBox(
                                    context);
                                setPasswordStatus(PasswordStatus.updated);
                              },
                              onError: (errorData) {
                                ManagerLogInScreenController.showError(
                                    context, 'Erorr in updating the password');
                              },
                            );
                          }
                        },
                        buttonLabel: "Update password",
                      ),
                    )
                  ],
                ),
              ),
            if (status == PasswordStatus.exists)
              Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      'assets/lottie/already_present.json',
                      height: 200,
                      width: 400,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Your account password has already been created.\nIf you’ve forgotten it, please use the “Forgot Password” option to reset it.",
                      style: ThemeController.smallTextStyle(
                        size: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            if (status == PasswordStatus.updated)
              Container(
                padding: const EdgeInsets.all(20),
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LottieBuilder.asset(
                      'assets/lottie/updated.json',
                      height: 200,
                      width: 400,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Your account password has been updated successfully.\nYou can now log in using your new password.\nIf you did not make this change, please contact support immediately.",
                      style: ThemeController.smallTextStyle(
                        size: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
