import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/option_label_selector_widget.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/break_points.dart';
import 'package:algarve_house_hunters_system/global_widgets/border_button.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/global_widgets/html_renderer.dart';
import 'package:algarve_house_hunters_system/global_widgets/manager_bottom_nav_bar.dart';
import 'package:algarve_house_hunters_system/global_widgets/property_addition_form.dart';
import 'package:algarve_house_hunters_system/global_widgets/rich_text_editor_dialog_box.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/view/manager_log_in_screen.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/controller/manager_property_management_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/manager_property_unit_tile_widget.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/mobile_property_tile_widget.dart';
import 'package:algarve_house_hunters_system/manager_property_management_screen/widgets/quick_action_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _crmCarouselController =
      PageController(viewportFraction: 0.92);
  int _crmCarouselPage = 0;
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

  Map<String, dynamic>? uploadAnalyzer;

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

  //ANCHOR Upload Handler

  Future<void> pickAndUploadCSV() async {
    FilePickerResult? picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      withData: true, // IMPORTANT for Web
    );

    if (picked == null) return;

    final PlatformFile file = picked.files.first;

    // setState(() => csvLoadingState = true);

    await ApiController.uploadPropertyImport(
      file.bytes!,
      file.name,
      onError: (errData) {
        print("Upload error has occured");
        ManagerLogInScreenController.showError(
            context, jsonDecode(errData).toString());
      },
      onSuccess: (resData) {
        print("Upload success has occured !!!");
        uploadAnalyzer = jsonDecode(resData);
        setState(() {});
      },
    );

    // setState(() => csvLoadingState = false);
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

  @override
  void dispose() {
    _crmCarouselController.dispose();
    super.dispose();
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
                Row(
                  children: [
                    Text(
                      "All properties",
                      style: ThemeController.normalTextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    AddMoreButton(
                      onButtonPress: () {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        ApiController.exportPropertiesWeb(context);
                        ManagerLogInScreenController.hideDialogBox(context);
                      },
                      buttonLabel: "Export",
                      iconData: Icons.download,
                    )
                  ],
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

      case PropertyManagementOption.import:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Property import Option",
                  style: ThemeController.normalTextStyle(
                    fontWeight: FontWeight.w900,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Upload your excel file to bulk add properties to the systems.",
                  style: ThemeController.normalTextStyle(
                    fontWeight: FontWeight.w400,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              DottedBorder(
                radius: Radius.circular(100),
                dashPattern: [10, 5],
                color: Colors.grey,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 30,
                        child: Icon(
                          Icons.upload,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Tap to browse",
                        style: ThemeController.normalTextStyle(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Supports only excel files. \n Max entries 500.",
                        style: ThemeController.normalTextStyle(),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      SubmitButton(
                        onButtonPress: () async {
                          // NOTE Adding the loader
                          if (context.mounted) {
                            ManagerLogInScreenController.showLoaderDialog(
                                context);
                          }
                          // TODO Add the method
                          await pickAndUploadCSV();
                          // NOTE Updating the properties
                          if (uploadAnalyzer != null) {
                            uploadAnalyzer!["employee_id"] = widget.agentId;
                            ApiController.importProperties(
                              uploadAnalyzer!,
                              onSuccess: (resData) {
                                ManagerLogInScreenController.showSuccess(
                                  context,
                                  "${uploadAnalyzer!["count"]} properties has been added",
                                );
                                Future.delayed(const Duration(seconds: 2), () {
                                  if (context.mounted) {
                                    ManagerLogInScreenController.hideDialogBox(
                                        context);
                                  }
                                });
                              },
                              onError: (errData) {
                                ManagerLogInScreenController.showError(
                                  context,
                                  errData,
                                );
                                Future.delayed(const Duration(seconds: 2), () {
                                  if (context.mounted) {
                                    ManagerLogInScreenController.hideDialogBox(
                                        context);
                                  }
                                });
                              },
                            );
                          }
                        },
                        buttonLabel: "Select Files",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        );
    }
  }

  // NOTE Mobile header banner — same as the dashboard mobile view, with a
  // drawer (menu) trigger on the left.
  Widget getMobileHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
          Image.asset(
            AssetsController.mainLogoPath,
            height: 40,
            width: 40,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Algarve House Hunters",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: ThemeController.normalTextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ManagerInfoWidget(
            onProfilePress: () {},
            managerId: 'MNG-BLR-20250625-0001',
            textColor: Colors.white,
            compact: true,
          ),
        ],
      ),
    );
  }

  // NOTE Mobile "List Properties" — vertical property cards.
  Widget getMobileListProperties() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Properties',
              style: ThemeController.titleTextStyle(),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                ManagerLogInScreenController.showLoaderDialog(context);
                ApiController.exportPropertiesWeb(context);
                ManagerLogInScreenController.hideDialogBox(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Export',
                    style: ThemeController.normalTextStyle(
                      fontWeight: FontWeight.w800,
                      size: 13,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.download,
                    size: 18,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (allProperties.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          )
        else
          Column(
            children: List.generate(
              allProperties.length,
              (index) {
                final property = allProperties[index];
                final bool hasImages =
                    (property["propertyImages"] as List?)?.isNotEmpty ?? false;
                return MobilePropertyTileWidget(
                  propertyInfo: property,
                  onViewDetailsPress: () {
                    context.go(
                      '/manager-property-info-screen/${property['propertyId']}/${widget.agentId}',
                    );
                  },
                  onImagePress: hasImages
                      ? () {
                          final List<String> urls =
                              (property["propertyImages"] as List)
                                  .cast<String>();
                          GlobalWidgets.showImageViewerDialog(
                            context,
                            imageUrls: urls,
                            title: "Property glance",
                          );
                        }
                      : null,
                );
              },
            ),
          ),
      ],
    );
  }

  // NOTE Shared CRM add-entry submission.
  Future<void> submitCrmEntry() async {
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
          ManagerLogInScreenController.showError(context, jsonDecode(errData));
          Future.delayed(const Duration(seconds: 2), () {
            html.window.location.reload();
          });
        },
        onSuccess: (resData) {
          ManagerLogInScreenController.showSuccess(
            context,
            'Data has been added successfully !!!',
          );
          Future.delayed(const Duration(seconds: 2), () {
            html.window.location.reload();
          });
        },
      );
    }
  }

  // NOTE Mobile CRM portal section.
  Widget _crmTogglePill(String label, bool selected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? Colors.black : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: ThemeController.normalTextStyle(
            color: selected ? Colors.white : Colors.black,
            fontWeight: FontWeight.w800,
            size: 13,
          ),
        ),
      ),
    );
  }

  Widget getMobileCrmAddForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormFiled(
          initialValue: '',
          labelName: 'First name',
          placeholderText: 'e.g. Jonathan',
          errorText: firstNameError,
          isMandatory: true,
          onChanged: (data) {
            clearFirstNameError();
            firstNameValue = data;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormFiled(
          initialValue: '',
          labelName: 'Second name',
          placeholderText: 'e.g. Miller',
          errorText: secondNameError,
          isMandatory: true,
          onChanged: (data) {
            clearSecondNameError();
            secondNameValue = data;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormFiled(
          initialValue: '',
          labelName: 'Email address',
          placeholderText: 'jonathan.miller@example.com',
          errorText: emailError,
          isMandatory: true,
          onChanged: (data) {
            clearEmailError();
            emailValue = data;
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormFiled(
          initialValue: '',
          labelName: 'Phone number',
          placeholderText: '+1 (555) 000-0000',
          errorText: phoneNumberError,
          isMandatory: true,
          onChanged: (data) {
            clearPhoneError();
            phoneValue = data;
          },
        ),
        const SizedBox(height: 16),
        GlobalWidgets.getTextLabelWidget('Role Designation', isMandatory: true),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius:
                BorderRadius.circular(ThemeController.textFieldBorderRadius),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CrmPersonOption>(
              isExpanded: true,
              value: crmPersonOption,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: [
                DropdownMenuItem(
                  value: CrmPersonOption.advocate,
                  child: Text(crmPersonOptionToString(CrmPersonOption.advocate)),
                ),
                DropdownMenuItem(
                  value: CrmPersonOption.currencyManager,
                  child: Text(crmPersonOptionToString(
                      CrmPersonOption.currencyManager)),
                ),
                DropdownMenuItem(
                  value: CrmPersonOption.mortgageBroker,
                  child: Text(crmPersonOptionToString(
                      CrmPersonOption.mortgageBroker)),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  changeCrmPersonOption(val);
                }
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        InkWell(
          onTap: () => submitCrmEntry(),
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Submit",
                  style: ThemeController.normalTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.send, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _deleteCrmProfessional(String crmId) async {
    ManagerLogInScreenController.showLoaderDialog(context);
    await ApiController.deleteCrmPerson(
      crmId,
      onError: (errData) {
        ManagerLogInScreenController.showError(context, jsonDecode(errData));
      },
      onSuccess: (resData) {
        ManagerLogInScreenController.showSuccess(
            context, 'Contact has been deleted .');
        Future.delayed(const Duration(seconds: 2), () {
          html.window.location.reload();
        });
      },
    );
  }

  Widget _crmInfoPill(String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: ThemeController.smallTextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w700,
              size: 11,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: ThemeController.normalTextStyle(
              fontWeight: FontWeight.w800,
              size: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _assignProfessionalButton(String role) {
    return InkWell(
      onTap: () {
        // Jump to the Add Entry form with this role pre-selected.
        changeCrmPersonOption(stringToOption(role));
        changeCrmOption(CrmOptions.addEntry);
      },
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          "Assign New Professional",
          style: ThemeController.normalTextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            size: 14,
          ),
        ),
      ),
    );
  }

  Widget _emptyProfessionalCard(String role) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(24),
      dashPattern: const [8, 5],
      color: Colors.grey.shade400,
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey.withOpacity(0.15),
              child: Icon(
                Icons.person_off_outlined,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No Professional Assigned",
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w900,
                size: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Please assign a professional to manage this role and start collaborating.",
              textAlign: TextAlign.center,
              style: ThemeController.normalTextStyle(
                color: Colors.grey.shade600,
                size: 14,
              ),
            ),
            const SizedBox(height: 20),
            _assignProfessionalButton(role),
          ],
        ),
      ),
    );
  }

  Widget _assignedProfessionalCard(String role, Map<String, dynamic> data) {
    final String crmId = (data['crmId'] ?? '').toString();
    final String fullName =
        "${data['firstName'] ?? ''} ${data['secondName'] ?? ''}".trim();
    final String email = (data['emailAddress'] ?? '').toString();
    final String phone = (data['phoneNumber'] ?? '').toString();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "REFERENCE ID",
                      style: ThemeController.smallTextStyle(
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w700,
                        size: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      crmId,
                      style: ThemeController.titleTextStyle(size: 18),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => _deleteCrmProfessional(crmId),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  // Edit jumps to the Add Entry form with this role selected.
                  changeCrmPersonOption(stringToOption(role));
                  changeCrmOption(CrmOptions.addEntry);
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    "Edit",
                    style: ThemeController.normalTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      size: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _crmInfoPill("FULL NAME", fullName),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _crmInfoPill("EMAIL", email)),
              const SizedBox(width: 12),
              Expanded(child: _crmInfoPill("PHONE", phone)),
            ],
          ),
          const SizedBox(height: 16),
          _assignProfessionalButton(role),
        ],
      ),
    );
  }

  Widget getMobileSelectedProfessionalsCarousel() {
    final roles = [
      {'label': 'Advocate', 'data': selectedAdvocate},
      {'label': 'Currency Manager', 'data': selectedCurrencyManager},
      {'label': 'Mortgage Broker', 'data': selectedMortgageBroker},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: _crmCarouselController,
            itemCount: roles.length,
            onPageChanged: (i) => setState(() => _crmCarouselPage = i),
            itemBuilder: (context, index) {
              final label = roles[index]['label'] as String;
              final data = roles[index]['data'] as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: ThemeController.normalTextStyle(
                        fontWeight: FontWeight.w900,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        child: data.isEmpty
                            ? _emptyProfessionalCard(label)
                            : _assignedProfessionalCard(label, data),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            roles.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 8,
              width: _crmCarouselPage == i ? 20 : 8,
              decoration: BoxDecoration(
                color: _crmCarouselPage == i ? Colors.black : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _assignCrmPerson(Map<String, dynamic> person) async {
    ManagerLogInScreenController.showLoaderDialog(context);
    await ApiController.updateCrmStatus(
      {
        "crmId": person["crmId"],
        "designation": person['designation'],
      },
      onSuccess: (resData) {
        ManagerLogInScreenController.showSuccess(
            context, 'Message has been updated');
        Future.delayed(const Duration(seconds: 2), () {
          html.window.location.reload();
        });
      },
      onError: (errData) {
        ManagerLogInScreenController.showError(context, jsonDecode(errData));
      },
    );
  }

  void _editCrmDialog(Map<String, dynamic> person) {
    String firstName = (person['firstName'] ?? '').toString();
    String secondName = (person['secondName'] ?? '').toString();
    String email = (person['emailAddress'] ?? '').toString();
    String phone = (person['phoneNumber'] ?? '').toString();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Contact'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextFormFiled(
                initialValue: firstName,
                labelName: 'First name',
                placeholderText: '',
                isMandatory: true,
                onChanged: (v) => firstName = v,
              ),
              const SizedBox(height: 12),
              CustomTextFormFiled(
                initialValue: secondName,
                labelName: 'Second name',
                placeholderText: '',
                isMandatory: true,
                onChanged: (v) => secondName = v,
              ),
              const SizedBox(height: 12),
              CustomTextFormFiled(
                initialValue: email,
                labelName: 'Email address',
                placeholderText: '',
                isMandatory: true,
                onChanged: (v) => email = v,
              ),
              const SizedBox(height: 12),
              CustomTextFormFiled(
                initialValue: phone,
                labelName: 'Phone number',
                placeholderText: '',
                isMandatory: true,
                onChanged: (v) => phone = v,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final requestData = {
                "firstName": firstName,
                "secondName": secondName,
                "emailAddress": email,
                "phoneNumber": phone,
                "designation": person['designation'],
                "crmId": person['crmId'],
              };
              ManagerLogInScreenController.showLoaderDialog(context);
              await ApiController.editCrmData(
                requestData,
                onError: (errData) {
                  ManagerLogInScreenController.showError(
                      context, jsonDecode(errData));
                  Future.delayed(const Duration(seconds: 2), () {
                    html.window.location.reload();
                  });
                },
                onSuccess: (resData) {
                  ManagerLogInScreenController.showSuccess(
                      context, 'Data has been edited successfully !!!');
                  Future.delayed(const Duration(seconds: 2), () {
                    html.window.location.reload();
                  });
                },
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _crmPersonCard(Map<String, dynamic> person) {
    final bool selected =
        (person['crmStatus'] ?? 'Not-Selected') != 'Not-Selected';
    final String name =
        "${person['firstName'] ?? ''} ${person['secondName'] ?? ''}".trim();
    final String phone = (person['phoneNumber'] ?? '').toString();
    final String crmId = (person['crmId'] ?? '').toString();

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: selected ? null : Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: selected
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            child: Icon(
              Icons.person,
              color: selected ? Colors.white : Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: ThemeController.normalTextStyle(
                    color: selected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w900,
                    size: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: ThemeController.smallTextStyle(
                    color: selected ? Colors.white70 : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _editCrmDialog(person),
            child: Icon(
              Icons.edit,
              color: selected ? Colors.white : Colors.blue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: () => _deleteCrmProfessional(crmId),
            child: Icon(
              selected ? Icons.delete : Icons.delete_outline,
              color: selected ? Colors.white : Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          if (selected)
            const CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: Icon(Icons.check, color: Colors.black, size: 16),
            )
          else
            InkWell(
              onTap: () => _assignCrmPerson(person),
              child: Icon(Icons.chevron_right, color: Colors.grey.shade500),
            ),
        ],
      ),
    );
  }

  Widget getMobileCrmExpansion({
    required List<dynamic> data,
    required String title,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 12),
              Text(
                title,
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                  size: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data.length.toString(),
                  style: ThemeController.smallTextStyle(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          children: [
            if (data.isEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "No contacts available",
                  style: ThemeController.normalTextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              )
            else
              ...data.map<Widget>((person) =>
                  _crmPersonCard(person as Map<String, dynamic>)),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget getMobileCrmListEntries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getMobileSelectedProfessionalsCarousel(),
        const SizedBox(height: 24),
        Text(
          "All Entries",
          style: ThemeController.titleTextStyle(),
        ),
        const SizedBox(height: 16),
        getMobileCrmExpansion(
          data: crmAdvocate,
          title: 'Advocates',
          icon: Icons.gavel,
        ),
        getMobileCrmExpansion(
          data: crmCurrencyManager,
          title: 'Currency Manager',
          icon: Icons.currency_exchange,
        ),
        getMobileCrmExpansion(
          data: crmMortgageBroker,
          title: 'Mortgage Broker',
          icon: Icons.home_outlined,
        ),
      ],
    );
  }

  Widget getMobileCrmSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CRM Portal",
          style: ThemeController.titleTextStyle(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _crmTogglePill(
              'Add Entry',
              crmOption == CrmOptions.addEntry,
              () => changeCrmOption(CrmOptions.addEntry),
            ),
            const SizedBox(width: 10),
            _crmTogglePill(
              'List entries',
              crmOption == CrmOptions.listEntry,
              () => changeCrmOption(CrmOptions.listEntry),
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (crmOption == CrmOptions.addEntry)
          getMobileCrmAddForm()
        else
          getMobileCrmListEntries(),
      ],
    );
  }

  // NOTE Left navigation drawer (image 2 style).
  Widget _drawerTile({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.grey.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(width: 16),
            Text(
              label,
              style: ThemeController.normalTextStyle(
                fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMobileDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                children: [
                  _drawerTile(
                    icon: Icons.home,
                    label: 'Add Property',
                    selected: propertyManagementOption ==
                        PropertyManagementOption.addProperty,
                    onTap: () {
                      changePropertyOption(
                          PropertyManagementOption.addProperty);
                      Navigator.pop(context);
                    },
                  ),
                  _drawerTile(
                    icon: Icons.menu,
                    label: 'List Properties',
                    selected: propertyManagementOption ==
                        PropertyManagementOption.listProperty,
                    onTap: () {
                      changePropertyOption(
                          PropertyManagementOption.listProperty);
                      Navigator.pop(context);
                    },
                  ),
                  _drawerTile(
                    icon: Icons.import_contacts,
                    label: 'Import Properties',
                    selected: propertyManagementOption ==
                        PropertyManagementOption.import,
                    onTap: () {
                      changePropertyOption(PropertyManagementOption.import);
                      Navigator.pop(context);
                    },
                  ),
                  _drawerTile(
                    icon: Icons.person,
                    label: 'Contacts',
                    selected: propertyManagementOption ==
                        PropertyManagementOption.crmPortal,
                    onTap: () {
                      changePropertyOption(PropertyManagementOption.crmPortal);
                      Navigator.pop(context);
                    },
                  ),
                  _drawerTile(
                    icon: Icons.mail,
                    label: 'Email Template',
                    selected: propertyManagementOption ==
                        PropertyManagementOption.emailTemplate,
                    onTap: () {
                      changePropertyOption(
                          PropertyManagementOption.emailTemplate);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile =
        MediaQuery.of(context).size.width < Breakpoints.mobile;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      drawer: getMobileDrawer(),
      bottomNavigationBar: isMobile
          ? const ManagerBottomNavBar(
              currentOption: ManagerDashboardOption.listings,
            )
          : null,
      body: LayoutBuilder(builder: (context, constraints) {
        double width = constraints.maxWidth;
        // NOTE Mobile View
        if (width < Breakpoints.mobile) {
          return SingleChildScrollView(
            child: Column(
              children: [
                getMobileHeaderBanner(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: propertyManagementOption ==
                          PropertyManagementOption.listProperty
                      ? getMobileListProperties()
                      : propertyManagementOption ==
                              PropertyManagementOption.crmPortal
                          ? getMobileCrmSection()
                          : getRightSectionAreaWidget(propertyManagementOption),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        }
        // NOTE Tablet View
        else if (width < Breakpoints.tablet) {
          return Container();
        }
        // NOTE Web View
        else {
          return SingleChildScrollView(
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
                          label: 'Import Properties',
                          onPress: () {
                            changePropertyOption(
                              PropertyManagementOption.import,
                            );
                          },
                          isSelected: propertyManagementOption ==
                              PropertyManagementOption.import,
                          icons: Icons.import_contacts,
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
          );
        }
      }),
    );
  }
}
