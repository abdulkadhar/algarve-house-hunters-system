import 'dart:convert';
import 'dart:html' as html;
import 'package:algarve_house_hunters_system/agent_client_info_screen/controller/agent_client_info_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_client_info_screen/widgets/agent_info_tile.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/option_label_selector_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_values_display_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/client_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_controller/global_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/date_time_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/preference_details_unit_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/warning_alert_box.dart';
import 'package:algarve_house_hunters_system/manager_agent_info_section_secreen/widgets/checklist_unit_data_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/view/manager_dashboard_screen.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/oldest_newest_filter.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AgentClientInfoScreen extends StatefulWidget {
  final String clientId;
  const AgentClientInfoScreen({
    super.key,
    required this.clientId,
  });

  @override
  State<AgentClientInfoScreen> createState() => _AgentClientInfoScreenState();
}

class _AgentClientInfoScreenState extends State<AgentClientInfoScreen> {
  ClientTypeOption clientTypeOption = ClientTypeOption.unAssigned;
  List<dynamic>? clientData;
  List<dynamic>? unAssignedClients;
  AgentClientInfoOption optionData = AgentClientInfoOption.basicInfo;
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.clients;

  List<dynamic> unassignedClientSearchResult = [];
  List<dynamic> assignedClientSearchResult = [];

  String unassignedQuery = '';
  String assignedQuery = '';

  void changeAgentOption(AgentClientInfoOption data) {
    assignedAgents = [];
    availableAgents = [];
    setState(() {});
    optionData = data;
    if (data == AgentClientInfoOption.agentInfo) {
      getAvailableAgent(selectedClient!['client_id']);
      setState(() {});
    }
    setState(() {});
  }

  void setClientOptionType(ClientTypeOption option) {
    clientTypeOption = option;
    setState(() {});
  }

  Map<String, dynamic>? selectedClient;
  Map<String, dynamic>? selectedAgent;
  Map<String, dynamic>? currentUserChecklist;
  List<dynamic> assignedAgents = [];

  List<dynamic> availableAgents = [];

  void getAvailableAgent(String clientId) async {
    await ApiController.getAvailableAgents(
      clientId,
      onSuccess: (data) {
        assignedAgents = jsonDecode(data)['assigned_agents'];
        availableAgents = jsonDecode(data)['un_assigned_agents'];
        print('assigned agents length: ${assignedAgents.length}');
        print('available agents length: ${availableAgents.length}');
        setState(() {});
      },
      onError: (data) {
        print('Error has occured');
        print(jsonDecode(data));
      },
    );
  }

  void changeDashboardOption(ManagerDashboardOption option) async {
    dashboardOption = option;

    setState(() {});
  }

  Future<bool> checkFirstCallStatus(
    String client_id,
  ) async {
    bool checkStatus = false;
    await ApiController.getClientCheckListData(
      client_id,
      onSuccess: (data) {
        checkStatus = jsonDecode(data)['data']['checklist_data'][0]['status'] ==
                'Not-Started'
            ? false
            : true;
      },
      onError: (data) {
        checkStatus = false;
      },
    );
    return checkStatus;
  }

  Future<void> getCurrentUserCheckListData(
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

  void getAgentData(
    String agentId,
  ) async {
    await ApiController.getAgentInfoById(
      agentId,
      onSuccess: (data) {
        selectedAgent = jsonDecode(data);
        currentUserChecklist = null;
        setState(() {});
      },
      onError: (data) {
        print("Agent ClientInfo Screen: Agent Info Fetch Error");
      },
    );
  }

  void getClientData() async {
    await ApiController.getAllClientsData(
      onSuccess: (responseData) {
        clientData = jsonDecode(responseData) as List<dynamic>;
        clientData = clientData!.reversed.toList();
        currentUserChecklist = null;
        setState(() {});
        print('Data has been loaded');
      },
      onError: (errorData) {
        print("Error has occured !!!");
      },
    );
  }

  void getClientInfo() async {
    await ApiController.getClientInfoByID(
      widget.clientId,
      onSuccess: (responseData) {
        selectedClient = jsonDecode(responseData);
        if (selectedClient != null) {
          assignedAgents = selectedClient!['agent_id'];
        }
        currentUserChecklist = null;
        setState(() {});
        print('Data has been loaded');
      },
      onError: (errorData) {
        print("Error has occured !!!");
      },
    );
  }

  void getUnAssignedClientsData() async {
    await ApiController.getUnAssignedClientsData(
      onSuccess: (responseData) {
        unAssignedClients = jsonDecode(responseData) as List<dynamic>;
        unAssignedClients = unAssignedClients!.reversed.toList();
        setState(() {});
        print('Data has been loaded');
      },
      onError: (errorData) {
        ManagerLogInScreenController.showError(
            context, "Error fetching un assigned data !!!!");
        print("Error has occured !!!");
      },
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                // html.window.location.reload();
                                if (context.mounted) {
                                  context.push(
                                      '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                            "&add=${selectedClient!['client_email_address']}";

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
                          // TODO update the description with the text field
                          "action_msg": "description of the call",
                          "client_email":
                              selectedClient!['client_email_address'],
                          "client_name": selectedClient!['client_name'],
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Meeting has been updated !!!');
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              // html.window.location.reload();
                              if (context.mounted) {
                                context.push(
                                    '/manager-client-info-screen/${selectedClient!['client_id']}');
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

  //!SECTION

  Future<void> showBlackDialog(
    BuildContext context,
    String title,
    String initialValue,
    String status,
    String clientId,
  ) async {
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

                      if (status == 'approved') {
                        await ApiController.approveCustomer(
                          clientId: clientId,
                          msg: valueHolder,
                          onSuccess: (data) async {
                            ManagerLogInScreenController.showSuccess(
                                context, 'Client has been approved');
                            await Future.delayed(
                              const Duration(seconds: 2),
                              () {
                                // html.window.location.reload();
                                if (context.mounted) {
                                  context.push(
                                      '/manager-client-info-screen/${selectedClient!['client_id']}');
                                }
                              },
                            );
                          },
                          onError: (errorData) {
                            var response = jsonDecode(errorData);

                            ManagerLogInScreenController.showError(
                                context, response.toString());
                          },
                        );
                      } else if (status == 'sold') {
                        await ApiController.soldCustomer(
                          clientId: clientId,
                          msg: valueHolder,
                          onSuccess: (data) async {
                            ManagerLogInScreenController.showSuccess(context,
                                'Client has been updated with sold status.');
                            await Future.delayed(
                              const Duration(seconds: 2),
                              () {
                                // html.window.location.reload();
                                if (context.mounted) {
                                  context.push(
                                      '/manager-client-info-screen/${selectedClient!['client_id']}');
                                }
                              },
                            );
                          },
                          onError: (errorData) {
                            var response = jsonDecode(errorData);

                            ManagerLogInScreenController.showError(
                                context, response.toString());
                          },
                        );
                      } else {
                        await ApiController.rejectCustomer(
                          clientId: clientId,
                          msg: valueHolder,
                          onSuccess: (data) async {
                            ManagerLogInScreenController.showSuccess(
                                context, 'Client has been rejected');
                            await Future.delayed(
                              const Duration(seconds: 2),
                              () {
                                // html.window.location.reload();
                                if (context.mounted) {
                                  context.push(
                                      '/manager-client-info-screen/${selectedClient!['client_id']}');
                                }
                              },
                            );
                          },
                          onError: (errorData) {
                            var response = jsonDecode(errorData);

                            ManagerLogInScreenController.showError(
                                context, response.toString());
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

  Widget getClientOptionSelectorWidget() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (clientTypeOption != ClientTypeOption.unAssigned)
            InkWell(
              onTap: () {
                setClientOptionType(ClientTypeOption.unAssigned);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Unassigned Clients",
                  style: ThemeController.normalTextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w800,
                    size: 12,
                  ),
                ),
              ),
            ),
          if (clientTypeOption == ClientTypeOption.unAssigned)
            InkWell(
              onTap: () {
                setClientOptionType(ClientTypeOption.unAssigned);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Unassigned Clients",
                  style: ThemeController.normalTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    size: 12,
                  ),
                ),
              ),
            ),
          if (clientTypeOption == ClientTypeOption.assigned)
            InkWell(
              onTap: () {
                setClientOptionType(ClientTypeOption.assigned);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Assigned Clients",
                  style: ThemeController.normalTextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    size: 12,
                  ),
                ),
              ),
            ),
          if (clientTypeOption != ClientTypeOption.assigned)
            InkWell(
              onTap: () {
                setClientOptionType(ClientTypeOption.assigned);
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Assigned Clients",
                  style: ThemeController.normalTextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w800,
                    size: 12,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  List<dynamic> searchClients(List<dynamic> clients, String query) {
    if (query.isEmpty) return clients;

    final lowerQuery = query.toLowerCase();

    return clients.where((client) {
      if (client is Map<String, dynamic>) {
        final name = (client['client_name'] ?? '').toString().toLowerCase();
        final email =
            (client['client_email_address'] ?? '').toString().toLowerCase();
        return name.contains(lowerQuery) || email.contains(lowerQuery);
      }
      return false;
    }).toList();
  }

  Future<void> showNotesDialogBox(
    BuildContext context,
    String title,
    String initialValue,
    String clientId,
    Function(String) onSubmit,
  ) async {
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
                isMandatory: true,
                onChanged: (data) {
                  errorText = null;
                  setState(() {});
                  if (data != null || data!.isNotEmpty) {
                    valueHolder = data;
                  } else {
                    setState(() {
                      errorText = 'Notes cannot be empty !!!';
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
                        errorText = "Notes field cannot be empty";
                      });
                    } else if (initialValue == valueHolder) {
                      setState(() {
                        errorText = "No change has been made";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);
                      onSubmit(valueHolder);
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

  Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap a button

      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Confirm Delete'),
          content: const Text(
            'Do you wish to proceed with deleting the client?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // close dialog
              },
              child: Text('Cancel',
                  style: ThemeController.smallTextStyle(
                    color: Colors.black,
                  )),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // close dialog
                onConfirm(); // execute delete action
              },
              child: Text(
                'Delete',
                style: ThemeController.smallTextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getClientData();
    getClientInfo();
    getAvailableAgent(widget.clientId);
    getUnAssignedClientsData();
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
                          context.go('/manager-property-management-screen');
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
                              '/manager-client-info-screen/CLT-BLR-20221117-0001');
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
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(15),
                      children: [
                        Row(
                          children: [
                            Text(
                              'Client list',
                              style: ThemeController.normalTextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                context.go(
                                  '/manager-add-client-screen',
                                );
                              },
                              child: const Icon(
                                Icons.add,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (unAssignedClients != null &&
                            selectedClient != null &&
                            clientTypeOption == ClientTypeOption.unAssigned)
                          Column(
                            children: [
                              getClientOptionSelectorWidget(),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                children: [
                                  CustomTextFormFiled(
                                    isMandatory: false,
                                    labelName: '',
                                    placeholderText: 'Search',
                                    onChanged: (data) {
                                      unassignedQuery = data;
                                      unassignedClientSearchResult = [];
                                      setState(() {});
                                      unassignedClientSearchResult =
                                          searchClients(
                                        unAssignedClients!,
                                        unassignedQuery,
                                      );
                                      setState(() {});
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  if (unassignedQuery.isEmpty)
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: OldestNewestFilter(
                                        getOptionData: (data) {
                                          unAssignedClients = unAssignedClients!
                                              .reversed
                                              .toList();

                                          setState(() {});
                                        },
                                      ),
                                    ),
                                ],
                              ),
                              Column(
                                children: List.generate(
                                  unassignedQuery.isEmpty
                                      ? unAssignedClients!.length
                                      : unassignedClientSearchResult.length,
                                  (index) => ClientQuickActionWidget(
                                    userData: unassignedQuery.isEmpty
                                        ? unAssignedClients![index]
                                        : unassignedClientSearchResult[index],
                                    isSelected: unAssignedClients![index]
                                            ['client_id'] ==
                                        selectedClient!['client_id'],
                                    onProfilePress: () {
                                      selectedClient = unassignedQuery.isEmpty
                                          ? unAssignedClients![index]
                                          : unassignedClientSearchResult[index];
                                      // selectedClient =
                                      //     unAssignedClients![index];
                                      changeAgentOption(
                                          AgentClientInfoOption.basicInfo);
                                      setState(() {});
                                      // context.go(
                                      //     '/manager-client-info-screen/${unAssignedClients![index]['client_id']}');
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        if (clientData != null &&
                            selectedClient != null &&
                            clientTypeOption == ClientTypeOption.assigned)
                          Column(
                            children: [
                              getClientOptionSelectorWidget(),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormFiled(
                                isMandatory: false,
                                labelName: '',
                                placeholderText: 'Searc',
                                onChanged: (data) {
                                  assignedQuery = data;
                                  assignedClientSearchResult = [];
                                  setState(() {});
                                  assignedClientSearchResult = searchClients(
                                    clientData!,
                                    assignedQuery,
                                  );
                                  setState(() {});
                                },
                              ),
                              if (assignedQuery.isEmpty)
                                const SizedBox(
                                  height: 10,
                                ),
                              if (assignedQuery.isEmpty)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: OldestNewestFilter(
                                    getOptionData: (data) {
                                      clientData =
                                          clientData!.reversed.toList();

                                      setState(() {});
                                    },
                                  ),
                                ),
                              if (assignedQuery.isEmpty)
                                const SizedBox(
                                  height: 10,
                                ),
                              Column(
                                children: List.generate(
                                  assignedQuery.isEmpty
                                      ? clientData!.length
                                      : assignedClientSearchResult.length,
                                  (index) => ClientQuickActionWidget(
                                    userData: assignedQuery.isEmpty
                                        ? clientData![index]
                                        : assignedClientSearchResult[index],
                                    isSelected: assignedQuery.isEmpty
                                        ? clientData![index]['client_id'] ==
                                            selectedClient!['client_id']
                                        : assignedClientSearchResult[index]
                                                ['client_id'] ==
                                            selectedClient!['client_id'],
                                    onProfilePress: () {
                                      selectedClient = assignedQuery.isEmpty
                                          ? clientData![index]
                                          : assignedClientSearchResult[index];
                                      // selectedClient = clientData![index];
                                      changeAgentOption(
                                          AgentClientInfoOption.basicInfo);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        if (clientData == null || unAssignedClients == null)
                          const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: Colors.black,
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
                          // NOTE Internal option
                          Row(
                            children: [
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentClientInfoOption.basicInfo,
                                onPress: () {
                                  changeAgentOption(
                                      AgentClientInfoOption.basicInfo);
                                },
                                optionLabel: 'Basic Info',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentClientInfoOption.preferenceInfo,
                                onPress: () {
                                  changeAgentOption(
                                    AgentClientInfoOption.preferenceInfo,
                                  );
                                },
                                optionLabel: 'Preference Info',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentClientInfoOption.agentInfo,
                                onPress: () {
                                  final tempAgentIds =
                                      selectedClient!['agent_id']
                                          as List<dynamic>;
                                  if (selectedClient != null &&
                                      tempAgentIds.isNotEmpty) {
                                    // getCurrentUserCheckListData(
                                    //     selectedAgent!['agent_id']);
                                    // getAgentData(tempAgentIds[0]);
                                    print('Lenght is not zero');
                                  }
                                  changeAgentOption(
                                    AgentClientInfoOption.agentInfo,
                                  );
                                },
                                optionLabel: 'Agent Info',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentClientInfoOption.clientChecklist,
                                onPress: () async {
                                  if (selectedClient != null) {
                                    if (selectedClient!['agent_id'] != '') {
                                      await getCurrentUserCheckListData(
                                        selectedClient!['client_id'],
                                      );
                                      changeAgentOption(
                                        AgentClientInfoOption.clientChecklist,
                                      );
                                    }
                                  }
                                },
                                optionLabel: 'Checklist',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  showDeleteConfirmationDialog(
                                    context: context,
                                    onConfirm: () {
                                      ManagerLogInScreenController
                                          .showLoaderDialog(context);
                                      ApiController.deleteClientData(
                                        selectedClient!['client_id'],
                                        onSuccess: (response) {
                                          ManagerLogInScreenController
                                              .showSuccess(
                                            context,
                                            'Client deleted successfully !!!',
                                          );
                                          // html.window.location.reload();
                                          context
                                              .go('/manager-dashboard-screen');
                                        },
                                        onError: (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error deleting agent: $error')),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.red,
                                    ),
                                  ),
                                  child: Text(
                                    "Delete client",
                                    style: ThemeController.smallTextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.purple,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  selectedClient!['client_name'],
                                  style: ThemeController.smallTextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              OptionLabelSelectorWidget(
                                isEnabled: selectedClient!['approved_status'] ==
                                    'in-progress',
                                onPress: () async {
                                  ManagerLogInScreenController.showLoaderDialog(
                                      context);
                                  await ApiController.moveCustomerToInProgress(
                                    clientId: selectedClient!['client_id'],
                                    onSuccess: (data) async {
                                      ManagerLogInScreenController.showSuccess(
                                          context,
                                          'Client has been moved to in progress status');
                                      await Future.delayed(
                                        const Duration(seconds: 2),
                                        () {
                                          // NOTE Navigation logic is handled here
                                          // html.window.location.reload();
                                          if (context.mounted) {
                                            context.push(
                                                '/manager-client-info-screen/${selectedClient!['client_id']}');
                                          }
                                        },
                                      );
                                    },
                                    onError: (errorData) {
                                      var response = jsonDecode(errorData);

                                      ManagerLogInScreenController.showError(
                                          context, response.toString());
                                    },
                                  );
                                },
                                optionLabel: 'In progress',
                                enabledBorderColor: Colors.blue,
                                enabledTextColor: Colors.blue,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: selectedClient!['approved_status'] ==
                                    'approved',
                                onPress: () async {
                                  ManagerLogInScreenController.showLoaderDialog(
                                      context);
                                  bool isFirstCallChecked =
                                      await checkFirstCallStatus(
                                          selectedClient!['client_id']);
                                  if (context.mounted) {
                                    ManagerLogInScreenController.hideDialogBox(
                                      context,
                                    );

                                    if (!isFirstCallChecked) {
                                      ManagerLogInScreenController.showError(
                                        context,
                                        'Complete first call process to approve.',
                                      );
                                    } else {
                                      await GetAlertDialogBox
                                          .warningAlertDialogBox(
                                        context,
                                        title: "Approve client",
                                        warningText:
                                            "Do you wish to approve the client.",
                                        confirmLabel: "Confirm",
                                        cancelTextWidget: Text(
                                          "Cancel",
                                          style: ThemeController.smallTextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onCancel: () {
                                          Navigator.pop(context);
                                        },
                                        onConfirm: () async {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController.approveCustomer(
                                            clientId:
                                                selectedClient!['client_id'],
                                            msg: "Client has been approved",
                                            onSuccess: (data) async {
                                              ManagerLogInScreenController
                                                  .showSuccess(context,
                                                      'Client has been approved');
                                              await Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errorData) {
                                              var response =
                                                  jsonDecode(errorData);

                                              ManagerLogInScreenController
                                                  .showError(context,
                                                      response.toString());
                                            },
                                          );
                                        },
                                      );
                                    }
                                  }
                                },
                                optionLabel: 'Approved',
                                enabledBorderColor: Colors.green,
                                enabledTextColor: Colors.green,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: selectedClient!['approved_status'] ==
                                    'rejected',
                                onPress: () async {
                                  await showBlackDialog(
                                    context,
                                    'Reject client',
                                    '',
                                    'rejected',
                                    selectedClient!['client_id'],
                                  );
                                },
                                optionLabel: 'Rejected',
                                enabledBorderColor: Colors.red,
                                enabledTextColor: Colors.red,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: selectedClient!['approved_status'] ==
                                    'sold',
                                onPress: () async {
                                  await showBlackDialog(
                                    context,
                                    'Update sold status',
                                    '',
                                    'sold',
                                    selectedClient!['client_id'],
                                  );
                                },
                                optionLabel: 'Sold',
                                enabledBorderColor: Colors.amber,
                                enabledTextColor: Colors.amber,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // NOTE Basic Info
                          if (selectedClient != null &&
                              optionData == AgentClientInfoOption.basicInfo)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Client ID',
                                  labelValue: selectedClient!['client_id'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'First name',
                                  labelValue:
                                      selectedClient!['client_first_name'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Second name',
                                  labelValue:
                                      selectedClient!['client_second_name'],
                                ),

                                // const SizedBox(
                                //   height: 5,
                                // ),
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: [
                                //     SizedBox(
                                //       width: 450,
                                //       child: Text(
                                //         'Name',
                                //         style: ThemeController.normalTextStyle(
                                //           size: 16,
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 450,
                                //       child: CustomTextFormFiled(
                                //         labelName: '',
                                //         placeholderText: '',
                                //         onChanged: (data) {},
                                //         isMandatory: false,
                                //         initialValue:
                                //             selectedClient!['client_name'],
                                //       ),
                                //     )
                                //   ],
                                // ),
                                // Row(
                                //   crossAxisAlignment: CrossAxisAlignment.center,
                                //   children: [
                                //     SizedBox(
                                //       width: 450,
                                //       child: Text(
                                //         'Name',
                                //         style: ThemeController.normalTextStyle(
                                //           size: 16,
                                //         ),
                                //       ),
                                //     ),
                                //     SizedBox(
                                //       width: 450,
                                //       child: CustomTextFormFiled(
                                //         labelName: '',
                                //         placeholderText: '',
                                //         onChanged: (data) {},
                                //         isMandatory: false,
                                //         initialValue:
                                //             selectedClient!['client_name'],
                                //       ),
                                //     )
                                //   ],
                                // ),
                                // UserPreferenceValuesDisplayWidget(
                                //   labelName: 'Name',
                                //   labelValue: selectedClient!['client_name'],
                                // ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Email address',
                                  labelValue:
                                      selectedClient!['client_email_address'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Phone number',
                                  labelValue:
                                      selectedClient!['client_phone_number'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Location name',
                                  labelValue:
                                      selectedClient!['client_location_name'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Designation',
                                  labelValue:
                                      selectedClient!['client_designation'],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Company name',
                                  labelValue:
                                      selectedClient!['client_company_name'],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Manager info",
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Notes",
                                      style: ThemeController.normalTextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Spacer(),
                                    OptionLabelSelectorWidget(
                                      isEnabled: true,
                                      onPress: () async {
                                        await showNotesDialogBox(
                                          context,
                                          'Add notes',
                                          '',
                                          selectedClient!['client_id'],
                                          (data) async {
                                            await ApiController.addManagerNotes(
                                              {
                                                "client_id": selectedClient![
                                                    'client_id'],
                                                "notes_value": data
                                              },
                                              onSuccess: (resData) async {
                                                ManagerLogInScreenController
                                                    .showSuccess(context,
                                                        'Notes has been added !!!');
                                                await Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                    if (!mounted) {
                                                      return;
                                                    }
                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              },
                                              onError: (errData) {
                                                ManagerLogInScreenController
                                                    .hideDialogBox(context);
                                                ManagerLogInScreenController
                                                    .showError(context,
                                                        jsonDecode(errData));
                                              },
                                            );
                                          },
                                        );
                                      },
                                      optionLabel: 'Add notes',
                                      enabledBorderColor: Colors.black,
                                      enabledTextColor: Colors.black,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                if (selectedClient!['manager_notes'] != null)
                                  Column(
                                    children: List.generate(
                                      selectedClient!['manager_notes'].length,
                                      (index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child:
                                              UserPreferenceValuesDisplayWidget(
                                            isEdit: true,
                                            onEditPress: () async {
                                              await showNotesDialogBox(
                                                context,
                                                'Edit notes',
                                                selectedClient!['manager_notes']
                                                    [index]['notes_value'],
                                                selectedClient!['client_id'],
                                                (data) async {
                                                  await ApiController
                                                      .editManagerNotes(
                                                    {
                                                      "client_id":
                                                          selectedClient![
                                                              'client_id'],
                                                      "notes_value": data,
                                                      "notes_id": selectedClient![
                                                              'manager_notes']
                                                          [index]['notes_id']
                                                    },
                                                    onSuccess: (resData) async {
                                                      ManagerLogInScreenController
                                                          .showSuccess(context,
                                                              'Notes has been added !!!');
                                                      await Future.delayed(
                                                        const Duration(
                                                            seconds: 2),
                                                        () {
                                                          if (!mounted) {
                                                            return;
                                                          }
                                                          html.window.location
                                                              .reload();
                                                        },
                                                      );
                                                    },
                                                    onError: (errData) {
                                                      ManagerLogInScreenController
                                                          .hideDialogBox(
                                                              context);
                                                      ManagerLogInScreenController
                                                          .showError(
                                                              context,
                                                              jsonDecode(
                                                                  errData));
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            labelName:
                                                AgentDashboardScreenController
                                                    .formatIsoToCustomTime(
                                                        selectedClient![
                                                                'manager_notes']
                                                            [
                                                            index]['notes_date']),
                                            labelValue:
                                                selectedClient!['manager_notes']
                                                    [index]['notes_value'],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                              ],
                            ),
                          // NOTE Adding the new feature
                          if (selectedClient != null &&
                              optionData ==
                                  AgentClientInfoOption.preferenceInfo &&
                              selectedClient!['jot_form_submitted_data'] != "")
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // SECTION Property Preference
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      width: 500,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.home,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Property Preference",
                                                style: ThemeController
                                                    .titleTextStyle(
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              PreferenceDetailsUnitWidget(
                                                title: "Bedroom",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['bedNumber']
                                                      .toString(),
                                                ),
                                              ),
                                              PreferenceDetailsUnitWidget(
                                                title: "Bathrooms",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['bathNumber']
                                                      .toString(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              PreferenceDetailsUnitWidget(
                                                title: "M2",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['M2Preference']
                                                      .toString(),
                                                ),
                                              ),
                                              PreferenceDetailsUnitWidget(
                                                title: "Location",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['locationPreference']
                                                      .toString(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          PreferenceDetailsUnitWidget(
                                            title: "House Regards",
                                            value: GlobalController
                                                .getPreferenceFormatter(
                                              selectedClient!['preference_data']
                                                      ['houseRegardsPreference']
                                                  .toString(),
                                            ),
                                            width: 400,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          PreferenceDetailsUnitWidget(
                                            title: "Neighbourhood",
                                            value: GlobalController
                                                .getPreferenceFormatter(
                                              selectedClient!['preference_data']
                                                      ['neighborPreference']
                                                  .toString(),
                                            ),
                                            width: 400,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          PreferenceDetailsUnitWidget(
                                            title: "Other preference",
                                            value: GlobalController
                                                .getPreferenceFormatter(
                                              selectedClient!['preference_data']
                                                      ['otherPreference']
                                                  .toString(),
                                            ),
                                            width: 400,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // !SECTION
                                    // NOTE Empty Space
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // SECTION Activity Preference
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      width: 500,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Status & Activity",
                                                style: ThemeController
                                                    .titleTextStyle(
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              PreferenceDetailsUnitWidget(
                                                title: "Viewing",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['viewingPreference']
                                                      .toString(),
                                                ),
                                              ),
                                              PreferenceDetailsUnitWidget(
                                                title: "Other agent",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['otherAgentsStatus']
                                                      .toString(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          PreferenceDetailsUnitWidget(
                                            title: "Next appointmen",
                                            value: GlobalController
                                                .formatAppointment(
                                              selectedClient!['preference_data']
                                                      ['appointmentInfo']
                                                  .toString(),
                                            ),
                                            width: 400,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // !SECTION
                                  ],
                                ),
                                // NOTE Empty Width Space
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    // SECTION Financial Preference
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      width: 500,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.money,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Financial Details",
                                                style: ThemeController
                                                    .titleTextStyle(
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              PreferenceDetailsUnitWidget(
                                                title: "Buying Preference",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['buyingPreference']
                                                      .toString(),
                                                ),
                                              ),
                                              PreferenceDetailsUnitWidget(
                                                title: "Value Spend",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          [
                                                          'valueSpendPreference']
                                                      .toString(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              PreferenceDetailsUnitWidget(
                                                title: "Tax Status",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['taxPreference']
                                                      .toString(),
                                                ),
                                              ),
                                              PreferenceDetailsUnitWidget(
                                                title: "Fiscal Status",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['fiscalStatus']
                                                      .toString(),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          PreferenceDetailsUnitWidget(
                                            title: "Bank Status",
                                            value: GlobalController
                                                .getPreferenceFormatter(
                                              selectedClient!['preference_data']
                                                      ['bankStatus']
                                                  .toString(),
                                            ),
                                            width: 400,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // !SECTION
                                    // NOTE Empty Space
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // SECTION Personal Preference
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      width: 500,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.person,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Contact & Personal",
                                                style: ThemeController
                                                    .titleTextStyle(
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          PreferenceDetailsUnitWidget(
                                            title: "Email",
                                            value: GlobalController
                                                .getPreferenceFormatter(
                                              selectedClient!['preference_data']
                                                      ['email']
                                                  .toString(),
                                            ),
                                            width: 400,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          PreferenceDetailsUnitWidget(
                                            title: "Phone number",
                                            value: GlobalController
                                                .getPreferenceFormatter(
                                              selectedClient!['preference_data']
                                                      ['phoneNumber']
                                                  .toString(),
                                            ),
                                            width: 400,
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              PreferenceDetailsUnitWidget(
                                                title: "Residence",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['residenceInfo']
                                                      .toString(),
                                                ),
                                              ),
                                              PreferenceDetailsUnitWidget(
                                                title: "Language",
                                                value: GlobalController
                                                    .getPreferenceFormatter(
                                                  selectedClient![
                                                              'preference_data']
                                                          ['languagePreference']
                                                      .toString(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // !SECTION
                                    // NOTE Empty Space
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    // SECTION Additional Info Preference
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      width: 500,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.paste,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Additional Info",
                                                style: ThemeController
                                                    .titleTextStyle(
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            GlobalController
                                                .getPreferenceFormatter(
                                              selectedClient!['preference_data']
                                                      ['additionalInfo']
                                                  .toString(),
                                            ),
                                            style:
                                                ThemeController.normalTextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // !SECTION
                                  ],
                                ),
                              ],
                            ),

                          if (selectedClient != null &&
                              optionData ==
                                  AgentClientInfoOption.preferenceInfo &&
                              selectedClient!['jot_form_submitted_data'] == "")
                            Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // NOTE Empty Space
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  // NOTE SectionLottie
                                  SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: Lottie.asset(
                                        'assets/lottie/empty_lottie.json'),
                                  ),
                                  // NOTE Subtitle Section
                                  Text(
                                    "Client hasn't submitted jotform !!!",
                                    style: ThemeController.normalTextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  // NOTE Button
                                  // NOTE Empty Space
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  OptionLabelSelectorWidget(
                                    isEnabled: true,
                                    onPress: () async {
                                      ManagerLogInScreenController
                                          .showLoaderDialog(context);
                                      await ApiController.sendJotFormRemainder(
                                        {
                                          "clientEmailAddress": selectedClient![
                                              'client_email_address'],
                                          "clientFullName":
                                              selectedClient!['client_name'],
                                        },
                                        onError: (errData) {
                                          ManagerLogInScreenController
                                              .showError(
                                            context,
                                            errData,
                                          );
                                        },
                                        onSuccess: (resData) {
                                          ManagerLogInScreenController
                                              .showSuccess(
                                            context,
                                            'Remainder has been sent',
                                          );
                                        },
                                      );
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        () {
                                          // html.window.location.reload();
                                          if (context.mounted) {
                                            context.push(
                                                '/manager-client-info-screen/${selectedClient!['client_id']}');
                                          }
                                        },
                                      );
                                    },
                                    optionLabel: 'Send reminder',
                                  ),

                                  // NOTE Empty Space
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          // NOTE Agent Info Section
                          if (selectedClient != null &&
                              optionData == AgentClientInfoOption.agentInfo)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Assigned Agents",
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                if (assignedAgents.isEmpty)
                                  Text(
                                    "There is no agent has been assigned to the client. Please do assign the agent by pressing the assign button.",
                                    style: ThemeController.smallTextStyle(),
                                  ),
                                if (assignedAgents.length > 0)
                                  Column(
                                    children: List.generate(
                                      assignedAgents.length,
                                      (index) => AgentInfoTile(
                                        agent: assignedAgents[index],
                                        onRemovePress: () async {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          // NOTE  Un Assign
                                          await ApiController.unAssignAgent(
                                            agentId: assignedAgents[index]
                                                ['agent_id'],
                                            clientId:
                                                selectedClient!['client_id'],
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(
                                                context,
                                                'Agent has been un assigned.',
                                              );
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                        },
                                      ),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Available Agents",
                                  style: ThemeController.normalTextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Column(
                                  children: List.generate(
                                    availableAgents.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                availableAgents[index]
                                                    ['agent_name'],
                                                style: ThemeController
                                                    .normalTextStyle(),
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          AddMoreButton(
                                            onButtonPress: () async {
                                              String agent_id =
                                                  availableAgents[index]
                                                      ['agent_id'];
                                              String client_id =
                                                  selectedClient!['client_id'];
                                              ManagerLogInScreenController
                                                  .showLoaderDialog(context);
                                              await ApiController.assignAgent(
                                                client_id,
                                                agent_id,
                                                onSuccess: (data) async {
                                                  ManagerLogInScreenController
                                                      .showSuccess(
                                                    context,
                                                    'The agent has been assigned successfully !!!',
                                                  );
                                                  await Future.delayed(
                                                    const Duration(seconds: 2),
                                                    () {
                                                      if (context.mounted) {
                                                        context.push(
                                                            '/manager-client-info-screen/${selectedClient!['client_id']}');
                                                      }
                                                    },
                                                  );
                                                },
                                                onError: (data) {},
                                              );
                                            },
                                            buttonLabel: 'Assign',
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          if (currentUserChecklist != null &&
                              optionData ==
                                  AgentClientInfoOption.clientChecklist)
                            Column(
                              children: List.generate(
                                currentUserChecklist!['checklist_data'].length,
                                (index) => Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CheckListUnitDataWidget(
                                      agentId: "MNG-BLR-20250625-0001",
                                      checklistId:
                                          currentUserChecklist!['checklist_id'],
                                      index: index,
                                      clientData: selectedClient,
                                      userData: currentUserChecklist![
                                          'checklist_data'][index],
                                      isEnabled: index != 0 &&
                                              currentUserChecklist![
                                                          'checklist_data'][0]
                                                      ['status'] ==
                                                  'Not-Started'
                                          ? false
                                          : true,
                                      isOn: currentUserChecklist![
                                                  'checklist_data'][index]
                                              ['status'] !=
                                          'Not-Started',
                                      onTogglePress: (data) async {
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
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                        if (index == 1) {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          await ApiController
                                              .onBoardingDocumentsUpdate(
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
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                        } else if (index == 2) {
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
                                                  selectedClient![
                                                      'client_email_address']
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
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                        } else if (index == 3) {
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
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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

                                          // showFirstCallDialog(
                                          //   context: context,
                                          //   title: 'Schedule call',
                                          //   messageInitial: '',
                                          //   meetingLinkInitial: '',
                                          //   checklist_id: currentUserChecklist![
                                          //       'checklist_id'],
                                          // );
                                        } else if (index == 4) {
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
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                        } else if (index == 5) {
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
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                        } else if (index == 6) {
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
                                                  // html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                        } else if (index == 7) {
                                          showViewingConfirmDialog(
                                              context: context,
                                              title:
                                                  'Update viewing confirmation message',
                                              initialValue: '',
                                              checklistId:
                                                  currentUserChecklist![
                                                      'checklist_id']);
                                        } else if (index == 8) {
                                          showPropertyBookingDialog(
                                            context: context,
                                            title:
                                                'Update viewing booking message',
                                            initialValue: '',
                                            checklistId: currentUserChecklist![
                                                'checklist_id'],
                                          );
                                        } else if (index == 9) {
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
                                                  html.window.location.reload();
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                        } else if (index == 10) {
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
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                        } else if (index == 11) {
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
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
                                                        '/manager-client-info-screen/${selectedClient!['client_id']}');
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
