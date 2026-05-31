import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/option_label_selector_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/toggle_switch_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_values_display_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/drop_down_options.dart';
import 'package:algarve_house_hunters_system/global_widgets/extracted_property_grid_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;

enum PropertyInfoWidgetOption {
  propertyInfo,
  officeWork,
  visitingDetails,
}

class PropertyFeaturesInfoWidget extends StatefulWidget {
  final Map<String, dynamic> propertyInfoData;
  final String agentId;
  const PropertyFeaturesInfoWidget({
    super.key,
    required this.propertyInfoData,
    required this.agentId,
  });

  @override
  State<PropertyFeaturesInfoWidget> createState() =>
      _PropertyFeaturesInfoWidgetState();
}

class _PropertyFeaturesInfoWidgetState
    extends State<PropertyFeaturesInfoWidget> {
  Map<String, dynamic>? allClientsId;
  PropertyInfoWidgetOption option = PropertyInfoWidgetOption.propertyInfo;

  // NOTE State for the property meta data holding
  Map<String, dynamic> propertyMetaDataHolding = {
    "propertyId": "",
    "propertyName": "",
    "clientLink": "",
    "pool": "",
    "parking": "",
    "propertyLocationName": "",
    "propertyPrice": "",
    "listingRef": "",
    "propertyM2": "",
    "bedsNumber": "",
    "bathsNumber": "",
    "plotSize": "",
    "distanceFromCoast": "",
    "googleMapLink": "",
    "propertyDescription": "",
    "ourRef": "",
    "propertyRefLink": "",
    "isSold": "",
    "landType": "",
    "houseType": "",
    "floorNumber": "",
    "condominiumFees": "",
    "liftOrStairs": "",
    "distanceFromShops": "",
    "distanceTocafe": "",
    "singleLevelLiving": "",
    "annexOutbuilding": "",
    "mainWaterBoreHoles": "",
    "sewerage": "",
    "accessToProperty": "",
    "roadNoise": "",
    "neighbours": "",
    "aircon": "",
    "heating": "",
    "windowsNumber": "",
    "fullyLegal": "",
    "solar": "",
  };
  bool isEdit = false;

  // NOTE MEthod for setting edit status
  void setEditStatus() {
    if (propertyMetaDataHolding["propertyId"] !=
            widget.propertyInfoData["propertyId"] ||
        propertyMetaDataHolding["propertyName"] !=
            widget.propertyInfoData["propertyName"] ||
        propertyMetaDataHolding["clientLink"] !=
            widget.propertyInfoData["clientLink"] ||
        propertyMetaDataHolding["pool"] != widget.propertyInfoData["pool"] ||
        propertyMetaDataHolding["parking"] !=
            widget.propertyInfoData["parking"] ||
        propertyMetaDataHolding["propertyLocationName"] !=
            widget.propertyInfoData["propertyLocationName"] ||
        propertyMetaDataHolding["propertyPrice"] !=
            widget.propertyInfoData["propertyPrice"] ||
        propertyMetaDataHolding["listingRef"] !=
            widget.propertyInfoData["listingRef"] ||
        propertyMetaDataHolding["propertyM2"] !=
            widget.propertyInfoData["propertyM2"] ||
        propertyMetaDataHolding["bedsNumber"] !=
            widget.propertyInfoData["bedsNumber"] ||
        propertyMetaDataHolding["bathsNumber"] !=
            widget.propertyInfoData["bathsNumber"] ||
        propertyMetaDataHolding["plotSize"] !=
            widget.propertyInfoData["plotSize"] ||
        propertyMetaDataHolding["distanceFromCoast"] !=
            widget.propertyInfoData["distanceFromCoast"] ||
        propertyMetaDataHolding["googleMapLink"] !=
            widget.propertyInfoData["googleMapLink"] ||
        propertyMetaDataHolding["propertyDescription"] !=
            widget.propertyInfoData["propertyDescription"] ||
        propertyMetaDataHolding["ourRef"] !=
            widget.propertyInfoData["ourRef"] ||
        propertyMetaDataHolding["propertyRefLink"] !=
            widget.propertyInfoData["propertyRefLink"] ||
        propertyMetaDataHolding["isSold"] !=
            widget.propertyInfoData["isSold"] ||
        propertyMetaDataHolding["landType"] !=
            widget.propertyInfoData["landType"] ||
        propertyMetaDataHolding["houseType"] !=
            widget.propertyInfoData["houseType"] ||
        propertyMetaDataHolding["floorNumber"] !=
            widget.propertyInfoData["floorNumber"] ||
        propertyMetaDataHolding["condominiumFees"] !=
            widget.propertyInfoData["condominiumFees"] ||
        propertyMetaDataHolding["liftOrStairs"] !=
            widget.propertyInfoData["liftOrStairs"] ||
        propertyMetaDataHolding["distanceFromShops"] !=
            widget.propertyInfoData["distanceFromShops"] ||
        propertyMetaDataHolding["distanceTocafe"] !=
            widget.propertyInfoData["distanceTocafe"] ||
        propertyMetaDataHolding["singleLevelLiving"] !=
            widget.propertyInfoData["singleLevelLiving"] ||
        propertyMetaDataHolding["annexOutbuilding"] !=
            widget.propertyInfoData["annexOutbuilding"] ||
        propertyMetaDataHolding["mainWaterBoreHoles"] !=
            widget.propertyInfoData["mainWaterBoreHoles"] ||
        propertyMetaDataHolding["sewerage"] !=
            widget.propertyInfoData["sewerage"] ||
        propertyMetaDataHolding["accessToProperty"] !=
            widget.propertyInfoData["accessToProperty"] ||
        propertyMetaDataHolding["roadNoise"] !=
            widget.propertyInfoData["roadNoise"] ||
        propertyMetaDataHolding["neighbours"] !=
            widget.propertyInfoData["neighbours"] ||
        propertyMetaDataHolding["aircon"] !=
            widget.propertyInfoData["aircon"] ||
        propertyMetaDataHolding["heating"] !=
            widget.propertyInfoData["heating"] ||
        propertyMetaDataHolding["windowsNumber"] !=
            widget.propertyInfoData["windowsNumber"] ||
        propertyMetaDataHolding["fullyLegal"] !=
            widget.propertyInfoData["fullyLegal"] ||
        propertyMetaDataHolding["solar"] != widget.propertyInfoData["solar"]) {
      isEdit = true;
    } else {
      isEdit = false;
    }
    setState(() {});
  }

  // NOTE Method for setting the initial data value
  void setPropertyMetaData() {
    propertyMetaDataHolding["propertyId"] =
        widget.propertyInfoData["propertyId"];
    propertyMetaDataHolding["propertyName"] =
        widget.propertyInfoData["propertyName"];
    propertyMetaDataHolding["clientLink"] =
        widget.propertyInfoData["clientLink"];
    propertyMetaDataHolding["pool"] = widget.propertyInfoData["pool"];
    propertyMetaDataHolding["parking"] = widget.propertyInfoData["parking"];
    propertyMetaDataHolding["propertyLocationName"] =
        widget.propertyInfoData["propertyLocationName"];
    propertyMetaDataHolding["propertyPrice"] =
        widget.propertyInfoData["propertyPrice"];
    propertyMetaDataHolding["listingRef"] =
        widget.propertyInfoData["listingRef"];
    propertyMetaDataHolding["propertyM2"] =
        widget.propertyInfoData["propertyM2"];
    propertyMetaDataHolding["bedsNumber"] =
        widget.propertyInfoData["bedsNumber"];
    propertyMetaDataHolding["bathsNumber"] =
        widget.propertyInfoData["bathsNumber"];
    propertyMetaDataHolding["plotSize"] = widget.propertyInfoData["plotSize"];
    propertyMetaDataHolding["distanceFromCoast"] =
        widget.propertyInfoData["distanceFromCoast"];
    propertyMetaDataHolding["googleMapLink"] =
        widget.propertyInfoData["googleMapLink"];
    propertyMetaDataHolding["propertyDescription"] =
        widget.propertyInfoData["propertyDescription"];
    propertyMetaDataHolding["ourRef"] = widget.propertyInfoData["ourRef"];
    propertyMetaDataHolding["propertyRefLink"] =
        widget.propertyInfoData["propertyRefLink"];
    propertyMetaDataHolding["landType"] = widget.propertyInfoData["landType"];
    propertyMetaDataHolding["houseType"] = widget.propertyInfoData["houseType"];
    propertyMetaDataHolding["floorNumber"] =
        widget.propertyInfoData["floorNumber"];
    propertyMetaDataHolding["condominiumFees"] =
        widget.propertyInfoData["condominiumFees"];
    propertyMetaDataHolding["liftOrStairs"] =
        widget.propertyInfoData["liftOrStairs"];
    propertyMetaDataHolding["distanceFromShops"] =
        widget.propertyInfoData["distanceFromShops"];
    propertyMetaDataHolding["distanceTocafe"] =
        widget.propertyInfoData["distanceTocafe"];
    propertyMetaDataHolding["singleLevelLiving"] =
        widget.propertyInfoData["singleLevelLiving"];
    propertyMetaDataHolding["annexOutbuilding"] =
        widget.propertyInfoData["annexOutbuilding"];
    propertyMetaDataHolding["mainWaterBoreHoles"] =
        widget.propertyInfoData["mainWaterBoreHoles"];
    propertyMetaDataHolding["sewerage"] = widget.propertyInfoData["sewerage"];
    propertyMetaDataHolding["accessToProperty"] =
        widget.propertyInfoData["accessToProperty"];
    propertyMetaDataHolding["roadNoise"] = widget.propertyInfoData["roadNoise"];
    propertyMetaDataHolding["neighbours"] =
        widget.propertyInfoData["neighbours"];
    propertyMetaDataHolding["aircon"] = widget.propertyInfoData["aircon"];
    propertyMetaDataHolding["heating"] = widget.propertyInfoData["heating"];
    propertyMetaDataHolding["windowsNumber"] =
        widget.propertyInfoData["windowsNumber"];
    propertyMetaDataHolding["fullyLegal"] =
        widget.propertyInfoData["fullyLegal"];
    propertyMetaDataHolding["fullyLegal"] =
        widget.propertyInfoData["fullyLegal"];
    propertyMetaDataHolding["solar"] = widget.propertyInfoData["solar"];
  }

  String daysToGo(String timestamp) {
    try {
      // Parse the timestamp string
      final date = DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(timestamp);

      // Calculate difference in days
      final now = DateTime.now();
      final difference = date.difference(now).inDays;

      if (difference > 0) {
        return "$difference days to go";
      } else if (difference == 0) {
        return "Today";
      } else {
        return "${difference.abs()} days ago";
      }
    } catch (e) {
      return "Invalid date";
    }
  }

  Widget getToggleWidget({
    required String labelName,
    required Function(bool) onToggle,
    required bool isEnabled,
    bool isOn = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 440,
          child: Text(
            labelName,
            style: ThemeController.smallTextStyle(
              fontWeight: FontWeight.w500,
              size: 16,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ToggleSwitchWidget(
          onToggle: onToggle,
          onLabel: "Yes",
          offLabel: "No",
          isEnabled: isEnabled,
          isOn: isOn,
        ),
      ],
    );
  }

  void changeOption(PropertyInfoWidgetOption data) {
    option = data;
    setState(() {});
  }

  // SECTION Appointment Dialog Section
  Future<void> showAppointmentBookingDialog(BuildContext context) async {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    String name = '';
    String duration = '';
    String comments = '';

    String? dateErroText;
    String? durationErrorText;
    String? nameErrorText;

    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                "Book Visit",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name field
                    // if (allClientsId != null)
                    //   HighlightDropdown(
                    //     apiResponse: allClientsId!,
                    //     onOptionChanged: (data) {
                    //       print(
                    //           "Following client ID has been selected: ${data}");
                    //     },
                    //   ),

                    CustomTextFormFiled(
                      initialValue: name,
                      labelName: 'Name',
                      placeholderText: '',
                      isMandatory: false,
                      onChanged: (data) {
                        nameErrorText = null;
                        setState(() {});
                        if (data != null || data!.isNotEmpty) {
                          name = data;
                        } else {
                          setState(() {
                            nameErrorText = 'Notes cannot be empty !!!';
                          });
                        }
                      },
                      errorText: nameErrorText,
                    ),
                    const SizedBox(height: 12),

                    // Date picker
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedDate != null
                                    ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                                    : "Select Date",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_today,
                                  color: Colors.black),
                              onPressed: () async {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    //Time picker
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedTime != null
                                ? selectedTime!.format(context)
                                : "Select Time",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.access_time,
                              color: Colors.black),
                          onPressed: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                selectedTime = pickedTime;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Duration field
                    CustomTextFormFiled(
                      initialValue: duration,
                      labelName: 'Duration',
                      placeholderText: '',
                      isMandatory: false,
                      onChanged: (data) {
                        nameErrorText = null;
                        setState(() {});
                        if (data != null || data!.isNotEmpty) {
                          duration = data;
                        } else {
                          setState(() {
                            durationErrorText = 'Duration cannot be empty !!!';
                          });
                        }
                      },
                      errorText: nameErrorText,
                    ),
                    const SizedBox(height: 12),

                    // Duration field
                    CustomTextFormFiled(
                      initialValue: comments,
                      labelName: 'Comments',
                      placeholderText: '',
                      isMandatory: false,
                      onChanged: (data) {
                        nameErrorText = null;
                        setState(() {});
                        if (data != null || data!.isNotEmpty) {
                          comments = data;
                        } else {
                          setState(() {
                            durationErrorText = 'Comments cannot be empty !!!';
                          });
                        }
                      },
                      errorText: nameErrorText,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: () async {
                    if (name != '' &&
                        selectedDate != null &&
                        selectedTime != null &&
                        duration != '' &&
                        comments != '') {
                      DateTime appointmentDate = DateTime(
                        selectedDate!.year,
                        selectedDate!.month,
                        selectedDate!.day,
                        selectedTime!.hour,
                        selectedTime!.minute,
                      );
                      ManagerLogInScreenController.showLoaderDialog(context);
                      Map<String, dynamic> payload = {
                        "agent_id": widget.agentId,
                        "propertyId": widget.propertyInfoData["propertyId"],
                        "customer_id": name,
                        "comments": comments,
                        "appointment_date": appointmentDate.toIso8601String(),
                        "appointment_duration": duration,
                        "google_meeting_link": "",
                      };
                      // print('Payload: ${payload}');
                      await ApiController.addViewingInformation(
                        payload,
                        onSuccess: (resData) async {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Appointment has been added');
                          await Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              if (!mounted) {
                                return;
                              }
                              html.window.location.reload();
                            },
                          );
                        },
                        onError: (errData) {
                          ManagerLogInScreenController.showError(
                              context, jsonDecode(errData));
                        },
                      );
                    } else {
                      ManagerLogInScreenController.showError(
                          context, 'Fill all the fields');
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
                        errorText = "This field cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);
                      Map<String, dynamic> officeNotesData = {
                        "notesValue": valueHolder,
                        "createdBy": widget.agentId,
                        "propertyId": widget.propertyInfoData["propertyId"]
                      };
                      await ApiController.addOfficeNotes(
                        officeNotesData,
                        onSuccess: (data) async {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Office notes has been added');
                          await Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              if (!mounted) {
                                return;
                              }
                              html.window.location.reload();
                            },
                          );
                        },
                        onError: (errorData) {
                          var response = jsonDecode(errorData);

                          ManagerLogInScreenController.showError(
                              context, response.toString());
                        },
                      );
                      // Navigator.of(context).pop();
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

  // SECTION Contact name addition
  Future<void> showContactNameAddition(
    BuildContext context,
    String title,
    String nameValue,
    String emailValue,
  ) async {
    String? nameErrorText;
    String? emailErrorText;
    String nameValueHolder = nameValue;
    String emailValueHolder = emailValue;

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
                    initialValue: nameValueHolder,
                    labelName: 'Name',
                    placeholderText: '',
                    isMandatory: false,
                    onChanged: (data) {
                      nameErrorText = null;
                      setState(() {});
                      if (data != null || data!.isNotEmpty) {
                        nameValueHolder = data;
                      } else {
                        setState(() {
                          nameErrorText = 'Name cannot be empty !!!';
                        });
                      }
                    },
                    errorText: nameErrorText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextFormFiled(
                    initialValue: emailValueHolder,
                    labelName: 'Email',
                    placeholderText: '',
                    isMandatory: false,
                    onChanged: (data) {
                      emailErrorText = null;
                      setState(() {});
                      if (data != null || data!.isNotEmpty) {
                        emailValueHolder = data;
                      } else {
                        setState(() {
                          emailErrorText = 'Contact email cannot be empty !!!';
                        });
                      }
                    },
                    errorText: emailErrorText,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () async {
                    if (nameValueHolder == '' || nameValueHolder.isEmpty) {
                      setState(() {
                        nameErrorText = "Contact name cannot be empty";
                      });
                    } else if (emailValueHolder == '' ||
                        emailValueHolder.isEmpty) {
                      setState(() {
                        emailErrorText = "Contact email cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);
                      Map<String, dynamic> officeNotesData = {
                        "contactName": nameValueHolder,
                        "contactValue": emailValueHolder,
                        "addedBy": widget.agentId,
                        "propertyId": widget.propertyInfoData["propertyId"],
                      };
                      await ApiController.addPropertyContact(
                        officeNotesData,
                        onSuccess: (data) async {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Property contact has been added');
                          await Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              if (!mounted) {
                                return;
                              }
                              html.window.location.reload();
                            },
                          );
                        },
                        onError: (errorData) {
                          var response = jsonDecode(errorData);

                          ManagerLogInScreenController.showError(
                              context, response.toString());
                        },
                      );
                      Navigator.of(context).pop();
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

  Future<void> showRegistrationNotes(
    BuildContext context,
    String title,
    String initialValue,
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
                        errorText = "This field cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);
                      Map<String, dynamic> officeNotesData = {
                        "notesValue": valueHolder,
                        "createdBy": widget.agentId,
                        "propertyId": widget.propertyInfoData["propertyId"]
                      };
                      await ApiController.addRegistrationNotes(
                        officeNotesData,
                        onSuccess: (data) async {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Registration notes has been added');
                          await Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              if (!mounted) {
                                return;
                              }
                              html.window.location.reload();
                            },
                          );
                        },
                        onError: (errorData) {
                          var response = jsonDecode(errorData);

                          ManagerLogInScreenController.showError(
                              context, response.toString());
                        },
                      );
                      Navigator.of(context).pop();
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

  Future<void> showClientNotes(
    BuildContext context,
    String title,
    String initialValue,
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
                        errorText = "Notes cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);
                      Map<String, dynamic> officeNotesData = {
                        "notesValue": valueHolder,
                        "createdBy": widget.agentId,
                        "propertyId": widget.propertyInfoData["propertyId"]
                      };
                      await ApiController.addClientNotes(
                        officeNotesData,
                        onSuccess: (data) async {
                          ManagerLogInScreenController.showSuccess(
                              context, 'Client notes has been added');
                          await Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              if (!mounted) {
                                return;
                              }
                              html.window.location.reload();
                            },
                          );
                        },
                        onError: (errorData) {
                          var response = jsonDecode(errorData);

                          ManagerLogInScreenController.showError(
                              context, response.toString());
                        },
                      );
                      Navigator.of(context).pop();
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

  Future<void> showAgentNotes(
    BuildContext context,
    String title,
    String initialValue,
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
                        errorText = "Notes cannot be empty";
                      });
                    } else {
                      ManagerLogInScreenController.showLoaderDialog(context);
                      Map<String, dynamic> officeNotesData = {
                        "notesValue": valueHolder,
                        "createdBy": widget.agentId,
                        "propertyId": widget.propertyInfoData["propertyId"]
                      };
                      await ApiController.addAgentNotes(
                        officeNotesData,
                        onSuccess: (data) async {
                          ManagerLogInScreenController.showSuccess(
                            context,
                            'Agent notes has been added',
                          );
                          await Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              if (!mounted) {
                                return;
                              }
                              html.window.location.reload();
                            },
                          );
                        },
                        onError: (errorData) {
                          var response = jsonDecode(errorData);

                          ManagerLogInScreenController.showError(
                              context, response.toString());
                          Navigator.of(context).pop();
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

  void getAllClientsIds() async {
    await ApiController.getAllClientsId(
      onSuccess: (data) {
        final response = jsonDecode(data);
        print('clients data: ${response}');

        allClientsId = response['clientIds'];

        setState(() {});
      },
      onError: (errorData) {},
    );
  }

  @override
  void initState() {
    super.initState();
    setPropertyMetaData();
    // getAllClientsIds();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            OptionLabelSelectorWidget(
              isEnabled: option == PropertyInfoWidgetOption.propertyInfo,
              onPress: () {
                changeOption(PropertyInfoWidgetOption.propertyInfo);
              },
              optionLabel: 'Property info',
            ),
            const SizedBox(
              width: 30,
            ),
            OptionLabelSelectorWidget(
              isEnabled: option == PropertyInfoWidgetOption.officeWork,
              onPress: () {
                changeOption(PropertyInfoWidgetOption.officeWork);
                print(option);
              },
              optionLabel: 'Office Works',
            ),
            const SizedBox(
              width: 30,
            ),
            OptionLabelSelectorWidget(
              isEnabled: option == PropertyInfoWidgetOption.visitingDetails,
              onPress: () {
                changeOption(PropertyInfoWidgetOption.visitingDetails);
                print(option);
              },
              optionLabel: 'Visiting details',
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        if (option == PropertyInfoWidgetOption.propertyInfo)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION Image Expanded Section
              Column(
                children: [
                  ExpansionTile(
                    title: Text(
                      'Property images ${(widget.propertyInfoData["propertyImages"] as List).cast<String>().length}',
                      style: ThemeController.normalTextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxHeight: 400),
                        child: SingleChildScrollView(
                          child: InkWell(
                            onTap: () {
                              GlobalWidgets.showImageViewerDialog(
                                context,
                                imageUrls:
                                    (widget.propertyInfoData["propertyImages"]
                                            as List)
                                        .cast<String>(),
                                title: "Property glance",
                              );
                            },
                            child: PropertyImageGrid(
                              imageUrls:
                                  (widget.propertyInfoData["propertyImages"]
                                          as List)
                                      .cast<String>(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
              //!SECTION
              // SECTION Text field sections
              // NOTE Section Title
              Text(
                "Property Meta Data",
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                  size: 18,
                ),
              ),
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),

              //SECTION Row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Property ID
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      readOnly: true,
                      labelName: "Property ID",
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["propertyId"],
                      onChanged: (data) {},
                      onPaste: (data) {},
                    ),
                  ),
                  // NOTE Property Name
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: "Property Name",
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["propertyName"],
                      onChanged: (data) {
                        propertyMetaDataHolding["propertyName"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["propertyName"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Client Link
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: "Client link",
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["clientLink"],
                      onChanged: (data) {
                        propertyMetaDataHolding["clientLink"] = data;

                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["clientLink"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              //!SECTION
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),
              //SECTION Row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Property Location
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: "Property location",
                      placeholderText: "",
                      isMandatory: false,
                      initialValue:
                          widget.propertyInfoData["propertyLocationName"],
                      onChanged: (data) {
                        propertyMetaDataHolding["propertyLocationName"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["propertyLocationName"] = data;

                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Property Price
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Property Price',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["propertyPrice"],
                      onChanged: (data) {
                        propertyMetaDataHolding["propertyPrice"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["propertyPrice"] = data;

                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Property Listing Ref
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Listing Reference',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["listingRef"],
                      onChanged: (data) {
                        propertyMetaDataHolding["listingRef"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["listingRef"] = data;
                        if (propertyMetaDataHolding["listingRef"] !=
                            widget.propertyInfoData["listingRef"]) {
                          isEdit = true;
                        } else {
                          isEdit = false;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              //!SECTION
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),
              //SECTION Row 3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Property M2
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Property M2',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["propertyM2"],
                      onChanged: (data) {
                        propertyMetaDataHolding["propertyM2"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["propertyM2"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Beds
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Beds',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["bedsNumber"],
                      onChanged: (data) {
                        propertyMetaDataHolding["bedsNumber"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["bedsNumber"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Baths
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Baths',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["bathsNumber"],
                      onChanged: (data) {
                        propertyMetaDataHolding["bathsNumber"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["bathsNumber"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              //!SECTION
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),
              //SECTION Row 4
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Plot Size
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Plot size',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["plotSize"],
                      onChanged: (data) {
                        propertyMetaDataHolding["plotSize"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["plotSize"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Distance From coats
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Distance from coast',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue:
                          widget.propertyInfoData["distanceFromCoast"],
                      onChanged: (data) {
                        propertyMetaDataHolding["distanceFromCoast"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["distanceFromCoast"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Baths
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Google map link',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["googleMapLink"],
                      onChanged: (data) {
                        propertyMetaDataHolding["googleMapLink"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["googleMapLink"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              //!SECTION
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),
              //SECTION Row 5
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Plot Size
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Property Description',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue:
                          widget.propertyInfoData["propertyDescription"],
                      onChanged: (data) {
                        propertyMetaDataHolding["propertyDescription"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["propertyDescription"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE land Type
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Land Type',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["landType"],
                      onChanged: (data) {
                        propertyMetaDataHolding["landType"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["landType"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE House Type
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'House Type',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["houseType"],
                      onChanged: (data) {
                        propertyMetaDataHolding["houseType"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["houseType"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),

              //SECTION Row 6
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Condominium Fees
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Condominium Fees',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["condominiumFees"],
                      onChanged: (data) {
                        propertyMetaDataHolding["condominiumFees"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["condominiumFees"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Lift Details
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Lift or Stairs',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["liftOrStairs"],
                      onChanged: (data) {
                        propertyMetaDataHolding["liftOrStairs"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["liftOrStairs"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Distance From Shops
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Distance From Shops',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue:
                          widget.propertyInfoData["distanceFromShops"],
                      onChanged: (data) {
                        propertyMetaDataHolding["distanceFromShops"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["distanceFromShops"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              //!SECTION
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),
              //SECTION Row 7
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Distance To Cafe
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Distance To Cafe',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["distanceTocafe"],
                      onChanged: (data) {
                        propertyMetaDataHolding["distanceTocafe"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["distanceTocafe"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Single Level Living
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Single Level Living',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue:
                          widget.propertyInfoData["singleLevelLiving"],
                      onChanged: (data) {
                        propertyMetaDataHolding["singleLevelLiving"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["singleLevelLiving"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Annex Out Building
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Annex Out Building',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["annexOutbuilding"],
                      onChanged: (data) {
                        propertyMetaDataHolding["annexOutbuilding"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["annexOutbuilding"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              //!SECTION
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),
              //SECTION Row 8
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Main Water Bore Holes
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Main Water Bore Holes',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue:
                          widget.propertyInfoData["mainWaterBoreHoles"],
                      onChanged: (data) {
                        propertyMetaDataHolding["mainWaterBoreHoles"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["mainWaterBoreHoles"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Sewerage
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Sewerage',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["sewerage"],
                      onChanged: (data) {
                        propertyMetaDataHolding["sewerage"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["sewerage"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Access To Property
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Access To Property',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["accessToProperty"],
                      onChanged: (data) {
                        propertyMetaDataHolding["accessToProperty"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["accessToProperty"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              //!SECTION
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),
              //SECTION Row 9
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Road Noise
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Road Noise',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["roadNoise"],
                      onChanged: (data) {
                        propertyMetaDataHolding["roadNoise"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["roadNoise"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Neighbours
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Neighbours',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["neighbours"],
                      onChanged: (data) {
                        propertyMetaDataHolding["neighbours"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["neighbours"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Aircon
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Aircon',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["aircon"],
                      onChanged: (data) {
                        propertyMetaDataHolding["aircon"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["aircon"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              //!SECTION
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),
              //SECTION Row 10
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Heating
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Heating',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["heating"],
                      onChanged: (data) {
                        propertyMetaDataHolding["heating"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["heating"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE Windows Number
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Windows Number',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["windowsNumber"],
                      onChanged: (data) {
                        propertyMetaDataHolding["windowsNumber"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["windowsNumber"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                  // NOTE fullyLegal
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Fully Legal',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["fullyLegal"],
                      onChanged: (data) {
                        propertyMetaDataHolding["fullyLegal"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["fullyLegal"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              //!SECTION
              // NOTE Empty Space
              const SizedBox(
                height: 10,
              ),
              //SECTION Row 11
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // NOTE Solar
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: CustomTextFormFiled(
                      labelName: 'Solar',
                      placeholderText: "",
                      isMandatory: false,
                      initialValue: widget.propertyInfoData["solar"],
                      onChanged: (data) {
                        propertyMetaDataHolding["solar"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                      onPaste: (data) {
                        propertyMetaDataHolding["solar"] = data;
                        setEditStatus();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              //!SECTION
              // NOTE Empty Space
              const SizedBox(
                height: 30,
              ),
              // SECTION Row Last
              Row(
                children: [
                  getToggleWidget(
                    isOn:
                        widget.propertyInfoData["pool"] == 'No' ? false : true,
                    labelName: 'Pool',
                    onToggle: (data) {
                      propertyMetaDataHolding["pool"] = data ? 'Yes' : 'No';
                      setEditStatus();
                      setState(() {});
                    },
                    isEnabled: true,

                    //
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  getToggleWidget(
                    labelName: 'Parking',
                    onToggle: (data) {
                      propertyMetaDataHolding["parking"] = data ? 'Yes' : 'No';
                      setEditStatus();
                      setState(() {});
                    },
                    isEnabled: true,
                    isOn: widget.propertyInfoData["parking"] == 'No'
                        ? false
                        : true,
                  ),
                ],
              ),
              //!SECTION
              // !SECTION

              const SizedBox(
                height: 30,
              ),

              if (isEdit)
                SizedBox(
                  width: 200,
                  child: SubmitButton(
                    onButtonPress: () async {
                      ManagerLogInScreenController.showLoaderDialog(context);
                      await ApiController.propertyInfoEdit(
                        propertyMetaDataHolding,
                        onError: (errData) {
                          ManagerLogInScreenController.showError(
                            context,
                            jsonDecode(errData),
                          );
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              if (!mounted) {
                                return;
                              }
                              html.window.location.reload();
                            },
                          );
                        },
                        onSuccess: (resData) {
                          ManagerLogInScreenController.showSuccess(
                            context,
                            "Property info has been edited",
                          );
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              if (!mounted) {
                                return;
                              }
                              html.window.location.reload();
                            },
                          );
                        },
                      );
                    },
                    buttonLabel: "Edit Details",
                  ),
                ),
            ],
          ),

        if (option == PropertyInfoWidgetOption.officeWork)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Office Notes",
                    style: ThemeController.smallTextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showBlackDialog(
                        context,
                        "Add office notes",
                        '',
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      size: 24,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                  children: widget.propertyInfoData["officeNotes"].length > 0
                      ? List.generate(
                          widget.propertyInfoData["officeNotes"].length,
                          (index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: UserPreferenceValuesDisplayWidget(
                              labelName:
                                  '${widget.propertyInfoData["officeNotes"][index]['createdBy']}',
                              labelValue:
                                  '${widget.propertyInfoData["officeNotes"][index]['notesValue']}',
                              labelSize: 14,
                            ),
                          );
                        })
                      : [
                          Column(
                            children: [
                              Text(
                                "There is no office notes please do add by pressing the + icon",
                                style: ThemeController.smallTextStyle(),
                              )
                            ],
                          ),
                        ]),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Text(
                    "Contact",
                    style: ThemeController.smallTextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showContactNameAddition(
                        context,
                        "Add contact",
                        '',
                        '',
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      size: 24,
                    ),
                  )
                ],
              ),
              Column(
                children: widget.propertyInfoData["contact"].length > 0
                    ? List.generate(widget.propertyInfoData["contact"].length,
                        (index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: UserPreferenceValuesDisplayWidget(
                            labelName:
                                '${widget.propertyInfoData["contact"][index]['contactName']}',
                            labelValue:
                                '${widget.propertyInfoData["contact"][index]['contactValue']}',
                            labelSize: 14,
                            isLink: true,
                          ),
                        );
                      })
                    : [
                        Text(
                          "There is no contacts found please do add by pressing the + icon",
                          style: ThemeController.smallTextStyle(),
                        )
                      ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  Text(
                    "Registration notes",
                    style: ThemeController.smallTextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showRegistrationNotes(
                        context,
                        "Add registration notes",
                        '',
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      size: 24,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children:
                    widget.propertyInfoData["registrationNotes"].length > 0
                        ? List.generate(
                            widget.propertyInfoData["registrationNotes"].length,
                            (index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: UserPreferenceValuesDisplayWidget(
                                labelName:
                                    '${widget.propertyInfoData["registrationNotes"][index]['createdBy']}',
                                labelValue:
                                    '${widget.propertyInfoData["registrationNotes"][index]['notesValue']}',
                                labelSize: 14,
                                isLink: true,
                              ),
                            );
                          })
                        : [
                            Text(
                              "There is no registration notes found please do add by pressing the + icon",
                              style: ThemeController.smallTextStyle(),
                            )
                          ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text(
                    "Client notes",
                    style: ThemeController.smallTextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showClientNotes(
                        context,
                        "Add client notes",
                        '',
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      size: 24,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: widget.propertyInfoData["clientNotes"].length > 0
                    ? List.generate(
                        widget.propertyInfoData["clientNotes"].length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: UserPreferenceValuesDisplayWidget(
                            labelName:
                                '${widget.propertyInfoData["clientNotes"][index]['createdBy']}',
                            labelValue:
                                '${widget.propertyInfoData["clientNotes"][index]['notesValue']}',
                            labelSize: 14,
                            isLink: true,
                          ),
                        );
                      })
                    : [
                        Text(
                          "There is no client notes found please do add by pressing the + icon",
                          style: ThemeController.smallTextStyle(),
                        )
                      ],
              ),
              Row(
                children: [
                  Text(
                    "Agent notes",
                    style: ThemeController.smallTextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showAgentNotes(
                        context,
                        "Add agent notes",
                        '',
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      size: 24,
                    ),
                  )
                ],
              ),
              Column(
                children: widget.propertyInfoData["agentNotes"].length > 0
                    ? List.generate(
                        widget.propertyInfoData["agentNotes"].length,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: UserPreferenceValuesDisplayWidget(
                              labelName:
                                  '${widget.propertyInfoData["agentNotes"][index]['createdBy']}',
                              labelValue:
                                  '${widget.propertyInfoData["agentNotes"][index]['notesValue']}',
                              labelSize: 14,
                              isLink: true,
                            ),
                          );
                        },
                      )
                    : [
                        Text(
                          "There is no client notes found please do add by pressing the + icon",
                          style: ThemeController.smallTextStyle(),
                        )
                      ],
              ),
            ],
          ),
        if (option == PropertyInfoWidgetOption.visitingDetails)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OptionLabelSelectorWidget(
                isEnabled: true,
                onPress: () {
                  showAppointmentBookingDialog(context);
                },
                optionLabel: 'Create a visit',
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: List.generate(
                  widget.propertyInfoData["visitingDetails"].length,
                  (index) {
                    return ExpansionTile(
                        title: Text(
                          '${widget.propertyInfoData["visitingDetails"][index]['customer_id']}',
                          style: ThemeController.normalTextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent ID:',
                                  labelValue:
                                      '${widget.propertyInfoData["visitingDetails"][index]['agent_id']}',
                                  labelSize: 14,
                                  isLink: true,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: UserPreferenceValuesDisplayWidget(
                                  labelName: 'Customer ID',
                                  labelValue:
                                      '${widget.propertyInfoData["visitingDetails"][index]['customer_id']}',
                                  labelSize: 14,
                                  isLink: true,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: UserPreferenceValuesDisplayWidget(
                                  labelName: 'Comments',
                                  labelValue:
                                      '${widget.propertyInfoData["visitingDetails"][index]['comments']}',
                                  labelSize: 14,
                                  isLink: true,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: UserPreferenceValuesDisplayWidget(
                                  labelName: 'Appointment date',
                                  labelValue: AgentDashboardScreenController
                                      .formatIsoToCustom(
                                    widget.propertyInfoData["visitingDetails"]
                                        [index]['appointment_date'],
                                  ),
                                  labelSize: 14,
                                  isLink: true,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: UserPreferenceValuesDisplayWidget(
                                  labelName: 'Appointment duration',
                                  labelValue:
                                      '${widget.propertyInfoData["visitingDetails"][index]['appointment_duration']}',
                                  labelSize: 14,
                                  isLink: true,
                                ),
                              ),
                            ],
                          ),
                        ]);
                  },
                ),
              ),
            ],
          )
        // OfficeNotesDisplay(
        //   officeNotes: getOfficeNotes(widget.propertyInfoData["officeNotes"]),
        // ),
        // UserPreferenceValuesDisplayWidget(
        //   labelName: 'Office notes',
        //   labelValue: (widget.propertyInfoData["officeNotes"]),
        // ),
        // UserPreferenceValuesDisplayWidget(
        //   labelName: 'Contact',
        //   labelValue: widget.propertyInfoData["contact"],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // UserPreferenceValuesDisplayWidget(
        //   labelName: 'Registration notes',
        //   labelValue: widget.propertyInfoData["registrationNotes"],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // UserPreferenceValuesDisplayWidget(
        //   labelName: 'Viewing Information',
        //   labelValue: widget.propertyInfoData["viewingInformation"],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // UserPreferenceValuesDisplayWidget(
        //   labelName: 'Our Reference',
        //   labelValue: widget.propertyInfoData["ourRef"],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // UserPreferenceValuesDisplayWidget(
        //   labelName: 'Our notes',
        //   labelValue: widget.propertyInfoData["ourNotes"],
        // ),
        // const SizedBox(
        //   height: 10,
        // ),
        // UserPreferenceValuesDisplayWidget(
        //   labelName: 'Contact Email',
        //   labelValue: widget.propertyInfoData["contactEmail"],
        // ),
      ],
    );
  }
}
