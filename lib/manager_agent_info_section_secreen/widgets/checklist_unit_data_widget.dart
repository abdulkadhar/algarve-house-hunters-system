import 'dart:convert';
import 'dart:html' as html;
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/toggle_switch_widget.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_controller/global_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/border_button.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_button.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/date_time_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/first_call_status_label_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/html_renderer.dart';
import 'package:algarve_house_hunters_system/global_widgets/rich_text_editor_dialog_box.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';

class CheckListUnitDataWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isOn;
  final Function(bool) onTogglePress;
  final bool isEnabled;
  final int index;
  final Map<String, dynamic>? userData;
  final Map<String, dynamic>? clientData;
  final String checklistId;
  final String agentId;
  const CheckListUnitDataWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTogglePress,
    required this.isOn,
    required this.agentId,
    this.isEnabled = true,
    this.index = 0,
    this.userData,
    this.clientData,
    this.checklistId = '',
  });

  @override
  State<CheckListUnitDataWidget> createState() =>
      _CheckListUnitDataWidgetState();
}

class _CheckListUnitDataWidgetState extends State<CheckListUnitDataWidget> {
  Map<String, dynamic> selectedAdvocate = {};
  Map<String, dynamic> selectedCurrencyManager = {};
  Map<String, dynamic> selectedMortgageBroker = {};
  bool _isOn = false;

  // NOTE - Initial call data holder
  Map<String, dynamic> initialCallDataHolder = {
    "hear_about_us": "",
    "read_review": "",
    "they_from": "",
    "live_now": "",
    "why_portugal": "",
    "buying_alone": "",
    "holiday_permanent": "",
    "they_in_process": "",
    "plan_to_purchase": "",
    "stage_they_are_at": "",
    "mortage_broker": "",
    "lawyer_recommendation": "",
    "understand_buying_process": "",
    "explain_proactively": "",
    "survey": "",
    "discuss_exclusivity": "",
    "send_contract": ""
  };

  void setStatus(bool data) {
    _isOn = data;
    setState(() {});
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
        selectedCurrencyManager = responseData["mortgageBroker"];
        selectedMortgageBroker = responseData["currencyManager"];
        setState(() {});
      },
    );
  }

  void setChecklistData() {
    initialCallDataHolder["hear_about_us"] =
        widget.userData!['action'][0]['data']["hear_about_us"];
    initialCallDataHolder["read_review"] =
        widget.userData!['action'][0]['data']["read_review"];
    initialCallDataHolder["they_from"] =
        widget.userData!['action'][0]['data']["they_from"];
    initialCallDataHolder["live_now"] =
        widget.userData!['action'][0]['data']["live_now"];
    initialCallDataHolder["why_portugal"] =
        widget.userData!['action'][0]['data']["why_portugal"];
    initialCallDataHolder["buying_alone"] =
        widget.userData!['action'][0]['data']["buying_alone"];
    initialCallDataHolder["holiday_permanent"] =
        widget.userData!['action'][0]['data']["holiday_permanent"];
    initialCallDataHolder["they_in_process"] =
        widget.userData!['action'][0]['data']["they_in_process"];
    initialCallDataHolder["plan_to_purchase"] =
        widget.userData!['action'][0]['data']["plan_to_purchase"];
    initialCallDataHolder["stage_they_are_at"] =
        widget.userData!['action'][0]['data']["stage_they_are_at"];
    initialCallDataHolder["mortage_broker"] =
        widget.userData!['action'][0]['data']["mortage_broker"];
    initialCallDataHolder["lawyer_recommendation"] =
        widget.userData!['action'][0]['data']["lawyer_recommendation"];
    initialCallDataHolder["understand_buying_process"] =
        widget.userData!['action'][0]['data']["understand_buying_process"];
    initialCallDataHolder["explain_proactively"] =
        widget.userData!['action'][0]['data']["explain_proactively"];
    initialCallDataHolder["survey"] =
        widget.userData!['action'][0]['data']["survey"];
    initialCallDataHolder["discuss_exclusivity"] =
        widget.userData!['action'][0]['data']["discuss_exclusivity"];
    initialCallDataHolder["send_contract"] =
        widget.userData!['action'][0]['data']["send_contract"];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setStatus(widget.isOn);
    getSelectedCrmData();
    if (widget.index == 0) {
      setChecklistData();
    }
  }

  void openLinkInNewTab(String url) {
    html.window.open(url, '_blank');
  }

  String formatIsoToCustom(String isoString) {
    try {
      // Parse the ISO timestamp
      DateTime dateTime = DateTime.parse(isoString);

      // Format: DD/MON/YY hh:mm AM/PM
      return DateFormat("dd/MMM/yy hh:mm a").format(dateTime).toUpperCase();
    } catch (e) {
      return "Invalid date";
    }
  }

  String formatIsoDateTime(String isoString) {
    try {
      // Parse ISO timestamp
      DateTime dateTime = DateTime.parse(isoString);

      // Format: DD/MON/YY hh:mm AM/PM
      return DateFormat("dd/MMM/yy hh:mm a").format(dateTime).toUpperCase();
    } catch (e) {
      return "Invalid date";
    }
  }

  String toGoogleCalendarDateRange(DateTime start,
      {Duration duration = const Duration(hours: 1)}) {
    final end = start.add(duration);

    final formatter = DateFormat("yyyyMMdd'T'HHmmss'Z'");

    // Force UTC (Google requires UTC with Z)
    final startUtc = start.toUtc();
    final endUtc = end.toUtc();

    return "${formatter.format(startUtc)}/${formatter.format(endUtc)}";
  }

  Future<void> showFirstCallDialog({
    required BuildContext context,
    required String title,
    required String messageInitial,
    required String meetingLinkInitial,
    required String checklist_id,
  }) async {
    String? errorText;
    String valueHolder = messageInitial;
    String linkValue = meetingLinkInitial;
    String timingDetails = '';
    String timingDetailsIso = '';

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              backgroundColor: Colors.white,
              title: Text(
                title, // Title for the dialog box
                style: ThemeController.titleTextStyle(),
              ),
              content: Column(
                children: [
                  DateTimeSelector(
                    onDateTimeSelected: (selectedTime) {
                      timingDetails = toGoogleCalendarDateRange(selectedTime);
                      timingDetailsIso = selectedTime.toIso8601String();
                      setState(() {});
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormFiled(
                    initialValue: valueHolder,
                    labelName: 'Message',
                    placeholderText: '',
                    isMandatory: true,
                    onChanged: (data) {
                      errorText = null;
                      setState(() {});
                      if (data != null || data!.isNotEmpty) {
                        valueHolder = data;
                      } else {
                        setState(() {
                          errorText = 'Message cannot be empty !!!';
                        });
                      }
                    },
                    errorText: errorText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormFiled(
                    initialValue: meetingLinkInitial,
                    labelName: 'Meet link',
                    placeholderText: '',
                    isMandatory: true,
                    onChanged: (data) {
                      errorText = null;
                      setState(() {});
                      if (data != null || data!.isNotEmpty) {
                        linkValue = data;
                      } else {
                        setState(() {
                          errorText = 'Link cannot be empty !!!';
                        });
                      }
                    },
                    errorText: errorText,
                  ),
                  if (timingDetails != '')
                    const SizedBox(
                      height: 20,
                    ),
                  if (timingDetails != '')
                    InkWell(
                      onTap: () {
                        final url =
                            "https://calendar.google.com/calendar/render"
                            "?action=TEMPLATE"
                            "&text=Algarve%20House%20Hunters%20Consultation"
                            "&dates=$timingDetails"
                            "&details=Initial%20consultation%20to%20discuss%20property%20requirements"
                            "&add=${widget.clientData!['client_email_address']}";

                        html.window.open(url, "_blank");
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Create Google Meet link',
                          style: ThemeController.normalTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    )
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    if (linkValue == '' || linkValue.isEmpty) {
                      setState(() {
                        errorText = "Meeting link field cannot be empty";
                      });
                    } else {
                      // Call status update
                      // NOTE Getting the email content
                      ManagerLogInScreenController.showLoaderDialog(context);
                      String? welcomeHtmlContent;

                      await ApiController.getCallConfirmationMailContent(
                        {
                          "agent_id": widget.agentId,
                          "client_name": valueHolder,
                          "call_time_details": timingDetailsIso,
                          "meet_link": linkValue
                        },
                        onSuccess: (resData) {
                          welcomeHtmlContent = jsonDecode(resData);
                        },
                        onError: (errData) {},
                      );
                      print(
                          "Call confirmation html content: ${welcomeHtmlContent}");
                      welcomeHtmlContent =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Edit call confirmation content',
                        initialHtml: welcomeHtmlContent,
                      );
                      ManagerLogInScreenController.hideDialogBox(context);
                      ManagerLogInScreenController.showLoaderDialog(context);

                      await ApiController.firstCallUpdateStatus(
                        {
                          "checklist_id": checklist_id,
                          "agent_id": widget.agentId,
                          "call_time_details": timingDetailsIso,
                          "meet_link": linkValue,
                          "action_msg": valueHolder,
                          "client_email":
                              widget.clientData!['client_email_address'],
                          "client_name": widget.clientData!['client_name'],
                          "html_content": welcomeHtmlContent,
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Meeting has been created !!!');
                          print(
                              '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                              }
                            },
                          );
                        },
                        onError: (errData) {
                          ManagerLogInScreenController.hideDialogBox(context);
                          ManagerLogInScreenController.showError(
                            context,
                            jsonDecode(errData),
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget getInfoWidget({required int index}) {
    if (widget.userData != null && widget.clientData != null) {
      switch (index) {
        case 0:
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                if (widget.userData!['action'].length < 1)
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/empty_lottie.json',
                        height: 100,
                        width: 150,
                      ),
                      Text(
                        "No data or notes has been placed",
                        style: ThemeController.smallTextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                if (widget.userData!['action'].length >= 1)
                  Column(
                    children: List.generate(
                      widget.userData!['action'].length,
                      (index) => Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 0)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // NOTE - Status call widget
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // NOTE accepted button section
                                          FirstCallStatusLabelWidget(
                                            onPressed: () async {
                                              ManagerLogInScreenController
                                                  .showLoaderDialog(context);
                                              await ApiController
                                                  .firstCallStatusValueUpdate(
                                                {
                                                  "checklist_id":
                                                      widget.checklistId,
                                                  "call-status": "accepted"
                                                },
                                                onError: (errData) {
                                                  // NOTE Hiding the loader
                                                  ManagerLogInScreenController
                                                      .hideDialogBox(context);
                                                  ManagerLogInScreenController
                                                      .showError(
                                                          context, errData);
                                                },
                                                onSuccess: (resData) {
                                                  ManagerLogInScreenController
                                                      .showSuccess(context,
                                                          "Call status has been updated !!!");
                                                  Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                      if (context.mounted) {
                                                        context.push(
                                                            '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            status:
                                                FirstCallStatusData.accepted,
                                            isSelected: GlobalController
                                                    .getFirstCallStatusFromResponse(
                                                        widget.userData![
                                                            'call-status']) ==
                                                FirstCallStatusData.accepted,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          //NOTE cancelled button
                                          FirstCallStatusLabelWidget(
                                            onPressed: () async {
                                              ManagerLogInScreenController
                                                  .showLoaderDialog(context);
                                              await ApiController
                                                  .firstCallStatusValueUpdate(
                                                {
                                                  "checklist_id":
                                                      widget.checklistId,
                                                  "call-status": "cancelled"
                                                },
                                                onError: (errData) {
                                                  // NOTE Hiding the loader
                                                  ManagerLogInScreenController
                                                      .hideDialogBox(context);
                                                  ManagerLogInScreenController
                                                      .showError(
                                                          context, errData);
                                                },
                                                onSuccess: (resData) {
                                                  ManagerLogInScreenController
                                                      .showSuccess(context,
                                                          "Call status has been updated !!");
                                                  Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                      // html.window.history
                                                      //     .replaceState(
                                                      //   null,
                                                      //   'title',
                                                      //   '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist',
                                                      // );
                                                      // html.window.location
                                                      //     .reload();
                                                      if (context.mounted) {
                                                        if (context.mounted) {
                                                          context.push(
                                                              '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                        }
                                                        // html.window.location
                                                        //     .reload();
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            status:
                                                FirstCallStatusData.cancelled,
                                            isSelected: GlobalController
                                                    .getFirstCallStatusFromResponse(
                                                        widget.userData![
                                                            'call-status']) ==
                                                FirstCallStatusData.cancelled,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          // NOTE Rejected section
                                          FirstCallStatusLabelWidget(
                                            onPressed: () async {
                                              ManagerLogInScreenController
                                                  .showLoaderDialog(context);
                                              await ApiController
                                                  .firstCallStatusValueUpdate(
                                                {
                                                  "checklist_id":
                                                      widget.checklistId,
                                                  "call-status": "rejected"
                                                },
                                                onError: (errData) {
                                                  // NOTE Hiding the loader
                                                  ManagerLogInScreenController
                                                      .hideDialogBox(context);
                                                  ManagerLogInScreenController
                                                      .showError(
                                                          context, errData);
                                                },
                                                onSuccess: (resData) {
                                                  ManagerLogInScreenController
                                                      .showSuccess(context,
                                                          "Call status has been rejected !!!");
                                                  Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                      if (context.mounted) {
                                                        context.push(
                                                            '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                      }
                                                      // html.window.location
                                                      //     .reload();
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            status:
                                                FirstCallStatusData.rejected,
                                            isSelected: GlobalController
                                                    .getFirstCallStatusFromResponse(
                                                        widget.userData![
                                                            'call-status']) ==
                                                FirstCallStatusData.rejected,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                      // NOTE Empty Space
                                      const SizedBox(
                                        height: 10,
                                      ),

                                      // NOTE - Initial call widget
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "How did they hear about us?",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'hear_about_us'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'hear_about_us'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'hear_about_us'] = data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName: "Where are they from",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'they_from'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'they_from'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'they_from'] = data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "Have you read our reviews?",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'read_review'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'read_review'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'read_review'] = data;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "Where do they live now?",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'live_now'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'live_now'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'live_now'] = data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "Are they looking anywhere else?",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'why_portugal'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'why_portugal'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'why_portugal'] = data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "Are they buying alone?",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'buying_alone'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'buying_alone'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'buying_alone'] = data;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "How do they plan to purchase?",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'plan_to_purchase'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'plan_to_purchase'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'plan_to_purchase'] = data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName: "Are they in process?",
                                              placeholderText:
                                                  "What stage are they at?",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'they_in_process'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'they_in_process'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'they_in_process'] = data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "Do we need refer them to a Mortgage broker?",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'mortage_broker'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'mortage_broker'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'mortage_broker'] = data;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "Do they need a lawyer recommendation?",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'lawyer_recommendation'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                        'lawyer_recommendation'] =
                                                    data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                        'lawyer_recommendation'] =
                                                    data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "Do they understand the buying process?",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue: initialCallDataHolder[
                                                  'understand_buying_process'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                        'understand_buying_process'] =
                                                    data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                        'understand_buying_process'] =
                                                    data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "Explain if proactively looking to send listings",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'explain_proactively'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                        'explain_proactively'] =
                                                    data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                        'explain_proactively'] =
                                                    data;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName: "Survey",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'survey'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'survey'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'survey'] = data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName: "Discuss Exclusivity.",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'discuss_exclusivity'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                        'discuss_exclusivity'] =
                                                    data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                        'discuss_exclusivity'] =
                                                    data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName: "send contract",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'send_contract'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'send_contract'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'send_contract'] = data;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName:
                                                  "Will this be a holiday or permanent home?",
                                              placeholderText: "",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'holiday_permanent'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'holiday_permanent'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'holiday_permanent'] = data;
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.2,
                                            child: CustomTextFormFiled(
                                              labelName: "Are they in process?",
                                              placeholderText:
                                                  "Will they need a visa? put into contact with Marta for tenancy agreement.",
                                              isMandatory: false,
                                              initialValue:
                                                  initialCallDataHolder[
                                                      'they_in_process'],
                                              onChanged: (data) {
                                                initialCallDataHolder[
                                                    'they_in_process'] = data;
                                              },
                                              onPaste: (data) {
                                                initialCallDataHolder[
                                                    'they_in_process'] = data;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: AddMoreButton(
                                          onButtonPress: () async {
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .initialCallDataUpdate(
                                              {
                                                "checklist_id":
                                                    widget.checklistId,
                                                "notes_id":
                                                    widget.userData!['action']
                                                        [index]['notes_id'],
                                                "agent_id": widget.agentId,
                                                "data": initialCallDataHolder,
                                              },
                                              onSuccess: (resData) {
                                                ManagerLogInScreenController
                                                    .showSuccess(context,
                                                        'Details has been updated !!!');
                                                Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                    if (context.mounted) {
                                                      context.push(
                                                          '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                    }
                                                  },
                                                );
                                              },
                                              onError: (errData) {
                                                ManagerLogInScreenController
                                                    .showError(
                                                  context,
                                                  errData,
                                                );
                                                ManagerLogInScreenController
                                                    .hideDialogBox(context);
                                              },
                                            );
                                          },
                                          buttonLabel: 'Add information',
                                          iconData: Icons.add,
                                        ),
                                      )
                                    ],
                                  ),
                                if (index > 0)
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: HtmlRenderer(
                                      html: widget.userData!['action'][index]
                                          ['action_msg'],
                                    ),
                                  ),
                                const Spacer(),
                                if (index > 0)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.userData!['action'][index]
                                            ['initiated_by'],
                                        style: ThemeController.smallTextStyle(
                                          size: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        formatIsoToCustom(
                                            widget.userData!['action'][index]
                                                ['initiated_at']),
                                        style: ThemeController.smallTextStyle(
                                          size: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      // TODO change this for the agnet user
                                      if (widget.userData!['action'][index]
                                                  ['initiated_by'] ==
                                              widget.agentId &&
                                          ((widget.userData!['action'][index]
                                                      ['action_msg'] !=
                                                  '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                              widget.userData!['action'][index]
                                                      ['action_msg'] !=
                                                  '<b style=\"color:green\">The Action has been completed</b>'))
                                        InkWell(
                                          onTap: () async {
                                            final htmlData =
                                                await HtmlEditorDialog
                                                    .showHtmlEditorDialogWeb(
                                              context,
                                              title: 'Edit notes',
                                              initialHtml: widget
                                                          .userData!['action']
                                                      [index]['action_msg'] ??
                                                  '',
                                            );
                                            if (!mounted) return;

                                            if (htmlData != null) {
                                              ManagerLogInScreenController
                                                  .showLoaderDialog(context);
                                              await ApiController
                                                  .onBoardingDocumentsMsgEdit(
                                                {
                                                  "checklist_id":
                                                      widget.checklistId,
                                                  "agent_id": widget.agentId,
                                                  "action_msg": htmlData,
                                                  "notes_id":
                                                      widget.userData!['action']
                                                          [index]['notes_id']
                                                },
                                                onError: (errData) {},
                                                onSuccess: (resData) {
                                                  ManagerLogInScreenController
                                                      .showSuccess(
                                                    context,
                                                    'Notes has been updated !!!',
                                                  );
                                                  html.window.location.reload();
                                                },
                                              );
                                            }
                                          },
                                          child: Text(
                                            "Edit",
                                            style:
                                                ThemeController.smallTextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                      if ((widget.userData!['action'][index]
                                                  ['action_msg'] ==
                                              '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                          widget.userData!['action'][index]
                                                  ['action_msg'] ==
                                              '<b style=\"color:green\">The Action has been completed</b>')
                                        const SizedBox(
                                          height: 20,
                                        )
                                    ],
                                  )
                              ],
                            ),
                          ),
                          if (index < widget.userData!['action'].length - 1)
                            const Divider(
                              height: 0.2,
                              color: Colors.grey,
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );

        // NOTE Index 0 - On boarding Document
        case 1:
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Compose notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.onBoardingDocumentsMsgUpdate(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                if (widget.userData!['action'].length < 1)
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/empty_lottie.json',
                        height: 100,
                        width: 150,
                      ),
                      Text(
                        "No data or notes has been placed",
                        style: ThemeController.smallTextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                if (widget.userData!['action'].length >= 1)
                  Column(
                    children: List.generate(
                      widget.userData!['action'].length,
                      (index) => Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: HtmlRenderer(
                                    html: widget.userData!['action'][index]
                                        ['action_msg'],
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.userData!['action'][index]
                                          ['initiated_by'],
                                      style: ThemeController.smallTextStyle(
                                        size: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      formatIsoToCustom(
                                          widget.userData!['action'][index]
                                              ['initiated_at']),
                                      style: ThemeController.smallTextStyle(
                                        size: 12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    // TODO change this for the agnet user
                                    if (widget.userData!['action'][index]
                                                ['initiated_by'] ==
                                            widget.agentId &&
                                        ((widget.userData!['action'][index]
                                                    ['action_msg'] !=
                                                '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                            widget.userData!['action'][index]
                                                    ['action_msg'] !=
                                                '<b style=\"color:green\">The Action has been completed</b>'))
                                      InkWell(
                                        onTap: () async {
                                          final htmlData =
                                              await HtmlEditorDialog
                                                  .showHtmlEditorDialogWeb(
                                            context,
                                            title: 'Edit notes',
                                            initialHtml:
                                                widget.userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                          );
                                          if (!mounted) return;

                                          if (htmlData != null) {
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .onBoardingDocumentsMsgEdit(
                                              {
                                                "checklist_id":
                                                    widget.checklistId,
                                                "agent_id": widget.agentId,
                                                "action_msg": htmlData,
                                                "notes_id":
                                                    widget.userData!['action']
                                                        [index]['notes_id']
                                              },
                                              onError: (errData) {},
                                              onSuccess: (resData) {
                                                ManagerLogInScreenController
                                                    .showSuccess(
                                                  context,
                                                  'Notes has been updated !!!',
                                                );
                                                html.window.location.reload();
                                              },
                                            );
                                          }
                                        },
                                        child: Text(
                                          "Edit",
                                          style: ThemeController.smallTextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    if ((widget.userData!['action'][index]
                                                ['action_msg'] ==
                                            '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                        widget.userData!['action'][index]
                                                ['action_msg'] ==
                                            '<b style=\"color:green\">The Action has been completed</b>')
                                      const SizedBox(
                                        height: 20,
                                      )
                                  ],
                                )
                              ],
                            ),
                          ),
                          if (index < widget.userData!['action'].length - 1)
                            const Divider(
                              height: 0.2,
                              color: Colors.grey,
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );

        case 2:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              if (widget.userData!['action'].isEmpty)
                Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/empty_lottie.json',
                      height: 100,
                      width: 150,
                    ),
                    Text(
                      "No data or notes has been placed",
                      style: ThemeController.smallTextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              if (widget.userData!['action'].isNotEmpty)
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: CustomBorderButton(
                        label: "Re-Send",
                        onTap: () async {
                          print("re send button is pingged !!!");
                          String? welcomeHtmlContent;
                          await ApiController.getWelcomMailContent(
                            onSuccess: (resData) {
                              welcomeHtmlContent = jsonDecode(resData);
                            },
                            onError: (errData) {},
                          );
                          print("html email content: ${welcomeHtmlContent}");
                          welcomeHtmlContent =
                              await HtmlEditorDialog.showHtmlEditorDialogWeb(
                            context,
                            title: 'Edit notes',
                            initialHtml: welcomeHtmlContent,
                          );
                          print("edited html content ${welcomeHtmlContent}");
                          if (!mounted) return;
                          ManagerLogInScreenController.showLoaderDialog(
                              context);
                          await ApiController.sendWelcomeEmail(
                            {
                              "checklist_id": widget.checklistId,
                              "agent_id": widget.agentId,
                              "client_email_address":
                                  widget.clientData!['client_email_address'],
                              "html_content": welcomeHtmlContent,
                            },
                            onSuccess: (resData) {
                              ManagerLogInScreenController.showSuccess(
                                  context, 'Email has been dropped !!!');
                              Future.delayed(
                                const Duration(seconds: 2),
                                () {
                                  if (context.mounted) {
                                    context.push(
                                        '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                  }
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
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: List.generate(
                        widget.userData!['action'].length,
                        (index) => Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: HtmlRenderer(
                                      html: widget.userData!['action'][index]
                                          ['action_msg'],
                                    ),
                                  ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.userData!['action'][index]
                                            ['initiated_by'],
                                        style: ThemeController.smallTextStyle(
                                          size: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        formatIsoToCustom(
                                            widget.userData!['action'][index]
                                                ['initiated_at']),
                                        style: ThemeController.smallTextStyle(
                                          size: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            if (index < widget.userData!['action'].length - 1)
                              const Divider(
                                height: 0.2,
                                color: Colors.grey,
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ]),
          );

        case 3:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomBorderButton(
                    label: 'Schedule call',
                    onTap: () async {
                      showFirstCallDialog(
                        context: context,
                        checklist_id: widget.checklistId,
                        title: 'Create meeting',
                        messageInitial: '',
                        meetingLinkInitial: '',
                      );
                    },
                  ),
                  const SizedBox(width: 10),
                  CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Compose call notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.firstCallUpdateNotes(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Call notes has been added !!!',
                            );
                            if (context.mounted) {
                              context.push(
                                  '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                            }
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (widget.userData!['action'].isEmpty)
                Column(
                  children: [
                    Lottie.asset(
                      'assets/lottie/empty_lottie.json',
                      height: 100,
                      width: 150,
                    ),
                    Text(
                      "No data or notes has been placed",
                      style: ThemeController.smallTextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              if (widget.userData!['action'].isNotEmpty)
                Column(
                  children: [
                    // TODO Change the API

                    Column(
                      children: List.generate(
                        widget.userData!['action'].length,
                        (index) => Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (widget.userData!['action'][index]
                                              ['data_type'] ==
                                          'status-data' ||
                                      widget.userData!['action'][index]
                                              ['data_type'] ==
                                          'notes-data')
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                  if (widget.userData!['action'][index]
                                          ['data_type'] ==
                                      'call-data')
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['action_msg'],
                                          style:
                                              ThemeController.normalTextStyle(),
                                        ),
                                        Text(
                                          '${formatIsoDateTime(widget.userData!['action'][index]['call_time_details'])}',
                                          style: ThemeController.smallTextStyle(
                                            fontWeight: FontWeight.w900,
                                            size: 12,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (widget.userData!['action']
                                                        [index]['call_link'] !=
                                                    null ||
                                                widget.userData!['action']
                                                        [index]['call_link'] !=
                                                    '') {
                                              openLinkInNewTab(
                                                widget.userData!['action']
                                                    [index]['call_link'],
                                              );
                                            }
                                          },
                                          child: Text(
                                            '${widget.userData!['action'][index]['call_link']}',
                                            style:
                                                ThemeController.smallTextStyle(
                                              fontWeight: FontWeight.w900,
                                              size: 12,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  const Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.userData!['action'][index]
                                            ['initiated_by'],
                                        style: ThemeController.smallTextStyle(
                                          size: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        formatIsoToCustom(
                                            widget.userData!['action'][index]
                                                ['initiated_at']),
                                        style: ThemeController.smallTextStyle(
                                          size: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      if (widget.userData!['action'][index]
                                              ['data_type'] ==
                                          'call-data')
                                        Row(
                                          children: [
                                            CustomTextButton(
                                              label: "Scheduled",
                                              onTap: () async {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .firstCallUpdateEditStatus(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "call_id": widget
                                                            .userData!['action']
                                                        [index]['call_id'],
                                                    "status": "Scheduled",
                                                  },
                                                  onError: (errData) {
                                                    ManagerLogInScreenController
                                                        .showError(
                                                      context,
                                                      jsonDecode(errData),
                                                    );
                                                  },
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Call status has been updated',
                                                    );
                                                    Future.delayed(
                                                      const Duration(
                                                          seconds: 2),
                                                      () {
                                                        html.window.location
                                                            .reload();
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              isEnabled: widget
                                                          .userData!['action']
                                                      [index]['call_status'] ==
                                                  'Scheduled',
                                              labelColor: Colors.blue,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            CustomTextButton(
                                              label: "Re-Scheduled",
                                              onTap: () async {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .firstCallUpdateEditStatus(
                                                  {
                                                    "checklist_id": widget
                                                            .userData!['action']
                                                        [index]['checklist_id'],
                                                    "call_id": widget
                                                            .userData!['action']
                                                        [index]['call_id'],
                                                    "status": "Re-Scheduled",
                                                  },
                                                  onError: (errData) {
                                                    ManagerLogInScreenController
                                                        .showError(
                                                      context,
                                                      jsonDecode(errData),
                                                    );
                                                  },
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Call status has been updated',
                                                    );
                                                    Future.delayed(
                                                      const Duration(
                                                          seconds: 2),
                                                      () {
                                                        html.window.location
                                                            .reload();
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              isEnabled: widget
                                                          .userData!['action']
                                                      [index]['call_status'] ==
                                                  'Re-Scheduled',
                                              labelColor: Colors.amber,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            CustomTextButton(
                                              label: "Completed",
                                              onTap: () async {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .firstCallUpdateEditStatus(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "call_id": widget
                                                            .userData!['action']
                                                        [index]['call_id'],
                                                    "status": "Completed",
                                                  },
                                                  onError: (errData) {
                                                    ManagerLogInScreenController
                                                        .showError(
                                                      context,
                                                      jsonDecode(errData),
                                                    );
                                                  },
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Call status has been updated',
                                                    );
                                                    Future.delayed(
                                                      const Duration(
                                                          seconds: 2),
                                                      () {
                                                        html.window.location
                                                            .reload();
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              isEnabled: widget
                                                          .userData!['action']
                                                      [index]['call_status'] ==
                                                  'Completed',
                                              labelColor: Colors.green,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            CustomTextButton(
                                              label: "Cancelled",
                                              onTap: () async {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .firstCallUpdateEditStatus(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "call_id": widget
                                                            .userData!['action']
                                                        [index]['call_id'],
                                                    "status": "Cancelled",
                                                  },
                                                  onError: (errData) {
                                                    ManagerLogInScreenController
                                                        .showError(
                                                      context,
                                                      jsonDecode(errData),
                                                    );
                                                  },
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Call status has been updated',
                                                    );
                                                    Future.delayed(
                                                      const Duration(
                                                          seconds: 2),
                                                      () {
                                                        html.window.location
                                                            .reload();
                                                      },
                                                    );
                                                  },
                                                );
                                              },
                                              isEnabled: widget
                                                          .userData!['action']
                                                      [index]['call_status'] ==
                                                  'Cancelled',
                                              labelColor: Colors.red,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            )
                                          ],
                                        ),
                                      if (widget.userData!['action'][index]
                                                  ['data_type'] ==
                                              'notes-data' &&
                                          widget.userData!['action'][index]
                                                  ['initiated_by'] ==
                                              widget.agentId)
                                        CustomTextButton(
                                          isEnabled: true,
                                          label: "Edit",
                                          onTap: () async {
                                            final htmlData =
                                                await HtmlEditorDialog
                                                    .showHtmlEditorDialogWeb(
                                              context,
                                              title: 'Edit notes',
                                              initialHtml:
                                                  widget.userData!['action']
                                                      [index]['action_msg'],
                                            );
                                            if (!mounted) return;
                                            if (htmlData != null) {
                                              ManagerLogInScreenController
                                                  .showLoaderDialog(context);
                                              await ApiController
                                                  .firstCallUpdateNotesEdit(
                                                {
                                                  "checklist_id":
                                                      widget.checklistId,
                                                  "agent_id": widget.agentId,
                                                  "action_msg": htmlData,
                                                  "call_id":
                                                      widget.userData!['action']
                                                          [index]['call_id']
                                                },
                                                onError: (errData) {},
                                                onSuccess: (resData) {
                                                  ManagerLogInScreenController
                                                      .showSuccess(
                                                    context,
                                                    'Notes has been edited !!!',
                                                  );
                                                  html.window.location.reload();
                                                },
                                              );
                                            }
                                          },
                                          labelColor: Colors.blue,
                                        )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            if (index < widget.userData!['action'].length - 1)
                              const Divider(
                                height: 0.2,
                                color: Colors.grey,
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
            ]),
          );

        case 4:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add fiscal notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.updateFiscalStatusData(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Fiscal notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/empty_lottie.json',
                        height: 100,
                        width: 150,
                      ),
                      Text(
                        "No data or notes has been placed",
                        style: ThemeController.smallTextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title: 'Edit fiscal notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .fiscalUpdateStatusEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "fiscal_id": widget
                                                            .userData!['action']
                                                        [index]['fiscal_id']
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 5:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (selectedAdvocate.isNotEmpty)
                      CustomBorderButton(
                        label: 'Advocate Info',
                        onTap: () async {
                          // NOTE Showing the loader
                          ManagerLogInScreenController.showLoaderDialog(
                            context,
                          );
                          String? htmlContent;
                          await ApiController.getAdvicateSharingInfoMailContent(
                            widget.clientData!['client_name'],
                            onSuccess: (resData) {
                              htmlContent = jsonDecode(resData);
                            },
                            onError: (errData) {},
                          );
                          htmlContent =
                              await HtmlEditorDialog.showHtmlEditorDialogWeb(
                            context,
                            title: 'Edit email content',
                            initialHtml: htmlContent,
                          );
                          // NOTE Hiding the loader
                          ManagerLogInScreenController.hideDialogBox(
                            context,
                          );
                          ManagerLogInScreenController.showLoaderDialog(
                            context,
                          );
                          await ApiController.sendAdvocateInfo(
                            {
                              "emailAddress":
                                  widget.clientData!['client_email_address'],
                              "checklist_id": widget.checklistId,
                              "agent_id": widget.agentId,
                              "action_msg":
                                  "<b style=\"color:black\">The <i style=\"color:blue\">Advocate</i> details has been shared.</b>",
                              "html_content": htmlContent,
                            },
                            onError: (errData) {
                              ManagerLogInScreenController.showError(
                                  context, jsonDecode(errData));
                              ManagerLogInScreenController.hideDialogBox(
                                  context);
                            },
                            onSuccess: (resData) {
                              ManagerLogInScreenController.showSuccess(
                                context,
                                'Details has been shared',
                              );
                              Future.delayed(const Duration(seconds: 2), () {
                                if (context.mounted) {
                                  context.push(
                                      '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                }
                              });
                            },
                          );
                        },
                      ),
                    if (selectedAdvocate.isNotEmpty)
                      const SizedBox(
                        width: 10,
                      ),
                    if (selectedMortgageBroker.isNotEmpty)
                      CustomBorderButton(
                        label: 'Mortgage Manager Info',
                        onTap: () async {
                          ManagerLogInScreenController.showLoaderDialog(
                            context,
                          );
                          String? htmlContent;
                          await ApiController
                              .getMortageManagerSharingInfoMailContent(
                            widget.clientData!['client_name'],
                            onSuccess: (resData) {
                              htmlContent = jsonDecode(resData);
                            },
                            onError: (errData) {},
                          );
                          htmlContent =
                              await HtmlEditorDialog.showHtmlEditorDialogWeb(
                            context,
                            title: 'Edit email content',
                            initialHtml: htmlContent,
                          );
                          // NOTE Hiding the loader
                          ManagerLogInScreenController.hideDialogBox(
                            context,
                          );
                          ManagerLogInScreenController.showLoaderDialog(
                              context);
                          await ApiController.sendMortgageInfo(
                            {
                              "emailAddress":
                                  widget.clientData!['client_email_address'],
                              "checklist_id": widget.checklistId,
                              "agent_id": widget.agentId,
                              "action_msg":
                                  "<b style=\"color:black\">The <i style=\"color:purple\">Mortgage manager</i> details has been shared.</b>",
                              "html_content": htmlContent,
                            },
                            onError: (errData) {
                              ManagerLogInScreenController.showError(
                                  context, jsonDecode(errData));
                              ManagerLogInScreenController.hideDialogBox(
                                  context);
                            },
                            onSuccess: (resData) {
                              ManagerLogInScreenController.showSuccess(
                                context,
                                'Details has been shared',
                              );
                              Future.delayed(const Duration(seconds: 2), () {
                                if (context.mounted) {
                                  context.push(
                                      '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                }
                              });
                            },
                          );
                        },
                      ),
                    if (selectedMortgageBroker.isNotEmpty)
                      const SizedBox(
                        width: 10,
                      ),
                    if (selectedCurrencyManager.isNotEmpty)
                      CustomBorderButton(
                        label: 'Currency Manager Info',
                        onTap: () async {
                          ManagerLogInScreenController.showLoaderDialog(
                            context,
                          );
                          String? htmlContent;
                          await ApiController
                              .getCurrencyManagerSharingInfoMailContent(
                            widget.clientData!['client_name'],
                            onSuccess: (resData) {
                              htmlContent = jsonDecode(resData);
                            },
                            onError: (errData) {},
                          );
                          htmlContent =
                              await HtmlEditorDialog.showHtmlEditorDialogWeb(
                            context,
                            title: 'Edit email content',
                            initialHtml: htmlContent,
                          );
                          // NOTE Hiding the loader
                          ManagerLogInScreenController.hideDialogBox(
                            context,
                          );
                          ManagerLogInScreenController.showLoaderDialog(
                              context);
                          await ApiController.sendCurrencyInfo(
                            {
                              "emailAddress":
                                  widget.clientData!['client_email_address'],
                              "checklist_id": widget.checklistId,
                              "agent_id": widget.agentId,
                              "action_msg":
                                  "<b style=\"color:black\">The <i style=\"color:green\">Currency manager</i> details has been shared.</b>",
                              "html_content": htmlContent,
                            },
                            onError: (errData) {
                              ManagerLogInScreenController.showError(
                                  context, jsonDecode(errData));
                              ManagerLogInScreenController.hideDialogBox(
                                  context);
                            },
                            onSuccess: (resData) {
                              ManagerLogInScreenController.showSuccess(
                                context,
                                'Details has been shared',
                              );
                              Future.delayed(const Duration(seconds: 2), () {
                                if (context.mounted) {
                                  context.push(
                                      '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                }
                              });
                            },
                          );
                        },
                      ),
                  ],
                ),
                if (widget.userData!['action'].isEmpty)
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/empty_lottie.json',
                        height: 100,
                        width: 150,
                      ),
                      Text(
                        "No data or notes has been placed",
                        style: ThemeController.smallTextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: List.generate(
                      widget.userData!['action'].length,
                      (index) => Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: HtmlRenderer(
                                    html: widget.userData!['action'][index]
                                        ['action_msg'],
                                  ),
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.userData!['action'][index]
                                          ['initiated_by'],
                                      style: ThemeController.smallTextStyle(
                                        size: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      formatIsoToCustom(
                                          widget.userData!['action'][index]
                                              ['initiated_at']),
                                      style: ThemeController.smallTextStyle(
                                        size: 12,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          if (index < widget.userData!['action'].length - 1)
                            const Divider(
                              height: 0.2,
                              color: Colors.grey,
                            ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          );

        case 6:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add property search notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.propertySearchUpdateStatus(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Property search notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/empty_lottie.json',
                        height: 100,
                        width: 150,
                      ),
                      Text(
                        "No data or notes has been placed",
                        style: ThemeController.smallTextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title:
                                                    'Edit property search notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .propertySearchUpdateStatusMsgEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "searchId": widget
                                                            .userData!['action']
                                                        [index]['searchId'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 9:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add property found notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.propertyFoundStatus(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Property found notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Column(
                    children: [
                      Lottie.asset(
                        'assets/lottie/empty_lottie.json',
                        height: 100,
                        width: 150,
                      ),
                      Text(
                        "No data or notes has been placed",
                        style: ThemeController.smallTextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title:
                                                    'Edit property found notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .propertyFoundStatusMsgEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "foundId": widget
                                                            .userData!['action']
                                                        [index]['foundId'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 10:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add offer made notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.offerValueStatus(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Property found notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/empty_lottie.json',
                          height: 100,
                          width: 150,
                        ),
                        Text(
                          "No data or notes has been placed",
                          style: ThemeController.smallTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title: 'Edit offer made notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .offerValueStatusMsgEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "notes_id": widget
                                                            .userData!['action']
                                                        [index]['notes_id'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 11:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add offer confirm notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.offerConfirmedStatus(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Property found notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/empty_lottie.json',
                          height: 100,
                          width: 150,
                        ),
                        Text(
                          "No data or notes has been placed",
                          style: ThemeController.smallTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title:
                                                    'Edit offer confirm notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .offerConfirmedStatusMsgEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "notes_id": widget
                                                            .userData!['action']
                                                        [index]['notes_id'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 12:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add CPCV notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.CPCVBookedStatusStatus(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'CPCV notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/empty_lottie.json',
                          height: 100,
                          width: 150,
                        ),
                        Text(
                          "No data or notes has been placed",
                          style: ThemeController.smallTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title:
                                                    'Edit offer confirm notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .CPCVBookedStatusStatusMsgEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "notes_id": widget
                                                            .userData!['action']
                                                        [index]['notes_id'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 13:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add KYC notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.KYCStatusUpdate(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'KYC notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/empty_lottie.json',
                          height: 100,
                          width: 150,
                        ),
                        Text(
                          "No data or notes has been placed",
                          style: ThemeController.smallTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title:
                                                    'Edit offer confirm notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .KYCStatusUpdateStatusMsgEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "notes_id": widget
                                                            .userData!['action']
                                                        [index]['notes_id'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 14:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add review notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.reviewRequestStatusUpdate(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Review notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/empty_lottie.json',
                          height: 100,
                          width: 150,
                        ),
                        Text(
                          "No data or notes has been placed",
                          style: ThemeController.smallTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title: 'Edit review notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .reviewRequestStatusUpdateMsgEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "notes_id": widget
                                                            .userData!['action']
                                                        [index]['notes_id'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 15:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add docs notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.allDocsReviewRequestStatusUpdate(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Docs notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/empty_lottie.json',
                          height: 100,
                          width: 150,
                        ),
                        Text(
                          "No data or notes has been placed",
                          style: ThemeController.smallTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title: 'Edit review notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .allDocsReviewRequestStatusUpdateMsgEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "notes_id": widget
                                                            .userData!['action']
                                                        [index]['notes_id'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 16:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add deed notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.deedBookedStatusUpdate(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Docs notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/empty_lottie.json',
                          height: 100,
                          width: 150,
                        ),
                        Text(
                          "No data or notes has been placed",
                          style: ThemeController.smallTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title: 'Edit review notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .deedBookedStatusUpdateMsgEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "notes_id": widget
                                                            .userData!['action']
                                                        [index]['notes_id'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 17:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add sale complete notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.saleCompletedStatusUpdate(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Docs notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/empty_lottie.json',
                          height: 100,
                          width: 150,
                        ),
                        Text(
                          "No data or notes has been placed",
                          style: ThemeController.smallTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title:
                                                    'Edit sale completed notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .saleCompletedStatusUpdateMsgUpdate(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "notes_id": widget
                                                            .userData!['action']
                                                        [index]['notes_id'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        case 18:
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomBorderButton(
                    label: 'Add notes',
                    onTap: () async {
                      final htmlData =
                          await HtmlEditorDialog.showHtmlEditorDialogWeb(
                        context,
                        title: 'Add after sale notes',
                        initialHtml: '',
                      );
                      if (!mounted) return;
                      if (htmlData != null) {
                        ManagerLogInScreenController.showLoaderDialog(context);
                        await ApiController.afterCareStatusUpdate(
                          {
                            "checklist_id": widget.checklistId,
                            "agent_id": widget.agentId,
                            "action_msg": htmlData
                          },
                          onError: (errData) {},
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                              context,
                              'Docs notes has been added !!!',
                            );
                            html.window.location.reload();
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (widget.userData!['action'].isEmpty)
                  Center(
                    child: Column(
                      children: [
                        Lottie.asset(
                          'assets/lottie/empty_lottie.json',
                          height: 100,
                          width: 150,
                        ),
                        Text(
                          "No data or notes has been placed",
                          style: ThemeController.smallTextStyle(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                if (widget.userData!['action'].isNotEmpty)
                  Column(
                    children: [
                      Column(
                        children: List.generate(
                          widget.userData!['action'].length,
                          (index) => Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: HtmlRenderer(
                                        html: widget.userData!['action'][index]
                                            ['action_msg'],
                                      ),
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.userData!['action'][index]
                                              ['initiated_by'],
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          formatIsoToCustom(
                                              widget.userData!['action'][index]
                                                  ['initiated_at']),
                                          style: ThemeController.smallTextStyle(
                                            size: 12,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        // TODO change this for the agnet user
                                        if (widget.userData!['action'][index]
                                                    ['initiated_by'] ==
                                                widget.agentId &&
                                            ((widget.userData!['action'][index]
                                                        ['action_msg'] !=
                                                    '<b style=\"color:red\">The Action has been re-opened</b>') &&
                                                widget.userData!['action']
                                                        [index]['action_msg'] !=
                                                    '<b style=\"color:green\">The Action has been completed</b>'))
                                          InkWell(
                                            onTap: () async {
                                              final htmlData =
                                                  await HtmlEditorDialog
                                                      .showHtmlEditorDialogWeb(
                                                context,
                                                title:
                                                    'Edit sale completed notes',
                                                initialHtml: widget
                                                            .userData!['action']
                                                        [index]['action_msg'] ??
                                                    '',
                                              );
                                              if (!mounted) return;

                                              if (htmlData != null) {
                                                ManagerLogInScreenController
                                                    .showLoaderDialog(context);
                                                await ApiController
                                                    .afterCareStatusUpdateMsgEdit(
                                                  {
                                                    "checklist_id":
                                                        widget.checklistId,
                                                    "action_msg": htmlData,
                                                    "notes_id": widget
                                                            .userData!['action']
                                                        [index]['notes_id'],
                                                    "agent_id": widget.agentId,
                                                  },
                                                  onError: (errData) {},
                                                  onSuccess: (resData) {
                                                    ManagerLogInScreenController
                                                        .showSuccess(
                                                      context,
                                                      'Notes has been updated !!!',
                                                    );
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }
                                            },
                                            child: Text(
                                              "Edit",
                                              style: ThemeController
                                                  .smallTextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        if ((widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:red\">The Action has been re-opened</b>') ||
                                            widget.userData!['action'][index]
                                                    ['action_msg'] ==
                                                '<b style=\"color:green\">The Action has been completed</b>')
                                          const SizedBox(
                                            height: 20,
                                          )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              if (index < widget.userData!['action'].length - 1)
                                const Divider(
                                  height: 0.2,
                                  color: Colors.grey,
                                ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ],
            ),
          );

        default:
          return const SizedBox.shrink();
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        enabled: widget.isEnabled,
        children: [
          getInfoWidget(
            index: widget.index,
          ),
        ],
        title: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: ThemeController.normalTextStyle(
                    fontWeight: FontWeight.w900,
                    color: _isOn ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  widget.subtitle,
                  style: ThemeController.smallTextStyle(
                      fontWeight: FontWeight.w500,
                      color: _isOn ? Colors.green : Colors.grey),
                ),
              ],
            ),
            const Spacer(),
            ToggleSwitchWidget(
              isEnabled: widget.isEnabled,
              isOn: _isOn,
              onToggle: widget.isEnabled
                  ? (data) {
                      _isOn = !_isOn;
                      setStatus(_isOn);
                      widget.onTogglePress(data);
                    }
                  : (data) {
                      print('false is pressed');
                    },
            ),
          ],
        ));
  }
}
