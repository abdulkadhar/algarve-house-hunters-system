import 'dart:convert';
import 'dart:html' as html;
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/date_time_selector.dart';
import 'package:algarve_house_hunters_system/manager_agent_info_section_secreen/widgets/checklist_unit_data_widget.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class ChecklistHolderWidget extends StatefulWidget {
  final String agentId;   
  final Map<String, dynamic>? clientData;
  const ChecklistHolderWidget({super.key, required this.agentId,required this.clientData});

  @override
  State<ChecklistHolderWidget> createState() => _ChecklistHolderWidgetState();
}

class _ChecklistHolderWidgetState extends State<ChecklistHolderWidget> {
  Map<String, dynamic>? currentUserChecklist;

  Future<void> getCurrentUserCheckListData(
    String client_id,
  ) async {
    // ManagerLogInScreenController.showLoaderDialog(context);
    await ApiController.getClientCheckListData(
      client_id,
      onSuccess: (data) {
        // ManagerLogInScreenController.hideDialogBox(context);
        currentUserChecklist = jsonDecode(data)['data'];
        setState(() {});
        print("checklist_data_has been updated");
      },
      onError: (data) {
        // ManagerLogInScreenController.hideDialogBox(context);
        // ManagerLogInScreenController.showError(
        //     context, jsonDecode(data).toString());
      },
    );
  }

    Future<void> showViewingConfirmDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required String checklistId,
  }) async {
    String? errorText;
    String valueHolder = initialValue;
    String timingDetailsIso = '';
    String propertyId = '';

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
                    initialValue: propertyId,
                    labelName: 'Property ID',
                    placeholderText: '',
                    isMandatory: true,
                    onChanged: (data) {
                      errorText = null;
                      setState(() {});
                      if (data != null || data!.isNotEmpty) {
                        propertyId = data;
                      } else {
                        setState(() {
                          errorText = 'Property ID cannot be empty !!!';
                        });
                      }
                    },
                    errorText: errorText,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    if (valueHolder == '' || valueHolder.isEmpty) {
                      setState(() {
                        errorText = "This field cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);

                      await ApiController.viewingConfirmUpdateStatus(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                          "booking_time": timingDetailsIso,
                          "property_id": propertyId
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'Viewing confirm status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              // html.window.location.reload();
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


Future<void> showPropertySearchDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required String checklistId,
  }) async {
    String? errorText;
    String valueHolder = initialValue;

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
              content: CustomTextFormFiled(
                initialValue: valueHolder,
                labelName: '',
                placeholderText: '',
                isMandatory: false,
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
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    if (valueHolder == '' || valueHolder.isEmpty) {
                      setState(() {
                        errorText = "This field cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);

                      await ApiController.propertySearchUpdateStatus(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'Property search status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              // html.window.location.reload();
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

 Future<void> showPropertyBookingDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required String checklistId,
  }) async {
    String? errorText;
    String valueHolder = initialValue;

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
              content: CustomTextFormFiled(
                initialValue: valueHolder,
                labelName: '',
                placeholderText: '',
                isMandatory: false,
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
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    if (valueHolder == '' || valueHolder.isEmpty) {
                      setState(() {
                        errorText = "This field cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);

                      await ApiController.propertyBookingUpdateStatus(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'Property booking status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              // html.window.location.reload();
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

   

  void setCurrentUserCheckListData()async {
    await getCurrentUserCheckListData(widget.clientData!['client_id']);
  }
  @override
  void initState(){
    super.initState();
    setCurrentUserCheckListData();
  }
  @override
  Widget build(BuildContext context) {
    return     
    currentUserChecklist==null?Center(child: SizedBox(
      height: 30,
      width: 30,
      child: CircularProgressIndicator(color: Colors.black,),),):
    Column(
                              children: List.generate(
                                currentUserChecklist!['checklist_data'].length,
                                (index) => Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CheckListUnitDataWidget(
                                      agentId: widget.agentId,
                                      checklistId:currentUserChecklist!['checklist_id'],
                                      index: index,
                                      clientData: widget.clientData,
                                      // TODO map it with the API response data
                                      userData: currentUserChecklist![
                                          'checklist_data'][index],
                                      isEnabled: index != 0 &&
                                                // TODO map it with the API response data
                                              currentUserChecklist![
                                                          'checklist_data'][0]
                                                      ['status'] ==
                                                  'Not-Started'
                                          ? false
                                          : true,
                                          // TODO map it with the API response data
                                      isOn: currentUserChecklist![
                                                  'checklist_data'][index]
                                              ['status'] !=
                                          'Not-Started',
                                      onTogglePress: (data) async {
                                        // NOTE Initial call status section
                                        if (index == 0) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .initialCallUpdateStatus(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
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
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                        }
                                        // NOTE On boarding document action
                                        else if (index == 1) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .onBoardingDocumentsUpdate(
                                            {
                                              //TODO map it with the api data
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
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
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                        } 
                                        // NOTE Send welcome Email actions
                                        else if (index == 2) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController.clientEmailUpdate(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started",
                                              "client_email_address":
                                                  widget.clientData![
                                                      'client_email_address']
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
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
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                        } 
                                        // NOTE Follow up calls status 
                                        else if (index == 3) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .firstCallStatusUpdate(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
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
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          
                                        } 
                                        // NOTE Fiscal Status Actions
                                        else if (index == 4) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .updateFiscalStatusData(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
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
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // showFiscalDialog(
                                          //   context: context,
                                          //   title: 'Update fiscal message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } 
                                        // NOTE Lawyer Status Actions 
                                        else if (index == 5) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .lawyerUpdateStatus(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
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
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // showLawyerDialog(
                                          //   context: context,
                                          //   title: 'Update lawyer message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } 
                                        // NOTE Property search Status Actions
                                        else if (index == 6) {                                          
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .propertySearchUpdateStatusAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
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
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // showPropertySearchDialog(
                                          //     context: context,
                                          //     title:
                                          //         'Update property search message',
                                          //     initialValue: '',
                                          //     checklistId:
                                          //         currentUserChecklist![
                                          //             'checklist_id']);
                                        } 
                                        // NOTE Viewing Confirmed Status Actions 
                                        else if (index == 7) {
                                          showViewingConfirmDialog(
                                              context: context,
                                              title:
                                                  'Update viewing confirmation message',
                                              initialValue: '',
                                              checklistId:
                                                  currentUserChecklist![
                                                      'checklist_id']);
                                        } 
                                        // NOTE Viewings Booked Status Actions
                                        else if (index == 8) {
                                          showPropertyBookingDialog(
                                            context: context,
                                            title:
                                                'Update viewing booking message',
                                            initialValue: '',
                                            checklistId: currentUserChecklist![
                                                'checklist_id'],
                                          );
                                        } 
                                        // NOTE  Property found status actions
                                        else if (index == 9) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .propertyFoundStatusAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
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
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // showPropertyFoundStatusDialog(
                                          //   context: context,
                                          //   title:
                                          //       'Update property found status message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        }
                                        // NOTE Offer made status actions
                                         else if (index == 10) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .offerValueStatusAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // showOfferMadeStatusDialog(
                                          //   context: context,
                                          //   title:
                                          //       'Update offer status message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } 
                                        // NOTE Offer confirmed status actions 
                                        else if (index == 11) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .offerConfirmedStatusAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // showOfferConfirmedStatusDialog(
                                          //   context: context,
                                          //   title:
                                          //       'Update offer confirmed message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } else if (index == 12) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .CPCVBookedStatusStatusAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // CPCVBookedStatusStatusDialog(
                                          //   context: context,
                                          //   title: 'Update CPCV booked message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } else if (index == 13) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .KYCStatusUpdateAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // KYCRequestStatusDialog(
                                          //   context: context,
                                          //   title: 'Update KYC request message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } else if (index == 14) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .reviewRequestStatusUpdateAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // reviewRequestStatusDialog(
                                          //   context: context,
                                          //   title:
                                          //       'Update review request message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } else if (index == 15) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .allDocsReviewRequestStatusUpdateAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // allDocsReviewRequestStatusDialog(
                                          //   context: context,
                                          //   title:
                                          //       'Update all docs review request message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } else if (index == 16) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .deedBookedStatusUpdateAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // deedBookedStatusDialog(
                                          //   context: context,
                                          //   title: 'Update deed booked message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } else if (index == 17) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .saleCompletedStatusUpdateAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // saleCompletedStatusDialog(
                                          //   context: context,
                                          //   title:
                                          //       'Update sale completed message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } else if (index == 18) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .afterCareStatusUpdateAlone(
                                            {
                                              "checklist_id":
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                              "agent_id":
                                                  "MNG-BLR-20250625-0001",
                                              "action_msg": data
                                                  ? "<b style=\"color:green\">The Action has been completed</b>"
                                                  : "<b style=\"color:red\">The Action has been re-opened</b>",
                                              "status": data
                                                  ? "Completed"
                                                  : "Not-Started"
                                            },
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Status has been updated !!!');
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${widget.clientData!['client_id']}/clientChecklist');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                          // afterCareStatusDialog(
                                          //   context: context,
                                          //   title: 'Update after care message',
                                          //   initialValue: '',
                                          //   checklistId: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        }
                                      },
                                      title: currentUserChecklist![
                                          'checklist_data'][index]['title'],
                                      subtitle: currentUserChecklist![
                                          'checklist_data'][index]['subtitle'],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ;
  }
}
