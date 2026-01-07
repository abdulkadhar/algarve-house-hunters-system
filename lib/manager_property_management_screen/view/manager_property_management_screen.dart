import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/option_label_selector_widget.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/border_button.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/global_widgets/html_renderer.dart';
import 'package:algarve_house_hunters_system/global_widgets/property_addition_form.dart';
import 'package:algarve_house_hunters_system/global_widgets/rich_text_editor_dialog_box.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/view/manager_log_in_screen.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/controller/manager_property_management_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/manager_property_unit_tile_widget.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/quick_action_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

import 'package:lottie/lottie.dart';

enum CrmOptions {
  addEntry,
  listEntry,
}

enum CrmPersonOption {
  advocate,
  mortgageBroker,
  currencyManager,
}

class MangerPropertyManagementScreen extends StatefulWidget {
  final String agentId;
  const MangerPropertyManagementScreen(
      {super.key, this.agentId = "MNG-BLR-20250625-0001"});

  @override
  State<MangerPropertyManagementScreen> createState() =>
      _MangerPropertyManagementScreenState();
}

class _MangerPropertyManagementScreenState
    extends State<MangerPropertyManagementScreen> {
  CrmOptions crmOption = CrmOptions.addEntry;
  CrmPersonOption crmPersonOption = CrmPersonOption.advocate;
  List<dynamic> crmAdvocate = [];
  List<dynamic> crmMortgageBroker = [];
  List<dynamic> crmCurrencyManager = [];

  Map<String, dynamic> selectedAdvocate = {};
  Map<String, dynamic> selectedCurrencyManager = {};
  Map<String, dynamic> selectedMortgageBroker = {};

  Map<String, dynamic> allEmailTemplates = {};

  // NOTE Property State Management
  List<Map<String, dynamic>> allProperties = [];
  PropertyManagementOption propertyManagementOption =
      PropertyManagementOption.addProperty;
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.listings;
  // NOTE value holders
  String firstNameValue = '';
  String secondNameValue = '';
  String emailValue = '';
  String phoneValue = '';

  //NOTE edit value holders
  String firstEditNameValue = '';
  String secondEditNameValue = '';
  String emailEditValue = '';
  String phoneEditValue = '';
  CrmPersonOption? crmPersonEditOption;

  // NOTE error edit value holders
  String? firstNameEditError;
  String? secondNameEditError;
  String? emailEditError;
  String? phoneNumberEditError;

  // NOTE error value holders
  String? firstNameError;
  String? secondNameError;
  String? emailError;
  String? phoneNumberError;

  void changeCrmPersonEditOption(CrmPersonOption optionData) {
    crmPersonEditOption = optionData;
    setState(() {});
  }

  void changeCrmPersonOption(CrmPersonOption optionData) {
    crmPersonOption = optionData;
    setState(() {});
  }

  void clearFirstNameError() {
    firstNameError = null;
    setState(() {});
  }

  void clearSecondNameError() {
    secondNameError = null;
    setState(() {});
  }

  void clearEmailError() {
    emailError = null;
    setState(() {});
  }

  void clearPhoneError() {
    phoneNumberError = null;
    setState(() {});
  }

  void setFirstNameError(String data) {
    firstNameError = data;
    setState(() {});
  }

  void setSecondNameError(String data) {
    secondNameError = data;
    setState(() {});
  }

  void setEmailError(String data) {
    emailError = data;
    setState(() {});
  }

  void setPhoneError(String data) {
    phoneNumberError = data;
    setState(() {});
  }

  void setAvailableCrmData() async {
    await ApiController.getAllCrmData(
      onSuccess: (resData) {
        final responseData = jsonDecode(resData);
        crmAdvocate = [];
        crmAdvocate = responseData['advocates'];
        crmMortgageBroker = responseData['mortgageBroker'];
        crmCurrencyManager = responseData['currencyManager'];
        setState(() {});
      },
      onError: (errData) {
        ManagerLogInScreenController.showError(
          context,
          jsonDecode(errData),
        );
      },
    );
  }

  String crmPersonOptionToString(CrmPersonOption optionData) {
    switch (optionData) {
      case CrmPersonOption.advocate:
        return "Advocate";
      case CrmPersonOption.mortgageBroker:
        return "Mortgage Broker";
      case CrmPersonOption.currencyManager:
        return "Currency Manager";
    }
  }

  void setPersonData() {
    Map<String, dynamic> tempData = {
      "advocates": [
        {
          "firstName": "firstNameValue",
          "secondName": "secondNameValue",
          "emailAddress": "emailValue",
          "phoneNumber": "phoneValue",
          "designation": "Advocate",
          "createdAt": "",
          "crmId": "CRM-888uuu",
        },
        {
          "firstName": "firstNameValue",
          "secondName": "secondNameValue",
          "emailAddress": "emailValue",
          "phoneNumber": "phoneValue",
          "designation": "Advocate",
          "createdAt": "",
          "crmId": "CRM-888uuu",
        }
      ],
      "mortgageBroker": [
        {
          "firstName": "firstNameValue",
          "secondName": "secondNameValue",
          "emailAddress": "emailValue",
          "phoneNumber": "phoneValue",
          "designation": "Advocate",
          "createdAt": "",
          "crmId": "CRM-888uuu",
        },
        {
          "firstName": "firstNameValue",
          "secondName": "secondNameValue",
          "emailAddress": "emailValue",
          "phoneNumber": "phoneValue",
          "designation": "Advocate",
          "createdAt": "",
          "crmId": "CRM-888uuu",
        }
      ],
      "currencyManager": [
        {
          "firstName": "firstNameValue",
          "secondName": "secondNameValue",
          "emailAddress": "emailValue",
          "phoneNumber": "phoneValue",
          "designation": "Advocate",
          "createdAt": "",
          "crmId": "CRM-888uuu",
        },
        {
          "firstName": "firstNameValue",
          "secondName": "secondNameValue",
          "emailAddress": "emailValue",
          "phoneNumber": "phoneValue",
          "designation": "Advocate",
          "createdAt": "",
          "crmId": "CRM-888uuu",
        }
      ],
    };
    crmAdvocate = [];
    crmAdvocate = tempData["advocates"];
    crmCurrencyManager = tempData["currencyManager"];
    crmMortgageBroker = tempData["mortgageBroker"];

    setState(() {});
  }

  void changeCrmOption(CrmOptions optionData) {
    crmOption = optionData;
    setState(() {});
  }

  void changeDashboardOption(ManagerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  void changePropertyOption(PropertyManagementOption option) {
    propertyManagementOption = option;
    setState(() {});
  }

  void getAllProperties() async {
    await ApiController.getAllPropertiesManager(onSuccess: (data) {
      final propertyData = jsonDecode(data);
      final List<Map<String, dynamic>> myList =
          List<Map<String, dynamic>>.from(propertyData);
      allProperties = myList.reversed.toList();
      // allProperties.reversed;

      setState(() {});
    }, onError: (errorData) {
      // print(jsonDecode(errorData));
    });
  }

  void getSelectedCrmData() async {
    await ApiController.getSelectedData(
      onError: (errData) {
        ManagerLogInScreenController.showError(
          context,
          jsonDecode(errData),
        );
      },
      onSuccess: (resData) {
        final responseData = jsonDecode(resData);
        selectedAdvocate = responseData["advocates"];
        selectedMortgageBroker = responseData["mortgageBroker"];
        selectedCurrencyManager = responseData["currencyManager"];
        setState(() {});
      },
    );
  }

  CrmPersonOption stringToOption(String stringValue) {
    if (stringValue == 'Advocate') {
      return CrmPersonOption.advocate;
    } else if (stringValue == 'Mortgage Broker') {
      return CrmPersonOption.mortgageBroker;
    } else {
      return CrmPersonOption.currencyManager;
    }
  }

  void getAllEmailTemplates() async {
    await ApiController.getAllEmailTemplates(
      onSuccess: (resData) {
        final responseData = jsonDecode(resData);
        allEmailTemplates = responseData;
        setState(() {});
      },
      onError: (errData) {
        ManagerLogInScreenController.showError(
          context,
          jsonDecode(errData),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getAllProperties();
    setAvailableCrmData();
    getSelectedCrmData();
    getAllEmailTemplates();
  }

  Widget getSelectorWidget({
    required bool isSelected,
    required String label,
    required VoidCallback onPress,
  }) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected ? Colors.black : Colors.transparent,
        ),
        child: Text(
          label,
          style: ThemeController.normalTextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget getListEmptyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: CustomBorderButton(
              label: 'add data',
              onTap: () {
                setPersonData();
              }),
        ),
        Lottie.asset(
          'assets/lottie/empty_lottie.json',
          height: 150,
          width: 200,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'No person data is available',
          style: ThemeController.normalTextStyle(
            fontWeight: FontWeight.w900,
          ),
        )
      ],
    );
  }

  Widget getExpansionWidget({
    required List<dynamic> data,
    required String title,
  }) {
    return ExpansionTile(
      title: Row(
        children: [
          Text(
            title,
            style: ThemeController.smallTextStyle(fontWeight: FontWeight.w900),
          ),
          const Spacer(),
          Text(
            data.length.toString(),
            style: ThemeController.smallTextStyle(fontWeight: FontWeight.w900),
          )
        ],
      ),
      children: [
        const SizedBox(
          height: 10,
        ),
        data.isEmpty
            ? getListEmptyWidget()
            : Column(
                children: List.generate(
                  data.length,
                  (index) => Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        // NOTE - Buttons section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              data[index]['crmId'],
                              style: ThemeController.normalTextStyle(
                                  fontWeight: FontWeight.w900),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 150,
                              child: SubmitButton(
                                onButtonPress: () async {
                                  if (data[index]['crmStatus'] ==
                                      "Not-Selected") {
                                    ManagerLogInScreenController
                                        .showLoaderDialog(context);
                                    await ApiController.updateCrmStatus(
                                      {
                                        "crmId": data[index]["crmId"],
                                        "designation": data[index]
                                            ['designation']
                                      },
                                      onSuccess: (resData) {
                                        ManagerLogInScreenController
                                            .showSuccess(
                                          context,
                                          'Message has been updated',
                                        );
                                        Future.delayed(
                                          const Duration(seconds: 2),
                                          () {
                                            html.window.location.reload();
                                          },
                                        );
                                      },
                                      onError: (errData) {
                                        ManagerLogInScreenController.showError(
                                          context,
                                          jsonDecode(errData),
                                        );
                                      },
                                    );
                                  }
                                },
                                buttonLabel:
                                    data[index]['crmStatus'] == 'Not-Selected'
                                        ? 'Assign'
                                        : 'Assigned',
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            CustomBorderButton(
                              label: "Delete",
                              onTap: () async {
                                ManagerLogInScreenController.showLoaderDialog(
                                    context);
                                await ApiController.deleteCrmPerson(
                                  data[index]["crmId"],
                                  onError: (errData) {
                                    ManagerLogInScreenController.showError(
                                      context,
                                      jsonDecode(errData),
                                    );
                                  },
                                  onSuccess: (resData) {
                                    ManagerLogInScreenController.showSuccess(
                                      context,
                                      'Contact has been deleted .',
                                    );
                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      html.window.location.reload();
                                    });
                                  },
                                );
                              },
                              borderColor: Colors.red,
                              labelColor: Colors.red,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            CustomBorderButton(
                              label: "Edit",
                              onTap: () async {
                                if (firstEditNameValue == '' &&
                                    secondEditNameValue == '' &&
                                    phoneEditValue == '' &&
                                    emailEditValue == '') {
                                  ManagerLogInScreenController.showError(
                                      context,
                                      'Please do make changed to edit');
                                } else {
                                  Map<String, dynamic> requestData = {
                                    "firstName": firstEditNameValue == ''
                                        ? data[index]['firstName']
                                        : firstEditNameValue,
                                    "secondName": secondEditNameValue == ''
                                        ? data[index]['secondName']
                                        : secondEditNameValue,
                                    "emailAddress": emailEditValue == ''
                                        ? data[index]['emailAddress']
                                        : emailEditValue,
                                    "phoneNumber": phoneEditValue == ''
                                        ? data[index]['phoneNumber']
                                        : phoneEditValue,
                                    "designation": data[index]['designation'],
                                    "crmId": data[index]['crmId']
                                  };
                                  ManagerLogInScreenController.showLoaderDialog(
                                      context);
                                  await ApiController.editCrmData(
                                    requestData,
                                    onError: (errData) {
                                      ManagerLogInScreenController.showError(
                                        context,
                                        jsonDecode(
                                          errData,
                                        ),
                                      );
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        () {
                                          html.window.location.reload();
                                        },
                                      );
                                    },
                                    onSuccess: (resData) {
                                      ManagerLogInScreenController.showSuccess(
                                        context,
                                        'Data has been edited successfully !!!',
                                      );
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        () {
                                          html.window.location.reload();
                                        },
                                      );
                                    },
                                  );
                                }
                              },
                              borderColor: Colors.blue,
                              labelColor: Colors.blue,
                            )
                          ],
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: CustomTextFormFiled(
                                initialValue: data[index]['firstName'],
                                labelName: 'First name',
                                placeholderText: '',
                                errorText: firstNameEditError,
                                isMandatory: true,
                                onChanged: (notesData) {
                                  firstNameEditError = null;
                                  setState(() {});
                                  if (notesData != null) {
                                    firstEditNameValue = notesData;
                                  } else {
                                    firstNameEditError =
                                        "First name cannot be empty !!!";
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: CustomTextFormFiled(
                                initialValue: data[index]['secondName'],
                                labelName: 'Second name',
                                placeholderText: '',
                                errorText: secondNameEditError,
                                isMandatory: true,
                                onChanged: (notesData) {
                                  secondNameEditError = null;
                                  setState(() {});
                                  if (notesData != null) {
                                    secondEditNameValue = notesData;
                                  } else {
                                    secondNameEditError =
                                        "Second name cannot be empty";
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: CustomTextFormFiled(
                                initialValue: data[index]['emailAddress'],
                                labelName: 'Email address',
                                placeholderText: '',
                                errorText: emailEditError,
                                isMandatory: true,
                                onChanged: (notesData) {
                                  emailEditError = null;
                                  setState(() {});
                                  if (notesData != null) {
                                    emailEditValue = notesData;
                                  } else {
                                    emailEditError =
                                        "Email address cannot be empty !!!";
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: CustomTextFormFiled(
                                initialValue: data[index]['phoneNumber'],
                                labelName: 'Phone number',
                                placeholderText: '',
                                errorText: phoneNumberEditError,
                                isMandatory: true,
                                onChanged: (notesData) {
                                  phoneNumberEditError = null;
                                  setState(() {});
                                  if (notesData != null) {
                                    phoneEditValue = notesData;
                                  } else {
                                    phoneNumberEditError =
                                        "Phone number cannot be empty";
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget getSelectedUserWidget(
    Map<String, dynamic> userData,
    String label,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      padding: const EdgeInsets.all(10),
      child: userData.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: ThemeController.normalTextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Lottie.asset(
                  'assets/lottie/already_present.json',
                  height: 150,
                  width: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "No contact has been assigned",
                    style: ThemeController.normalTextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )
          : Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style: ThemeController.normalTextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Lottie.asset(
                  'assets/lottie/agent_lottie.json',
                  height: 150,
                  width: 200,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '${userData['firstName']} ${userData['secondName']}',
                  style: ThemeController.normalTextStyle(
                    fontWeight: FontWeight.w900,
                    size: 14,
                  ),
                ),
                Text(
                  '${userData['emailAddress']}',
                  style: ThemeController.normalTextStyle(
                    fontWeight: FontWeight.w900,
                    size: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${userData['phoneNumber']}',
                  style: ThemeController.normalTextStyle(
                    fontWeight: FontWeight.w900,
                    size: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
    );
  }

  Widget getCrmWidgets(CrmOptions optionData) {
    switch (optionData) {
      case CrmOptions.addEntry:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: CustomTextFormFiled(
                    initialValue: '',
                    labelName: 'First name',
                    placeholderText: '',
                    errorText: firstNameError,
                    isMandatory: true,
                    onChanged: (notesData) {
                      clearFirstNameError();
                      if (notesData != null) {
                        firstNameValue = notesData;
                      } else {
                        setFirstNameError("First name cannot be empty !!!");
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: CustomTextFormFiled(
                    initialValue: secondNameValue,
                    labelName: 'Second name',
                    placeholderText: '',
                    errorText: secondNameError,
                    isMandatory: true,
                    onChanged: (notesData) {
                      clearSecondNameError();
                      if (notesData != null) {
                        secondNameValue = notesData;
                      } else {
                        setSecondNameError("Second name cannot be empty");
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: CustomTextFormFiled(
                    initialValue: '',
                    labelName: 'Email address',
                    placeholderText: '',
                    errorText: emailError,
                    isMandatory: true,
                    onChanged: (notesData) {
                      clearEmailError();
                      if (notesData != null) {
                        emailValue = notesData;
                      } else {
                        setEmailError("Email address cannot be empty !!!");
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: CustomTextFormFiled(
                    initialValue: '',
                    labelName: 'Phone number',
                    placeholderText: '',
                    errorText: phoneNumberError,
                    isMandatory: true,
                    onChanged: (notesData) {
                      clearPhoneError();
                      if (notesData != null) {
                        phoneValue = notesData;
                      } else {
                        setPhoneError("Phone number cannot be empty");
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                getSelectorWidget(
                  isSelected: crmPersonOption == CrmPersonOption.advocate,
                  label: 'Advocate',
                  onPress: () {
                    changeCrmPersonOption(CrmPersonOption.advocate);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                getSelectorWidget(
                  isSelected:
                      crmPersonOption == CrmPersonOption.currencyManager,
                  label: 'Currency Manager',
                  onPress: () {
                    changeCrmPersonOption(CrmPersonOption.currencyManager);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                getSelectorWidget(
                  isSelected: crmPersonOption == CrmPersonOption.mortgageBroker,
                  label: 'Mortgage Broker',
                  onPress: () {
                    changeCrmPersonOption(CrmPersonOption.mortgageBroker);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.2,
              child: SubmitButton(
                onButtonPress: () async {
                  if (firstNameValue.isEmpty) {
                    setFirstNameError("First name cannot be empty");
                  }
                  if (secondNameValue.isEmpty) {
                    setSecondNameError("Second name cannot be empty");
                  }
                  if (emailValue.isEmpty) {
                    setEmailError("email cannot be empty");
                  }
                  if (phoneValue.isEmpty) {
                    setPhoneError("Phone number cannot be empty");
                  }
                  if (firstNameValue.isNotEmpty &&
                      secondNameValue.isNotEmpty &&
                      emailValue.isNotEmpty &&
                      phoneValue.isNotEmpty) {
                    Map<String, dynamic> requestData = {
                      "firstName": firstNameValue,
                      "secondName": secondNameValue,
                      "emailAddress": emailValue,
                      "phoneNumber": phoneValue,
                      "designation": crmPersonOptionToString(crmPersonOption)
                    };
                    ManagerLogInScreenController.showLoaderDialog(context);
                    await ApiController.addCrmData(
                      requestData,
                      onError: (errData) {
                        ManagerLogInScreenController.showError(
                          context,
                          jsonDecode(
                            errData,
                          ),
                        );
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            html.window.location.reload();
                          },
                        );
                      },
                      onSuccess: (resData) {
                        ManagerLogInScreenController.showSuccess(
                          context,
                          'Data has been added successfully !!!',
                        );
                        Future.delayed(
                          const Duration(seconds: 2),
                          () {
                            html.window.location.reload();
                          },
                        );
                      },
                    );
                  }
                },
                buttonLabel: 'Submit',
              ),
            )
          ],
        );
      case CrmOptions.listEntry:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getSelectedUserWidget(selectedAdvocate, 'Advocate'),
                getSelectedUserWidget(
                    selectedCurrencyManager, 'Currency Manager'),
                getSelectedUserWidget(
                  selectedMortgageBroker,
                  'Mortgage Broker',
                ),
              ],
            ),
            getExpansionWidget(data: crmAdvocate, title: 'Advocates'),
            const SizedBox(
              height: 10,
            ),
            getExpansionWidget(
                data: crmCurrencyManager, title: 'Currency Manager'),
            const SizedBox(
              height: 10,
            ),
            getExpansionWidget(
                data: crmMortgageBroker, title: 'Mortgage Broker'),
            const SizedBox(
              height: 10,
            ),
          ],
        );
    }
  }

  Widget getRightSectionAreaWidget(PropertyManagementOption optionData) {
    switch (optionData) {
      case PropertyManagementOption.addProperty:
        return PropertyAdditionForm(
          onSubmitPress: (formData) async {
            ManagerLogInScreenController.showLoaderDialog(context);
            if (formData['propertyImages'].isEmpty) {
              formData['propertyImages'].addAll([
                "https://plus.unsplash.com/premium_photo-1686090449192-4ab1d00cb735?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://plus.unsplash.com/premium_photo-1687960117069-567a456fe5f3?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1483097365279-e8acd3bf9f18?q=80&w=2011&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1516156008625-3a9d6067fab5?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1498373419901-52eba931dc4f?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                "https://images.unsplash.com/photo-1472224371017-08207f84aaae?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
              ]);
            }
            await ApiController.sendPropertyAdditionRequest(
              formData,
              onSuccess: (data) {
                ManagerLogInScreenController.showSuccess(
                    context, 'Property has been added !!!');
                Future.delayed(const Duration(seconds: 2), () {
                  html.window.location.reload();
                });
              },
              onError: (data) {
                ManagerLogInScreenController.hideDialogBox(context);
                ManagerLogInScreenController.showError(
                  context,
                  jsonDecode(data),
                );
              },
            );
          },
          propertyId: "PPT-BLR-20250625-0001",
          initialValue: null,
          agentId: widget.agentId,
        );
      case PropertyManagementOption.listProperty:
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.86,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All properties",
                  style: ThemeController.normalTextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: List.generate(
                    allProperties.length,
                    (index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 280,
                            child: ManagerPropertyUnitTileWidget(
                              propertyInfo: allProperties[index],
                              onViewMorePress: () {
                                context.go(
                                  '/manager-property-info-screen/${allProperties[index]['propertyId']}/${widget.agentId}',
                                );
                              },
                              onCarouselPress: () {
                                final List<String> urls = (allProperties[index]
                                        ["propertyImages"] as List)
                                    .cast<String>();
                                GlobalWidgets.showImageViewerDialog(
                                  context,
                                  imageUrls: urls,
                                  title: "Property glance",
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      case PropertyManagementOption.crmPortal:
        // TODO - CRM Portal
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "CRM Portal",
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                OptionLabelSelectorWidget(
                  isEnabled: crmOption == CrmOptions.addEntry,
                  onPress: () {
                    changeCrmOption(CrmOptions.addEntry);
                  },
                  optionLabel: 'Add Entry',
                ),
                const SizedBox(
                  width: 10,
                ),
                OptionLabelSelectorWidget(
                  isEnabled: crmOption == CrmOptions.listEntry,
                  onPress: () {
                    changeCrmOption(CrmOptions.listEntry);
                  },
                  optionLabel: 'List entries',
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            getCrmWidgets(crmOption)
          ],
        );

      case PropertyManagementOption.emailTemplate:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Email template playground",
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (allEmailTemplates.isNotEmpty && allEmailTemplates != {})
              ExpansionTile(
                title: Text(
                  "Welcome email content",
                  style: ThemeController.smallTextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomBorderButton(
                      label: "Edit template",
                      onTap: () async {
                        String? templateData =
                            await HtmlEditorDialog.showHtmlEditorDialogWeb(
                          context,
                          initialHtml:
                              allEmailTemplates["welcome_email_template"],
                        );
                        if (templateData != null) {
                          if (templateData !=
                              allEmailTemplates["welcome_email_template"]) {
                            if (mounted) {
                              ManagerLogInScreenController.showLoaderDialog(
                                  context);
                            }
                            await ApiController.updateEmailTemplate(
                              {
                                "key_value": "welcome_email_template",
                                "updated_html_content": templateData,
                              },
                              onSuccess: (resData) {
                                ManagerLogInScreenController.showSuccess(
                                    context,
                                    'Email template has been updated !!!');
                                Future.delayed(
                                  const Duration(seconds: 2),
                                  () {
                                    html.window.location.reload();
                                  },
                                );
                              },
                              onError: (errData) {
                                ManagerLogInScreenController.hideDialogBox(
                                    context);
                                ManagerLogInScreenController.showError(
                                  context,
                                  jsonDecode(errData),
                                );
                              },
                            );
                          } else {}
                        } else {}
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  HtmlRenderer(
                    html: allEmailTemplates["welcome_email_template"],
                  ),
                ],
              ),
            if (allEmailTemplates.isNotEmpty && allEmailTemplates != {})
              const SizedBox(
                height: 10,
              ),
            if (allEmailTemplates.isNotEmpty && allEmailTemplates != {})
              ExpansionTile(
                title: Text(
                  "Advocate Email Content",
                  style: ThemeController.smallTextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomBorderButton(
                      label: "Edit template",
                      onTap: () async {
                        String? templateData =
                            await HtmlEditorDialog.showHtmlEditorDialogWeb(
                          context,
                          initialHtml:
                              allEmailTemplates["advocate_email_template"],
                        );
                        if (templateData != null) {
                          if (templateData !=
                              allEmailTemplates["advocate_email_template"]) {
                            if (mounted) {
                              ManagerLogInScreenController.showLoaderDialog(
                                  context);
                            }
                            await ApiController.updateEmailTemplate(
                              {
                                "key_value": "advocate_email_template",
                                "updated_html_content": templateData,
                              },
                              onSuccess: (resData) {
                                ManagerLogInScreenController.showSuccess(
                                    context,
                                    'Email template has been updated !!!');
                                Future.delayed(
                                  const Duration(seconds: 2),
                                  () {
                                    html.window.location.reload();
                                  },
                                );
                              },
                              onError: (errData) {
                                ManagerLogInScreenController.hideDialogBox(
                                    context);
                                ManagerLogInScreenController.showError(
                                  context,
                                  jsonDecode(errData),
                                );
                              },
                            );
                          } else {}
                        } else {}
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  HtmlRenderer(
                    html: allEmailTemplates["advocate_email_template"],
                  ),
                ],
              ),
            if (allEmailTemplates.isNotEmpty && allEmailTemplates != {})
              const SizedBox(
                height: 10,
              ),
            if (allEmailTemplates.isNotEmpty && allEmailTemplates != {})
              ExpansionTile(
                title: Text(
                  "Currency Manager Email Content",
                  style: ThemeController.smallTextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomBorderButton(
                      label: "Edit template",
                      onTap: () async {
                        String? templateData =
                            await HtmlEditorDialog.showHtmlEditorDialogWeb(
                          context,
                          initialHtml: allEmailTemplates[
                              "currency_manager_email_template"],
                        );
                        if (templateData != null) {
                          if (templateData !=
                              allEmailTemplates[
                                  "currency_manager_email_template"]) {
                            if (mounted) {
                              ManagerLogInScreenController.showLoaderDialog(
                                  context);
                            }
                            await ApiController.updateEmailTemplate(
                              {
                                "key_value": "currency_manager_email_template",
                                "updated_html_content": templateData,
                              },
                              onSuccess: (resData) {
                                ManagerLogInScreenController.showSuccess(
                                    context,
                                    'Email template has been updated !!!');
                                Future.delayed(
                                  const Duration(seconds: 2),
                                  () {
                                    html.window.location.reload();
                                  },
                                );
                              },
                              onError: (errData) {
                                ManagerLogInScreenController.hideDialogBox(
                                    context);
                                ManagerLogInScreenController.showError(
                                  context,
                                  jsonDecode(errData),
                                );
                              },
                            );
                          } else {}
                        } else {}
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  HtmlRenderer(
                    html: allEmailTemplates["currency_manager_email_template"],
                  ),
                ],
              ),
            if (allEmailTemplates.isNotEmpty && allEmailTemplates != {})
              const SizedBox(
                height: 10,
              ),
            if (allEmailTemplates.isNotEmpty && allEmailTemplates != {})
              ExpansionTile(
                title: Text(
                  "Mortgage Manager Email Content",
                  style: ThemeController.smallTextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: CustomBorderButton(
                      label: "Edit template",
                      onTap: () async {
                        String? templateData =
                            await HtmlEditorDialog.showHtmlEditorDialogWeb(
                          context,
                          initialHtml: allEmailTemplates[
                              "mortage_manager_email_template"],
                        );
                        if (templateData != null) {
                          if (templateData !=
                              allEmailTemplates[
                                  "mortage_manager_email_template"]) {
                            if (mounted) {
                              ManagerLogInScreenController.showLoaderDialog(
                                  context);
                            }
                            await ApiController.updateEmailTemplate(
                              {
                                "key_value": "mortage_manager_email_template",
                                "updated_html_content": templateData,
                              },
                              onSuccess: (resData) {
                                ManagerLogInScreenController.showSuccess(
                                    context,
                                    'Email template has been updated !!!');
                                Future.delayed(
                                  const Duration(seconds: 2),
                                  () {
                                    html.window.location.reload();
                                  },
                                );
                              },
                              onError: (errData) {
                                ManagerLogInScreenController.hideDialogBox(
                                    context);
                                ManagerLogInScreenController.showError(
                                  context,
                                  jsonDecode(errData),
                                );
                              },
                            );
                          } else {}
                        } else {}
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  HtmlRenderer(
                    html: allEmailTemplates["mortage_manager_email_template"],
                  ),
                ],
              ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const DashboardMainLogoSection(),
                  const Spacer(),
                  Row(
                    children: [
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.dashboard,
                        iconData: Icons.dashboard,
                        optionLabel: 'Dashboard',
                        onTap: () {
                          context.go(
                            '/manager-dashboard-screen',
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.listings,
                        iconData: Icons.list,
                        optionLabel: 'Listings',
                        onTap: () {
                          changeDashboardOption(
                            ManagerDashboardOption.listings,
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.agents,
                        iconData: Icons.support_agent,
                        optionLabel: 'Agents',
                        onTap: () {
                          context.go(
                            '/manager-agent-info-section-screen',
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.clients,
                        iconData: Icons.dashboard_customize_rounded,
                        optionLabel: 'Clients',
                        onTap: () {
                          context.go(
                              '/manager-client-info-screen/CLT-BLR-20221117-0001/basicInfo');
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  ManagerInfoWidget(
                    onProfilePress: () {},
                    managerId: 'MNG-BLR-20250625-0001',
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.86,
                    decoration: BoxDecoration(
                      color: ThemeController.pageBackgroundSecondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(15),
                      children: [
                        QuickActionWidget(
                          label: 'Add Property',
                          onPress: () {
                            changePropertyOption(
                                PropertyManagementOption.addProperty);
                          },
                          isSelected: propertyManagementOption ==
                              PropertyManagementOption.addProperty,
                          icons: Icons.home,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        QuickActionWidget(
                          label: 'List Properties',
                          onPress: () {
                            changePropertyOption(
                              PropertyManagementOption.listProperty,
                            );
                          },
                          isSelected: propertyManagementOption ==
                              PropertyManagementOption.listProperty,
                          icons: Icons.menu,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        QuickActionWidget(
                          label: 'Contacts',
                          onPress: () {
                            changePropertyOption(
                              PropertyManagementOption.crmPortal,
                            );
                          },
                          isSelected: propertyManagementOption ==
                              PropertyManagementOption.crmPortal,
                          icons: Icons.person,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        QuickActionWidget(
                          label: 'Email Template',
                          onPress: () {
                            changePropertyOption(
                              PropertyManagementOption.emailTemplate,
                            );
                          },
                          isSelected: propertyManagementOption ==
                              PropertyManagementOption.emailTemplate,
                          icons: Icons.mail,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  // NOTE Empty Gap
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ThemeController.pageBackgroundSecondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          getRightSectionAreaWidget(propertyManagementOption),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
