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
            children: [
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
              UserPreferenceValuesDisplayWidget(
                labelName: 'Property Id',
                labelValue: widget.propertyInfoData["propertyId"],
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Property name',
                labelValue: widget.propertyInfoData["propertyName"],
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Client link',
                labelValue: widget.propertyInfoData["clientLink"],
                isLink: true,
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Property location',
                labelValue: widget.propertyInfoData["propertyLocationName"],
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Property Price',
                labelValue: widget.propertyInfoData["propertyPrice"],
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'listing Reference',
                labelValue: widget.propertyInfoData["listingRef"],
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Property M2',
                labelValue: widget.propertyInfoData["propertyM2"],
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Beds',
                labelValue: widget.propertyInfoData["bedsNumber"],
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Baths',
                labelValue: widget.propertyInfoData["bathsNumber"],
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Plot size',
                labelValue: widget.propertyInfoData["plotSize"],
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Distance from coast',
                labelValue: widget.propertyInfoData["distanceFromCoast"],
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Google map link',
                labelValue: widget.propertyInfoData["googleMapLink"],
                isLink: true,
              ),
              const SizedBox(
                height: 20,
              ),
              getToggleWidget(
                isOn: widget.propertyInfoData["pool"] == 'False' ? false : true,
                labelName: 'Pool',
                onToggle: (data) {},
                isEnabled: false,

                //
              ),
              const SizedBox(
                height: 20,
              ),
              getToggleWidget(
                labelName: 'Parking',
                onToggle: (data) {},
                isEnabled: false,
                isOn: widget.propertyInfoData["parking"] == 'False'
                    ? false
                    : true,
              ),
              const SizedBox(
                height: 10,
              ),
              UserPreferenceValuesDisplayWidget(
                labelName: 'Property Description',
                labelValue: widget.propertyInfoData["propertyDescription"],
              ),
              const SizedBox(
                height: 30,
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
