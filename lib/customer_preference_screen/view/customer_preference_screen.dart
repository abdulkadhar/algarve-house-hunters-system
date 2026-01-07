import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/customer_preference_screen/widgets/selector_grid_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/meeting_time_picker.dart';
import 'package:algarve_house_hunters_system/global_widgets/signature_pad.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomerPreferenceScreen extends StatefulWidget {
  final String customerId;
  const CustomerPreferenceScreen({
    super.key,
    required this.customerId,
  });

  @override
  State<CustomerPreferenceScreen> createState() =>
      _CustomerPreferenceScreenState();
}

class _CustomerPreferenceScreenState extends State<CustomerPreferenceScreen> {
  // SECTION Handling the state for the text form field
  String firstName = '';
  String lastName = '';
  String phoneNumber = '';
  String numberOfBedrooms = '';
  String bathroomNumber = '';
  String amountPlaned = '';
  String viewingProceedings = '';
  String additionalInformation = '';
  String emailAddress = '';
  String meetingTime = '';
  String password = '';

  //!SECTION
  // NOTE Finding Options
  List<String> findingOption = [
    "Apartment",
    "House",
    "Villa",
    "Farm",
    "Ruin",
    "Hotel",
    "Commercial Property",
    "Land",
    "Other",
  ];
  List<String> findingOptionHolder = [];

  // NOTE Other Requirements
  List<String> otherRequirementsOption = [
    "Pool",
    "Or space to build a pool",
    "Garage",
    "Walking/diving to beach",
    "Close to amenities",
    "Garden",
    "Land",
    "Other",
  ];
  List<String> otherRequirementsOptionHolder = [];

  // NOTE existence Requirements
  List<String> existenceRequirementsOption = [
    "A new build",
    "Relatively new",
    "Older is fine but habitable",
    "I don't mind having to make a few changes",
    "Full renovation is ok",
    "Other",
  ];
  List<String> existenceRequirementsOptionHolder = [];
  // NOTE existence Requirements
  List<String> locationRequirementsOption = [
    "East Algarve",
    "West Algarve",
    "Central Algarve",
    "All",
    "Unsure",
    "I have specific area(s)",
    "Other",
  ];
  List<String> locationRequirementsOptionHolder = [];
  // NOTE buying Requirements
  List<String> buyingRequirementsOption = [
    "Immediately",
    "As soon as I find the right place",
    "In the future",
    "I'm not, I'm just curious",
    "Other",
  ];
  List<String> buyingRequirementsOptionHolder = [];
  // NOTE Tax requirements
  List<String> taxRequirementsOption = [
    'Yes includes all taxes (this is the total value I want to spend)',
    "No, taxes will be on top",
    "I'm not sure what taxes are",
    "Other",
  ];
  List<String> taxRequirementsOptionHolder = [];
  // NOTE portugal requirements
  List<String> portugalRequirementsOption = [
    'Yes I live here',
    "Yes I am visiting now",
    "No but I plan to be...",
  ];
  List<String> portugalRequirementsOptionHolder = [];
  // NOTE language requirements
  List<String> languageRequirementsOption = [
    'Portuguese',
    "English",
    "Spanish",
    "German",
    "French",
    "Other",
  ];
  List<String> languageRequirementsOptionHolder = [];

  // NOTE agent status requirements
  List<String> agentRequirementsOption = [
    'Yes, I\'m working with other agents',
    "I\'m not sure but I have made other enquiries",
    "No, I have not enquired or searched before",
  ];
  List<String> agentRequirementsOptionHolder = [];

  // NOTE fiscal status requirements
  List<String> fiscalRequirementsOption = [
    'Yes',
    "No",
    "What is this ?",
  ];
  List<String> fiscalRequirementsOptionHolder = [];

  // NOTE bank status requirements
  List<String> bankRequirementsOption = [
    'Yes',
    "No",
    "No why I need to ?",
  ];
  List<String> bankRequirementsOptionHolder = [];

  bool isFormSubmitted = false;

  Widget getLabelText({required String labelName, required String value}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$labelName:',
          style: ThemeController.normalTextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          value,
          style: ThemeController.normalTextStyle(
            fontWeight: FontWeight.w400,
            size: 14,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.pageBackgroundColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
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
                        'Share your preference',
                        style: ThemeController.titleTextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (!isFormSubmitted)
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: CustomTextFormFiled(
                          labelName: 'First name',
                          placeholderText: '',
                          onChanged: (nameData) {
                            if (nameData != null) {
                              firstName = nameData;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: CustomTextFormFiled(
                          labelName: 'Last name',
                          placeholderText: '',
                          onChanged: (nameData) {
                            if (nameData != null) {
                              lastName = nameData;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: CustomTextFormFiled(
                          labelName: 'Phone number',
                          placeholderText: '',
                          onChanged: (nameData) {
                            if (nameData != null) {
                              phoneNumber = nameData;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: CustomTextFormFiled(
                          labelName: 'Password for portal',
                          placeholderText: '',
                          onChanged: (nameData) {
                            if (nameData != null) {
                              password = nameData;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'What do you want us to find...',
                        style: ThemeController.smallTextStyle(
                          color: Colors.black,
                          size: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.29,
                        optionsList: findingOption,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          findingOptionHolder = [];
                          // NOTE adding the newly selected data
                          findingOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: CustomTextFormFiled(
                          isMandatory: false,
                          labelName:
                              'How many bedrooms do you require (if applicable)',
                          placeholderText: '',
                          onChanged: (nameData) {
                            if (nameData != null) {
                              numberOfBedrooms = nameData;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: CustomTextFormFiled(
                          isMandatory: false,
                          labelName:
                              'How many bathrooms / ensuites (if applicable)',
                          placeholderText: '',
                          onChanged: (nameData) {
                            if (nameData != null) {
                              bathroomNumber = nameData;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Please do check other requirements',
                        style: ThemeController.smallTextStyle(
                            color: Colors.black, size: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.2,
                        optionsList: otherRequirementsOption,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          otherRequirementsOptionHolder = [];
                          // NOTE adding the newly selected data
                          otherRequirementsOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'I prefer... *',
                        style: ThemeController.smallTextStyle(
                            color: Colors.black, size: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.2,
                        optionsList: existenceRequirementsOption,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          existenceRequirementsOptionHolder = [];
                          // NOTE adding the newly selected data
                          existenceRequirementsOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Please advise the location you want ..',
                        style: ThemeController.smallTextStyle(
                            color: Colors.black, size: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.2,
                        optionsList: locationRequirementsOption,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          locationRequirementsOptionHolder = [];
                          // NOTE adding the newly selected data
                          locationRequirementsOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'When you are planning to buy .. *',
                        style: ThemeController.smallTextStyle(
                            color: Colors.black, size: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.2,
                        optionsList: buyingRequirementsOption,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          buyingRequirementsOptionHolder = [];
                          // NOTE adding the newly selected data
                          buyingRequirementsOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: CustomTextFormFiled(
                          labelName:
                              'What is the value you are looking to spend',
                          placeholderText: '',
                          onChanged: (nameData) {
                            if (nameData != null) {
                              amountPlaned = nameData;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Does this include taxes',
                        style: ThemeController.smallTextStyle(
                            color: Colors.black, size: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.1,
                        optionsList: taxRequirementsOption,
                        isSelectOne: true,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          taxRequirementsOptionHolder = [];
                          // NOTE adding the newly selected data
                          taxRequirementsOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Are you in Portugal ',
                        style: ThemeController.smallTextStyle(
                            color: Colors.black, size: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.1,
                        optionsList: portugalRequirementsOption,
                        isSelectOne: true,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          portugalRequirementsOptionHolder = [];
                          // NOTE adding the newly selected data
                          portugalRequirementsOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'In order to assign you to the right Buyers agent, Please advise what languages to you speak ',
                        style: ThemeController.smallTextStyle(
                            color: Colors.black, size: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.2,
                        optionsList: languageRequirementsOption,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          languageRequirementsOptionHolder = [];
                          // NOTE adding the newly selected data
                          languageRequirementsOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: CustomTextFormFiled(
                          labelName:
                              ' Please advise when you would like to proceed with viewings',
                          placeholderText: '',
                          onChanged: (nameData) {
                            if (nameData != null) {
                              viewingProceedings = nameData;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Are you currently working with other agents',
                        style: ThemeController.smallTextStyle(
                            color: Colors.black, size: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.1,
                        optionsList: agentRequirementsOption,
                        isSelectOne: true,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          agentRequirementsOptionHolder = [];
                          // NOTE adding the newly selected data
                          agentRequirementsOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Have you got a Portuguse Fiscal number / Tax number',
                        style: ThemeController.smallTextStyle(
                            color: Colors.black, size: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.1,
                        optionsList: fiscalRequirementsOption,
                        isSelectOne: true,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          fiscalRequirementsOptionHolder = [];
                          // NOTE adding the newly selected data
                          fiscalRequirementsOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Have you opened a Portuguse bank account?',
                        style: ThemeController.smallTextStyle(
                            color: Colors.black, size: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SelectorGridWidget(
                        height: MediaQuery.of(context).size.height * 0.1,
                        optionsList: bankRequirementsOption,
                        isSelectOne: true,
                        getSelectedOptions: (tempData) {
                          // NOTE removing the existing data
                          bankRequirementsOptionHolder = [];
                          // NOTE adding the newly selected data
                          bankRequirementsOptionHolder.addAll(tempData);
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: CustomTextFormFiled(
                          labelName: 'Give additional information',
                          placeholderText: '',
                          onChanged: (nameData) {
                            if (nameData != null) {
                              additionalInformation = nameData;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Next step ...',
                        style: ThemeController.smallTextStyle(
                          color: Colors.black,
                          size: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Before we can begin your search we need to speak in person',
                        style: ThemeController.smallTextStyle(
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: CustomTextFormFiled(
                          labelName: 'Email',
                          placeholderText: '',
                          onChanged: (nameData) {
                            if (nameData != null) {
                              emailAddress = nameData;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Schedule a call',
                        style: ThemeController.smallTextStyle(
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                      // NOTE date time picker
                      DateTimeInlineScheduler(
                        getMeetingTime: (meetingData) {
                          meetingTime = meetingData;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Center(
                          child: Text(
                              'Thank you for choosing Algarve House Hunter.The next step is a brief onboarding call to discuss your search in more detail and explain how our free service works. This gives us both the chance to confirm we’\re a good fit before moving forward.If we both agree to proceed after the call, we’\ll begin a full property search on your behalf. Our service is free for clients who agree to work with us exclusively.By signing below, you confirm you\'re happy for us to represent you exclusively, provided we both agree to proceed after the call.Following our telephone consultation, we will then conduct a comprehensive search to find your dream property.'),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SignaturePadWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        child: SubmitButton(
                          onButtonPress: () async {
                            ManagerLogInScreenController.showLoaderDialog(
                                context);

                            await ApiController.sendAddClientData(
                              {
                                "client_name": firstName,
                                "client_email_address": emailAddress,
                                "client_phone_number": phoneNumber,
                                "client_location_name": "",
                                "client_lat_long": "",
                                "client_profile_pic":
                                    "https://randomuser.me/api/portraits/man/28.jpg",
                                "client_gender": "Male",
                                "client_description": "",
                                "client_designation": "",
                                "client_company_name": "",
                                "google_id": "",
                                "preference_data": {
                                  "findingPreference": findingOptionHolder,
                                  "bedNumber": numberOfBedrooms,
                                  "bathNumber": bathroomNumber,
                                  "requirementPreference": [],
                                  "otherPreference":
                                      otherRequirementsOptionHolder,
                                  "houseRegardsPreference":
                                      existenceRequirementsOptionHolder,
                                  "neighborPreference": [],
                                  "locationPreference":
                                      locationRequirementsOptionHolder,
                                  "areaInterestPreference":
                                      portugalRequirementsOptionHolder,
                                  "M2Preference": "",
                                  "buyingPreference":
                                      buyingRequirementsOptionHolder,
                                  "valueSpendPreference": amountPlaned,
                                  "taxPreference": taxRequirementsOptionHolder,
                                  "residenceInfo": "",
                                  "languagePreference":
                                      languageRequirementsOptionHolder,
                                  "viewingPreference": viewingProceedings,
                                  "otherAgentsStatus":
                                      agentRequirementsOptionHolder,
                                  "fiscalStatus":
                                      fiscalRequirementsOptionHolder,
                                  "bankStatus": bankRequirementsOptionHolder,
                                  "additionalInfo": additionalInformation,
                                  "email": emailAddress,
                                  "phoneNumber": phoneNumber,
                                  "appointmentInfo": meetingTime
                                },
                                "agent_id": [],
                                "client_account_password": password,
                                "assigned_property_all": [],
                                "liked_property": [],
                                "no_list_property": []
                              },
                              onError: (errorData) {},
                              onSuccess: (successData) {
                                isFormSubmitted = true;
                                ManagerLogInScreenController.hideDialogBox(
                                    context);
                                setState(() {});
                              },
                            );
                          },
                          buttonLabel: 'Get Started',
                        ),
                      )
                    ],
                  ),
                ),
              if (isFormSubmitted)
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/updated.json'),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Thank you for sharing your property requirements with us.\n\nOur team will review your preferences and begin shortlisting the most suitable properties for you.\nYou can expect to hear from us soon with tailored options that match your needs.",
                        style: ThemeController.normalTextStyle(),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
