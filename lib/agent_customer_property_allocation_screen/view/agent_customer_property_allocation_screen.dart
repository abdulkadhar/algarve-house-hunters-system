import 'dart:convert';
import 'dart:html' as html;
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/controller/agent_controller_property_allocation_controller.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/model/unit_agent_checklist_model.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/check_list_unit_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/option_label_selector_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/property_unit_info_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_values_display_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/controller/agent_listing_screen_controller.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'package:algarve_house_hunters_system/global_widgets/agent_user_info_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/date_time_selector.dart';
import 'package:algarve_house_hunters_system/manager_agent_info_section_secreen/widgets/checklist_unit_data_widget.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class AgentCustomerPropertyAllocationScreen extends StatefulWidget {
  final String agentId;
  const AgentCustomerPropertyAllocationScreen({
    super.key,
    required this.agentId,
  });

  @override
  State<AgentCustomerPropertyAllocationScreen> createState() =>
      _AgentCustomerPropertyAllocationScreenState();
}

class _AgentCustomerPropertyAllocationScreenState
    extends State<AgentCustomerPropertyAllocationScreen> {
  List<dynamic>? assignedClients;
  Map<String, dynamic>? selectedUser;

  AgentDashboardOption dashboardOption = AgentDashboardOption.customer;

  bool assignedPropertyLoader = false;
  bool availablePropertyLoader = false;

  List<dynamic>? assignedPropertyList;
  List<dynamic>? unAssignedPropertyList;
  Map<String, dynamic>? currentUserChecklist;

  void getCurrentUserCheckListData(
    String client_id,
  ) async {
    ManagerLogInScreenController.showLoaderDialog(context);
    await ApiController.getClientCheckListData(
      client_id,
      onSuccess: (data) {
        ManagerLogInScreenController.hideDialogBox(context);
        currentUserChecklist = jsonDecode(data)['data'];
        setState(() {});
      },
      onError: (data) {
        ManagerLogInScreenController.hideDialogBox(context);
        ManagerLogInScreenController.showError(
            context, jsonDecode(data).toString());
      },
    );
  }

  void changeDashboardOption(AgentDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  void getClientPropertyList(String customerId) async {
    // ManagerLogInScreenController.showLoaderDialog(context);
    await ApiController.getClientProperties(
      customerId: customerId,
      onError: (errorData) {
        // ManagerLogInScreenController.hideDialogBox(context);
        // ManagerLogInScreenController.showError(
        //   context,
        //   jsonDecode(errorData),
        // );
      },
      onSuccess: (resData) {
        final responseData = jsonDecode(resData);

        assignedPropertyList = responseData['assigned_properties'];
        unAssignedPropertyList = responseData['un_assigned_properties'];
        print('Assigned property list: ${assignedPropertyList}');
        setState(() {});
        // ManagerLogInScreenController.hideDialogBox(context);
      },
    );
  }

  PropertyAllocationOption optionsData = PropertyAllocationOption.userPref;

  void changePropertyAllocationOption(PropertyAllocationOption data) {
    optionsData = data;
    if (optionsData == PropertyAllocationOption.assignProperty) {
      if (selectedUser != null) {
        assignedPropertyList = null;
        unAssignedPropertyList = null;
        setState(() {});
        getClientPropertyList(selectedUser!['client_id']);
      }
    }
    setState(() {});
  }

  UnitAgentChecklistModel unitData =
      AgentControllerPropertyAllocationController.getSampleCheckListItems()
          .first;

  void getAssignedClients() async {
    await ApiController.assignedClients(
      widget.agentId,
      onSuccess: (data) {
        assignedClients = jsonDecode(data);
        if (assignedClients != null && assignedClients!.isNotEmpty) {
          selectedUser = assignedClients![0];
        }
        if (selectedUser != null) {
          getClientPropertyList(selectedUser!['client_id']);
        }
        setState(() {});
      },
      onError: (data) {},
    );
  }

  // SECTION Checklist Operation
  Future<void> afterCareStatusDialog({
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
              content: Column(
                children: [
                  CustomTextFormFiled(
                    initialValue: valueHolder,
                    labelName: 'Message',
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

                      await ApiController.afterCareStatusUpdate(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(
                              context, 'After care has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> saleCompletedStatusDialog({
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
              content: Column(
                children: [
                  CustomTextFormFiled(
                    initialValue: valueHolder,
                    labelName: 'Message',
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

                      await ApiController.saleCompletedStatusUpdate(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Sale completed has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> deedBookedStatusDialog({
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
              content: Column(
                children: [
                  CustomTextFormFiled(
                    initialValue: valueHolder,
                    labelName: 'Message',
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

                      await ApiController.deedBookedStatusUpdate(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'Deed booked status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> allDocsReviewRequestStatusDialog({
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
              content: Column(
                children: [
                  CustomTextFormFiled(
                    initialValue: valueHolder,
                    labelName: 'Message',
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

                      await ApiController.allDocsReviewRequestStatusUpdate(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'All docs review request status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> reviewRequestStatusDialog({
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
              content: Column(
                children: [
                  CustomTextFormFiled(
                    initialValue: valueHolder,
                    labelName: 'Message',
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

                      await ApiController.reviewRequestStatusUpdate(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'Review request status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> KYCRequestStatusDialog({
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
              content: Column(
                children: [
                  CustomTextFormFiled(
                    initialValue: valueHolder,
                    labelName: 'Message',
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

                      await ApiController.KYCStatusUpdate(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'KYC request status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> CPCVBookedStatusStatusDialog({
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
              content: Column(
                children: [
                  CustomTextFormFiled(
                    initialValue: valueHolder,
                    labelName: 'Message',
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

                      await ApiController.CPCVBookedStatusStatus(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'CPCV booked status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> showOfferConfirmedStatusDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required String checklistId,
  }) async {
    String? errorText;
    String? offerValueErrorText;
    String valueHolder = initialValue;
    String offferValueHolder = '';

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
                  CustomTextFormFiled(
                    initialValue: valueHolder,
                    labelName: 'Message',
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
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormFiled(
                    initialValue: offferValueHolder,
                    labelName: 'Offer value',
                    placeholderText: '',
                    isMandatory: true,
                    onChanged: (data) {
                      errorText = null;
                      setState(() {});
                      if (data != null || data!.isNotEmpty) {
                        offferValueHolder = data;
                      } else {
                        setState(() {
                          offerValueErrorText =
                              'Offer value cannot be empty !!!';
                        });
                      }
                    },
                    errorText: offerValueErrorText,
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
                    }
                    if (offferValueHolder == '' || offferValueHolder.isEmpty) {
                      setState(() {
                        errorText = "This field cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);

                      await ApiController.offerConfirmedStatus(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                          "property_id": "smaple property id",
                          "offer_amount": offferValueHolder
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'Property offer confirmed status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> showOfferMadeStatusDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required String checklistId,
  }) async {
    String? errorText;
    String? offerValueErrorText;
    String valueHolder = initialValue;
    String offferValueHolder = '';

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
                  CustomTextFormFiled(
                    initialValue: valueHolder,
                    labelName: 'Message',
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
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFormFiled(
                    initialValue: offferValueHolder,
                    labelName: 'Offer value',
                    placeholderText: '',
                    isMandatory: true,
                    onChanged: (data) {
                      errorText = null;
                      setState(() {});
                      if (data != null || data!.isNotEmpty) {
                        offferValueHolder = data;
                      } else {
                        setState(() {
                          offerValueErrorText =
                              'Offer value cannot be empty !!!';
                        });
                      }
                    },
                    errorText: offerValueErrorText,
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
                    }
                    if (offferValueHolder == '' || offferValueHolder.isEmpty) {
                      setState(() {
                        errorText = "This field cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);

                      await ApiController.offerValueStatus(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                          "property_id": "smaple property id",
                          "offer_amount": offferValueHolder
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'Property offer status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> showPropertyFoundStatusDialog({
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

                      await ApiController.propertyFoundStatus(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                          "property_id": 'Sample property ID.',
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(context,
                              'Property found status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> showOfferMadeDialog({
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
                              html.window.location.reload();
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
                              html.window.location.reload();
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
                              html.window.location.reload();
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
                              html.window.location.reload();
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

  Future<void> showLawyerDialog({
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

                      await ApiController.lawyerUpdateStatus(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder,
                          "lawyer_id": "sample lawyer ID",
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Lawyer status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> showFiscalDialog({
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

                      await ApiController.fiscalUpdateStatus(
                        {
                          "checklist_id": checklistId,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "action_msg": valueHolder
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Fiscal status has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  Future<void> showOnBoardingDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required String status,
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
                      if (status == 'onboard') {
                        await ApiController.onBoardingDocumentsUpdate(
                          {
                            "checklist_id": checklistId,
                            "agent_id": "MNG-BLR-20250625-0001",
                            "action_msg": valueHolder
                          },
                          onSuccess: (resData) {
                            ManagerLogInScreenController.showSuccess(
                                context, 'Details has been updated !!!');
                            Future.delayed(
                              const Duration(seconds: 2),
                              () {
                                html.window.location.reload();
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
                        meetingLinkInitial = data;
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
                            "&add=${selectedUser!['client_email_address']}";

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
                    if (meetingLinkInitial == '' ||
                        meetingLinkInitial.isEmpty) {
                      setState(() {
                        errorText = "Meeting link field cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);

                      await ApiController.firstCallUpdateStatus(
                        {
                          "checklist_id": checklist_id,
                          "agent_id": "MNG-BLR-20250625-0001",
                          "call_time_details": timingDetailsIso,
                          "meet_link": linkValue,
                          "client_email": selectedUser!['client_email_address'],
                          "client_name": selectedUser!['client_name'],
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Meeting has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              html.window.location.reload();
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

  @override
  void initState() {
    super.initState();
    getAssignedClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.pageBackgroundColor,
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
                            dashboardOption == AgentDashboardOption.dashboard,
                        iconData: Icons.dashboard,
                        optionLabel: 'Dashboard',
                        onTap: () {
                          // changeDashboardOption(
                          //   AgentDashboardOption.dashboard,
                          // );
                          context
                              .go('/agent-dashboard-screen/${widget.agentId}');
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == AgentDashboardOption.listings,
                        iconData: Icons.list,
                        optionLabel: 'Listings',
                        onTap: () {
                          // context.go('/agent-listing-screen');
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == AgentDashboardOption.calendar,
                        iconData: Icons.document_scanner,
                        optionLabel: 'Onboarding Document',
                        onTap: () {
                          context.go(
                              '/agent-onboarding-document-screen/${widget.agentId}');
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == AgentDashboardOption.customer,
                        iconData: Icons.dashboard_customize_rounded,
                        optionLabel: 'Client',
                        onTap: () {
                          changeDashboardOption(
                            AgentDashboardOption.customer,
                          );
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  AgentUserInfoWidget(
                    agentData:
                        AgentDashboardScreenController.getSampleAgentModel(),
                    onProfilePress: () {},
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
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
                        Row(
                          children: [
                            Text(
                              'Assigned Clients',
                              style: ThemeController.normalTextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                context.go(
                                    '/agent-add-user-screen/${widget.agentId}');
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.black,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        if (assignedClients != null)
                          Column(
                            children: List.generate(
                              assignedClients!.length,
                              (index) => ClientQuickActionWidget(
                                userData: assignedClients![index],
                                isSelected: assignedClients![index]
                                        ["client_id"] ==
                                    selectedUser!["client_id"],
                                onProfilePress: () {
                                  selectedUser = assignedClients![index];
                                  changePropertyAllocationOption(
                                      PropertyAllocationOption.userPref);
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // NOTE Empty Space
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              OptionLabelSelectorWidget(
                                isEnabled: optionsData ==
                                    PropertyAllocationOption.userPref,
                                onPress: () {
                                  changePropertyAllocationOption(
                                    PropertyAllocationOption.userPref,
                                  );
                                },
                                optionLabel: 'User Preferences',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionsData ==
                                    PropertyAllocationOption.assignProperty,
                                onPress: () {
                                  changePropertyAllocationOption(
                                    PropertyAllocationOption.assignProperty,
                                  );
                                },
                                optionLabel: 'Assign Property',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionsData ==
                                    PropertyAllocationOption.checklist,
                                onPress: () {
                                  getCurrentUserCheckListData(
                                    selectedUser!['client_id'],
                                  );
                                  changePropertyAllocationOption(
                                    PropertyAllocationOption.checklist,
                                  );
                                },
                                optionLabel: 'Check List',
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (optionsData == PropertyAllocationOption.userPref)
                            Column(
                              children: [
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Finding preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['findingPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Bed number',
                                  labelValue: selectedUser!['preference_data']
                                          ['bedNumber']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Bath number',
                                  labelValue: selectedUser!['preference_data']
                                          ['bathNumber']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Requirement preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['requirementPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Other preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['otherPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'House regards preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['houseRegardsPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Neighbor preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['neighborPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Location Preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['locationPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'M2Preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['M2Preference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Buying preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['buyingPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Value spend preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['valueSpendPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Tax Preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['taxPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Residence Info',
                                  labelValue: selectedUser!['preference_data']
                                          ['residenceInfo']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Language Preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['languagePreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Viewing Preference',
                                  labelValue: selectedUser!['preference_data']
                                          ['viewingPreference']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Other Agents Status',
                                  labelValue: selectedUser!['preference_data']
                                          ['otherAgentsStatus']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Fiscal Status',
                                  labelValue: selectedUser!['preference_data']
                                          ['fiscalStatus']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Bank Status',
                                  labelValue: selectedUser!['preference_data']
                                          ['bankStatus']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Additional Info',
                                  labelValue: selectedUser!['preference_data']
                                          ['additionalInfo']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Email',
                                  labelValue: selectedUser!['preference_data']
                                          ['email']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Phone Number',
                                  labelValue: selectedUser!['preference_data']
                                          ['phoneNumber']
                                      .toString(),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Appointment Info',
                                  labelValue: selectedUser!['preference_data']
                                          ['appointmentInfo']
                                      .toString(),
                                ),
                              ],
                            ),
                          if (optionsData ==
                              PropertyAllocationOption.assignProperty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assigned Property',
                                  style: ThemeController.smallTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (assignedPropertyList == null)
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Center(
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                if (assignedPropertyList != null &&
                                    assignedPropertyList!.isNotEmpty)
                                  SizedBox(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: assignedPropertyList!.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // 2 columns
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                      itemBuilder: (context, index) {
                                        return PropertyUnitInfoWidget(
                                          propertyData:
                                              assignedPropertyList![index],
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          if (optionsData ==
                              PropertyAllocationOption.assignProperty)
                            const SizedBox(
                              height: 20,
                            ),
                          if (optionsData ==
                              PropertyAllocationOption.assignProperty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Listed Property',
                                  style: ThemeController.smallTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (unAssignedPropertyList == null)
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width: MediaQuery.of(context).size.width,
                                    child: const Center(
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  ),
                                if (unAssignedPropertyList != null &&
                                    unAssignedPropertyList!.isNotEmpty)
                                  SizedBox(
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: unAssignedPropertyList!.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, // 2 columns
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 0.85,
                                      ),
                                      itemBuilder: (context, index) {
                                        return PropertyUnitInfoWidget(
                                          propertyData:
                                              unAssignedPropertyList![index],
                                          isAssignButton: true,
                                          onTap: () async {
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            if (unAssignedPropertyList !=
                                                    null &&
                                                selectedUser != null) {
                                              await ApiController
                                                  .assignProperty(
                                                propertyId:
                                                    unAssignedPropertyList![
                                                        index]['propertyId'],
                                                customerId:
                                                    selectedUser!['client_id'],
                                                onSuccess: (resData) async {
                                                  ManagerLogInScreenController
                                                      .showSuccess(context,
                                                          'Property has been assigned to the user !!!!');
                                                  await Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                      print(
                                                          "This runs after 2 seconds");
                                                      if (!mounted) {
                                                        return;
                                                      }
                                                      html.window.location
                                                          .reload();
                                                    },
                                                  );
                                                  ManagerLogInScreenController
                                                      .hideDialogBox(context);
                                                },
                                                onError: (errData) {
                                                  ManagerLogInScreenController
                                                      .showError(
                                                    context,
                                                    jsonDecode(errData),
                                                  );
                                                  ManagerLogInScreenController
                                                      .hideDialogBox(context);
                                                },
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          if (optionsData == PropertyAllocationOption.checklist)
                            const SizedBox(
                              height: 20,
                            ),
                          if (optionsData == PropertyAllocationOption.checklist)
                            if (currentUserChecklist != null)
                              Column(
                                children: List.generate(
                                  currentUserChecklist!['checklist_data']
                                      .length,
                                  (index) => Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      CheckListUnitDataWidget(
                                        agentId: widget.agentId,
                                        checklistId: currentUserChecklist![
                                            'checklist_id'],
                                        index: index,
                                        clientData: selectedUser,
                                        userData: currentUserChecklist![
                                            'checklist_data'][index],
                                        isOn: currentUserChecklist![
                                                    'checklist_data'][index]
                                                ['status'] !=
                                            'Not-Started',
                                        onTogglePress: (data) async {
                                          if (index == 0) {
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .onBoardingDocumentsUpdate(
                                              {
                                                "checklist_id":
                                                    currentUserChecklist![
                                                        'checklist_id'],
                                                "agent_id": widget.agentId,
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
                                                    html.window.location
                                                        .reload();
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
                                          } else if (index == 1) {
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .clientEmailUpdate(
                                              {
                                                "checklist_id":
                                                    currentUserChecklist![
                                                        'checklist_id'],
                                                "agent_id": widget.agentId,
                                                "action_msg": data
                                                    ? "<b style=\"color:green\">The Action has been completed</b>"
                                                    : "<b style=\"color:red\">The Action has been re-opened</b>",
                                                "status": data
                                                    ? "Completed"
                                                    : "Not-Started",
                                                "client_email_address":
                                                    selectedUser![
                                                        'client_email_address']
                                              },
                                              onSuccess: (resData) {
                                                ManagerLogInScreenController
                                                    .showSuccess(context,
                                                        'Status has been updated !!!');
                                                Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                    html.window.location
                                                        .reload();
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
                                          } else if (index == 2) {
                                            await ApiController
                                                .firstCallStatusUpdate(
                                              {
                                                "checklist_id":
                                                    currentUserChecklist![
                                                        'checklist_id'],
                                                "agent_id": widget.agentId,
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
                                                    html.window.location
                                                        .reload();
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
                                            // showFirstCallDialog(
                                            //   context: context,
                                            //   title: 'Schedule call',
                                            //   messageInitial: '',
                                            //   meetingLinkInitial: '',
                                            //   checklist_id:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 3) {
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .updateFiscalStatusData(
                                              {
                                                "checklist_id":
                                                    currentUserChecklist![
                                                        'checklist_id'],
                                                "agent_id": widget.agentId,
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
                                                    html.window.location
                                                        .reload();
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
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 4) {
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .lawyerUpdateStatus(
                                              {
                                                "checklist_id":
                                                    currentUserChecklist![
                                                        'checklist_id'],
                                                "agent_id": widget.agentId,
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
                                                    html.window.location
                                                        .reload();
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
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 5) {
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
                                                    html.window.location
                                                        .reload();
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
                                          } else if (index == 6) {
                                            showViewingConfirmDialog(
                                                context: context,
                                                title:
                                                    'Update viewing confirmation message',
                                                initialValue: '',
                                                checklistId:
                                                    currentUserChecklist![
                                                        'checklist_id']);
                                          } else if (index == 7) {
                                            showPropertyBookingDialog(
                                              context: context,
                                              title:
                                                  'Update viewing booking message',
                                              initialValue: '',
                                              checklistId:
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                            );
                                          } else if (index == 8) {
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .propertyFoundStatusAlone(
                                              {
                                                "checklist_id":
                                                    currentUserChecklist![
                                                        'checklist_id'],
                                                "agent_id": widget.agentId,
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
                                                    html.window.location
                                                        .reload();
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
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 9) {
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .offerValueStatusAlone(
                                              {
                                                "checklist_id":
                                                    currentUserChecklist![
                                                        'checklist_id'],
                                                "agent_id": widget.agentId,
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
                                                    html.window.location
                                                        .reload();
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
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 10) {
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .offerConfirmedStatusAlone(
                                              {
                                                "checklist_id":
                                                    currentUserChecklist![
                                                        'checklist_id'],
                                                "agent_id": widget.agentId,
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
                                                    html.window.location
                                                        .reload();
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
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 11) {
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
                                                    html.window.location
                                                        .reload();
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
                                            //   title:
                                            //       'Update CPCV booked message',
                                            //   initialValue: '',
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 12) {
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
                                                    html.window.location
                                                        .reload();
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
                                            //   title:
                                            //       'Update KYC request message',
                                            //   initialValue: '',
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 13) {
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
                                                    html.window.location
                                                        .reload();
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
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 14) {
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
                                                    html.window.location
                                                        .reload();
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
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 15) {
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
                                                    html.window.location
                                                        .reload();
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
                                            //   title:
                                            //       'Update deed booked message',
                                            //   initialValue: '',
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 16) {
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
                                                    html.window.location
                                                        .reload();
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
                                            //   checklistId:
                                            //       currentUserChecklist![
                                            //           'checklist_id'],
                                            // );
                                          } else if (index == 17) {
                                            afterCareStatusDialog(
                                              context: context,
                                              title:
                                                  'Update after care message',
                                              initialValue: '',
                                              checklistId:
                                                  currentUserChecklist![
                                                      'checklist_id'],
                                            );
                                          }
                                        },
                                        title: currentUserChecklist![
                                            'checklist_data'][index]['title'],
                                        subtitle: currentUserChecklist![
                                                'checklist_data'][index]
                                            ['subtitle'],
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
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
