import 'dart:convert';

import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/toggle_switch_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/extracted_property_grid_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/global_widgets.dart';
import 'package:algarve_house_hunters_system/global_widgets/image_upload_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/property_domain_selector_widget.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class PropertyAdditionForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmitPress;
  final Map<String, dynamic>? initialValue;
  final String? propertyId;
  final String agentId;
  const PropertyAdditionForm({
    super.key,
    required this.onSubmitPress,
    this.initialValue,
    this.propertyId,
    this.agentId = '',
  });

  @override
  State<PropertyAdditionForm> createState() => _PropertyAdditionFormState();
}

class _PropertyAdditionFormState extends State<PropertyAdditionForm> {
  PropertyDomainType domainType = PropertyDomainType.casayes;
  String officeNotes = '';
  String listingRef = '';
  String registrationNotes = '';
  String ourRef = '';
  String ourNotes = '';
  String clientNotes = '';
  String price = '';
  String propertyM2 = '';
  String clientLink = '';
  String location = '';
  String beds = '';
  String baths = '';
  String plotSize = '';
  String pool = 'False';
  String parking = '';
  String distanceFromCoast = '';
  String googleMaps = '';
  String propertyId = '';
  String propertyName = '';
  String propertyDescription = '';
  String agentNotes = '';
  String referenceLink = '';
  String infocasaLink = '';
  List<String> propertyImages = [];
  String landType = '';
  String houseType = '';
  String floorNumber = '';
  String condominiumFees = '';
  String liftOrStairs = '';
  String distanceFromShops = '';
  String distanceTocafe = '';
  String singleLevelLiving = '';
  String annexOutbuilding = '';
  String mainWaterBoreHoles = '';
  String sewerage = '';
  String accessToProperty = '';
  String roadNoise = '';
  String neighbours = '';
  String aircon = '';
  String heating = '';
  String windowsNumber = '';
  String fullyLegal = '';
  String solar = "";

  // NOTE Form error text
  String? propertyNameErrorText;
  String? propertyDescriptionErrorText;
  String? clientLinkErrorText;
  String? locationErrorText;
  String? priceErrorText;
  String? listingRefErrorText;
  String? m2ErrorText;
  String? bedErrorText;
  String? bathsErrorText;
  String? plotErrorText;
  String? googleErrorText;
  String? referenceLinkErrorText;
  String? propertyImagesErrorText;

  PropertyDomainType detectPropertySite(String input) {
    // Normalize (add scheme if missing)
    final normalized =
        input.startsWith(RegExp(r'https?://')) ? input : 'https://$input';

    Uri uri = Uri.parse(normalized);
    final host = uri.host.toLowerCase();

    // Check for Infocasa
    if (host == 'infocasa.pt' || host.endsWith('.infocasa.pt')) {
      return PropertyDomainType.infocasa;
    }

    // Default to CasaYes if not Infocasa
    return PropertyDomainType.casayes;
  }

  void changeDomainType(PropertyDomainType data) {
    domainType = data;
    setState(() {});
  }

  void setReferenceLinkErrorText(String errorName) {
    referenceLinkErrorText = errorName;
    setState(() {});
  }

  void setGoogleErrorText(String errorName) {
    googleErrorText = errorName;
    setState(() {});
  }

  void setPlotErrorText(String errorName) {
    plotErrorText = errorName;
    setState(() {});
  }

  void setBathsErrorText(String errorName) {
    bathsErrorText = errorName;
    setState(() {});
  }

  void setBedErrorText(String errorName) {
    bedErrorText = errorName;
    setState(() {});
  }

  void setM2ErrorText(String errorName) {
    m2ErrorText = errorName;
    setState(() {});
  }

  void setListingRefErrorText(String errorName) {
    listingRefErrorText = errorName;
    setState(() {});
  }

  void setPropertyNameErrorText(String errorName) {
    propertyNameErrorText = errorName;
    setState(() {});
  }

  void setPropertyDescriptionErrorText(String errorName) {
    propertyDescriptionErrorText = errorName;
    setState(() {});
  }

  void setClientLinkErrorText(String errorName) {
    clientLinkErrorText = errorName;
    setState(() {});
  }

  void setLocationErrorText(String errorName) {
    locationErrorText = errorName;
    setState(() {});
  }

  void setPriceErrorText(String errorName) {
    priceErrorText = errorName;
    setState(() {});
  }

  void clearPropertyNameErrorText() {
    propertyNameErrorText = null;
    setState(() {});
  }

  void clearPropertyDescriptionErrorText() {
    propertyDescriptionErrorText = null;
    setState(() {});
  }

  void clearClientLinkErrorText() {
    clientLinkErrorText = null;
    setState(() {});
  }

  void clearLocationErrorText() {
    locationErrorText = null;
    setState(() {});
  }

  void clearPriceErrorText() {
    priceErrorText = null;
    setState(() {});
  }

  void clearListingRefErrorText() {
    listingRefErrorText = null;
    setState(() {});
  }

  void clearM2ErrorText() {
    m2ErrorText = null;
    setState(() {});
  }

  void clearBedErrorText() {
    bedErrorText = null;
    setState(() {});
  }

  void clearBathsErrorText() {
    bathsErrorText = null;
    setState(() {});
  }

  void clearPlotErrorText() {
    plotErrorText = null;
    setState(() {});
  }

  void clearGoogleErrorText() {
    googleErrorText = null;
    setState(() {});
  }

  void clearReferenceLinkErrorText() {
    referenceLinkErrorText = null;
    setState(() {});
  }

  void assignPropertyData() {
    if (widget.initialValue != null && widget.propertyId != null) {
      officeNotes = widget.initialValue!["officeNotes"];
      registrationNotes = widget.initialValue!["registrationNotes"];
      ourRef = widget.initialValue!["ourRef"];
      ourNotes = widget.initialValue!["ourNotes"];
      clientNotes = widget.initialValue!["clientNotes"];
      clientLink = widget.initialValue!["clientLink"];
      pool = widget.initialValue!["pool"];
      parking = widget.initialValue!["parking"];
      location = widget.initialValue!["propertyLocationName"];
      price = widget.initialValue!["propertyPrice"];
      listingRef = widget.initialValue!["listingRef"];
      propertyM2 = widget.initialValue!["propertyM2"];
      beds = widget.initialValue!["bedsNumber"];
      baths = widget.initialValue!["bathsNumber"];
      plotSize = widget.initialValue!["plotSize"];
      distanceFromCoast = widget.initialValue!["distanceFromCoast"];
      googleMaps = widget.initialValue!["googleMapLink"];
      propertyName = widget.initialValue!["propertyName"];
      propertyName = widget.initialValue!["propertyDescription"];
      propertyId = widget.propertyId!;
      setState(() {});
    }
  }

  Widget getToggleWidget(
      {required String labelName, required Function(bool) onToggle}) {
    return Row(
      children: [
        Text(
          labelName,
          style: ThemeController.smallTextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        ToggleSwitchWidget(
          onToggle: onToggle,
          onLabel: "Yes",
          offLabel: "No",
        ),
      ],
    );
  }

  bool validateFormData() {
    bool validateError = false;
    if (propertyName == '' || propertyName.isEmpty) {
      setPropertyNameErrorText("Property name is mandatory !!!");
      validateError = true;
    }
    if (propertyDescription == '' || propertyDescription.isEmpty) {
      setPropertyDescriptionErrorText("Property description is mandatory !!!");
      validateError = true;
    }
    if (clientLink == '' || clientLink.isEmpty) {
      setClientLinkErrorText("Client link is mandatory !!!");
      validateError = true;
    }
    if (location == '' || location.isEmpty) {
      setLocationErrorText("Location name is mandatory !!!");
      validateError = true;
    }
    if (price == '' || price.isEmpty) {
      setPriceErrorText("Price is mandatory !!!");
      validateError = true;
    }
    if (listingRef == '' || listingRef.isEmpty) {
      setListingRefErrorText("Listing reference is mandatory !!!");
      validateError = true;
    }
    if (propertyM2 == '' || propertyM2.isEmpty) {
      setM2ErrorText("M2 value is mandatory !!!");
      validateError = true;
    }
    if (beds == '' || beds.isEmpty) {
      setBedErrorText("Bed value is mandatory !!!");
      validateError = true;
    }
    if (baths == '' || baths.isEmpty) {
      setBathsErrorText("Bath value is mandatory !!!");
      validateError = true;
    }
    if (propertyImages.length < 6) {
      propertyImagesErrorText =
          "Minimum of five property images has to be uploaded";
      validateError = true;
      setState(() {});
    }
    // if (plotSize == '' || plotSize.isEmpty) {
    //   setPlotErrorText("Bath value is mandatory !!!");
    //   validateError = true;
    // }
    // if (googleMaps == '' || googleMaps.isEmpty) {
    //   setGoogleErrorText("Google link value is mandatory !!!");
    //   validateError = true;
    // }
    // if (referenceLink == '' || referenceLink.isEmpty) {
    //   setReferenceLinkErrorText("Reference link value is mandatory !!!");
    //   validateError = true;
    // }

    return validateError;
  }

  @override
  void initState() {
    assignPropertyData();
    print("Office Notes; $officeNotes");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Add new property",
          style: ThemeController.normalTextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        // const SizedBox(
        //   height: 20,
        // ),

        Text(
          "PROPERTY LINK",
          style: ThemeController.smallTextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w700,
            size: 12,
          ),
        ),
        const SizedBox(height: 8),
        CustomTextFormFiled(
          labelName: '',
          placeholderText: 'https://...',
          isMandatory: false,
          onChanged: (data) {
            if (data != null && data == '') {
              infocasaLink = data;
              setState(() {});
            }
          },
          onPaste: (data) {
            infocasaLink = data;
            PropertyDomainType linkType = detectPropertySite(infocasaLink);
            changeDomainType(linkType);
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            PropertyDomainSelectorWidget(
              key: Key(domainType.toString()),
              initialValue: domainType,
              onStateChange: (stateValue) {
                changeDomainType(stateValue);
              },
            ),
            const Spacer(),
            SizedBox(
              width: 150,
              child: SubmitButton(
                onButtonPress: () async {
                    if (infocasaLink != '') {
                      ManagerLogInScreenController.showLoaderDialog(context);
                      if (domainType == PropertyDomainType.infocasa) {
                        await ApiController.getInfocasaPropertyExtraction(
                          infocasaLink,
                          onSuccess: (resData) {
                            // ManagerLogInScreenController.hideDialogBox(context);
                            // ManagerLogInScreenController.showSuccess(
                            //     context, 'Details has been extracted !!');
                            final responseData = jsonDecode(resData);
                            propertyName = responseData['propertyName'];
                            clientLink = responseData['clientLink'];
                            pool = responseData['pool'];
                            parking = responseData['parking'];
                            location = responseData['propertyLocationName'];
                            price = responseData['propertyPrice'];
                            listingRef = responseData['listingRef'];
                            propertyM2 = responseData['propertyM2'];
                            beds = responseData['rooms'];
                            baths = responseData['bathsroom'];
                            plotSize = responseData['plotSize'];
                            distanceFromCoast =
                                responseData['distanceFromCoast'];
                            googleMaps = responseData['googleMapLink'];
                            propertyDescription =
                                responseData['propertyDescription'];
                            propertyImages.clear();
                            propertyImages.addAll(
                                (responseData['propertyImages'] as List)
                                    .cast<String>());
                            setState(() {});
                            ManagerLogInScreenController.hideDialogBox(context);
                          },
                          onError: (errData) {
                            // ManagerLogInScreenController.hideDialogBox(context);
                            ManagerLogInScreenController.showError(
                              context,
                              jsonDecode(errData),
                            );
                          },
                        );
                      } else {
                        await ApiController.getCasayesPropertyExtraction(
                          infocasaLink,
                          onSuccess: (resData) {
                            // ManagerLogInScreenController.hideDialogBox(context);
                            // ManagerLogInScreenController.showSuccess(
                            //     context, 'Details has been extracted !!');
                            final responseData = jsonDecode(resData);
                            propertyName = responseData['propertyName'];
                            clientLink = responseData['clientLink'];
                            pool = responseData['pool'];
                            parking = responseData['parking'];
                            location = responseData['propertyLocationName'];
                            price = responseData['propertyPrice'];
                            listingRef = responseData['listingRef'];
                            propertyM2 = responseData['propertyM2'];
                            beds = responseData['rooms'];
                            baths = responseData['bathsroom'];
                            plotSize = responseData['plotSize'];
                            distanceFromCoast =
                                responseData['distanceFromCoast'];
                            googleMaps = responseData['googleMapLink'];
                            propertyDescription =
                                responseData['propertyDescription'];
                            propertyImages.clear();
                            propertyImages.addAll(
                                (responseData['propertyImages'] as List)
                                    .cast<String>());
                            setState(() {});
                            ManagerLogInScreenController.hideDialogBox(context);
                          },
                          onError: (errData) {
                            // ManagerLogInScreenController.hideDialogBox(context);
                            ManagerLogInScreenController.showError(
                              context,
                              jsonDecode(errData),
                            );
                          },
                        );
                      }
                    }
                  },
                  buttonLabel: 'Extract Data',
                ),
              ),
            ],
          ),
        const SizedBox(
          height: 20,
        ),

        SizedBox(
          width: double.infinity,
          // height: 400,
          child: ImageUploadWidget(
            baseUrl: 'https://systems.algarvehousehunters.com',
            onUploadComplete: (data) {
              List<String> imageUrls = data
                  .map((file) => file["shareable_link"].toString())
                  .toList();
              print("DEBUG: uploaded images: ${imageUrls}");
              for (var imageData in imageUrls) {
                if (!propertyImages.contains(imageData)) {
                  propertyImages.add(imageData);
                  setState(() {});
                }
              }
              propertyImagesErrorText = null;
              setState(() {});
              // propertyImages.addAll(imageUrls);
              // setState(() {});
            },
          ),
        ),
        if (propertyImagesErrorText != null)
          Text(
            propertyImagesErrorText!,
            style: ThemeController.smallTextStyle(color: Colors.red),
          ),
        if (propertyImages.isNotEmpty)
          Column(
            children: [
              ExpansionTile(
                title: Text(
                  'Property images ${propertyImages.length}',
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
                            imageUrls: propertyImages,
                            title: "Property glance",
                          );
                        },
                        child: PropertyImageGrid(
                          imageUrls: propertyImages,
                          onDelete: (index) {
                            propertyImages.removeAt(index);
                            setState(() {});
                          },
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

        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: propertyName,
                labelName: 'Property name',
                placeholderText: '',
                errorText: propertyNameErrorText,
                isMandatory: true,
                onChanged: (notesData) {
                  clearPropertyNameErrorText();
                  if (notesData != null) {
                    propertyName = notesData;
                  } else {
                    setPropertyNameErrorText(
                        "Property name cannot be empty !!!");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: propertyDescription,
                labelName: 'Property description',
                placeholderText: '',
                errorText: propertyDescriptionErrorText,
                isMandatory: true,
                onChanged: (notesData) {
                  clearPropertyDescriptionErrorText();
                  if (notesData != null) {
                    propertyDescription = notesData;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: clientLink,
                labelName: 'Client link',
                placeholderText: '',
                errorText: clientLinkErrorText,
                isMandatory: true,
                onChanged: (notesData) {
                  clearClientLinkErrorText();
                  if (notesData != null) {
                    clientLink = notesData;
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: location,
                labelName: 'Location name',
                placeholderText: '',
                errorText: locationErrorText,
                isMandatory: true,
                onChanged: (notesData) {
                  clearLocationErrorText();
                  if (notesData != null) {
                    location = notesData;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: price,
                labelName: 'Price',
                placeholderText: '',
                isMandatory: true,
                errorText: priceErrorText,
                onChanged: (notesData) {
                  clearPriceErrorText();
                  if (notesData != null) {
                    price = notesData;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: listingRef,
                labelName: 'Listing reference',
                placeholderText: '',
                errorText: listingRefErrorText,
                isMandatory: true,
                onChanged: (notesData) {
                  clearListingRefErrorText();
                  if (notesData != null) {
                    listingRef = notesData;
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: propertyM2,
                labelName: 'M2',
                placeholderText: '',
                isMandatory: true,
                errorText: m2ErrorText,
                onChanged: (notesData) {
                  clearM2ErrorText();
                  if (notesData != null) {
                    propertyM2 = notesData;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: beds,
                labelName: 'Beds number',
                placeholderText: '',
                errorText: bedErrorText,
                isMandatory: true,
                onChanged: (notesData) {
                  clearBedErrorText();
                  if (notesData != null) {
                    beds = notesData;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: baths,
                labelName: 'Baths number',
                placeholderText: '',
                errorText: bathsErrorText,
                isMandatory: true,
                onChanged: (notesData) {
                  clearBathsErrorText();
                  if (notesData != null) {
                    baths = notesData;
                  }
                },
              ),
            ),
          ],
        ),
        // SECTION New Row 1
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NOTE Land Type
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: plotSize,
                labelName: 'Land Type',
                placeholderText: '',
                errorText: null,
                isMandatory: false,
                onChanged: (notesData) {
                  clearPlotErrorText();
                  if (notesData != null) {
                    landType = notesData;
                  }
                },
              ),
            ),
            // NOTE House Type
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: distanceFromCoast,
                labelName: 'House Type',
                placeholderText: '',
                isMandatory: false,
                onChanged: (notesData) {
                  if (notesData != null) {
                    houseType = notesData;
                  }
                },
              ),
            ),
            // NOTE Condominium Fees
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: googleMaps,
                labelName: 'Condominium Fees',
                placeholderText: '',
                isMandatory: false,
                errorText: null,
                onChanged: (notesData) {
                  clearGoogleErrorText();
                  if (notesData != null) {
                    condominiumFees = notesData;
                  }
                },
              ),
            ),
          ],
        ),
        // SECTION New Row 2
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NOTE liftOrStairs
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: plotSize,
                labelName: 'Lift Or Stairs',
                placeholderText: '',
                errorText: null,
                isMandatory: false,
                onChanged: (notesData) {
                  clearPlotErrorText();
                  if (notesData != null) {
                    liftOrStairs = notesData;
                  }
                },
              ),
            ),
            // NOTE Distance From Shops
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: distanceFromCoast,
                labelName: 'Distance From Shops',
                placeholderText: '',
                isMandatory: false,
                onChanged: (notesData) {
                  if (notesData != null) {
                    distanceFromShops = notesData;
                  }
                },
              ),
            ),
            // NOTE Distance To cafe
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: googleMaps,
                labelName: 'Distance To cafe',
                placeholderText: '',
                isMandatory: false,
                errorText: null,
                onChanged: (notesData) {
                  clearGoogleErrorText();
                  if (notesData != null) {
                    distanceTocafe = notesData;
                  }
                },
              ),
            ),
          ],
        ),
        // SECTION New Row 3
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NOTE singleLevelLiving
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: singleLevelLiving,
                labelName: 'Single Level Living',
                placeholderText: '',
                errorText: null,
                isMandatory: false,
                onChanged: (notesData) {
                  clearPlotErrorText();
                  if (notesData != null) {
                    singleLevelLiving = notesData;
                  }
                },
              ),
            ),
            // NOTE annexOutbuilding
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: annexOutbuilding,
                labelName: 'Annex Out Building',
                placeholderText: '',
                isMandatory: false,
                onChanged: (notesData) {
                  if (notesData != null) {
                    annexOutbuilding = notesData;
                  }
                },
              ),
            ),
            // NOTE Distance To cafe
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: mainWaterBoreHoles,
                labelName: 'Main Water Bore Holes',
                placeholderText: '',
                isMandatory: false,
                errorText: null,
                onChanged: (notesData) {
                  clearGoogleErrorText();
                  if (notesData != null) {
                    mainWaterBoreHoles = notesData;
                  }
                },
              ),
            ),
          ],
        ),
        // SECTION New Row 4
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NOTE Sewerage
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: sewerage,
                labelName: 'Sewerage',
                placeholderText: '',
                errorText: null,
                isMandatory: false,
                onChanged: (notesData) {
                  clearPlotErrorText();
                  if (notesData != null) {
                    sewerage = notesData;
                  }
                },
              ),
            ),
            // NOTE accessToProperty
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: accessToProperty,
                labelName: 'Access To Property',
                placeholderText: '',
                isMandatory: false,
                onChanged: (notesData) {
                  if (notesData != null) {
                    accessToProperty = notesData;
                  }
                },
              ),
            ),
            // NOTE Road Noise
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: roadNoise,
                labelName: 'Road Noise',
                placeholderText: '',
                isMandatory: false,
                errorText: null,
                onChanged: (notesData) {
                  clearGoogleErrorText();
                  if (notesData != null) {
                    roadNoise = notesData;
                  }
                },
              ),
            ),
          ],
        ),
        // SECTION New Row 5
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NOTE Neighbours
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: neighbours,
                labelName: 'Neighbours',
                placeholderText: '',
                errorText: null,
                isMandatory: false,
                onChanged: (notesData) {
                  clearPlotErrorText();
                  if (notesData != null) {
                    neighbours = notesData;
                  }
                },
              ),
            ),
            // NOTE aircon
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: aircon,
                labelName: 'aircon',
                placeholderText: '',
                isMandatory: false,
                onChanged: (notesData) {
                  if (notesData != null) {
                    aircon = notesData;
                  }
                },
              ),
            ),
            // NOTE Road Noise
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: heating,
                labelName: 'Heating',
                placeholderText: '',
                isMandatory: false,
                errorText: null,
                onChanged: (notesData) {
                  clearGoogleErrorText();
                  if (notesData != null) {
                    heating = notesData;
                  }
                },
              ),
            ),
          ],
        ),
        // SECTION New Row 6
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // NOTE Windows Number
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: windowsNumber,
                labelName: 'Windows Number',
                placeholderText: '',
                errorText: null,
                isMandatory: false,
                onChanged: (notesData) {
                  clearPlotErrorText();
                  if (notesData != null) {
                    windowsNumber = notesData;
                  }
                },
              ),
            ),
            // NOTE Fully Legal
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: fullyLegal,
                labelName: 'Fully Legal',
                placeholderText: '',
                isMandatory: false,
                onChanged: (notesData) {
                  if (notesData != null) {
                    fullyLegal = notesData;
                  }
                },
              ),
            ),
            // NOTE Road Noise
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: solar,
                labelName: 'Solar',
                placeholderText: '',
                isMandatory: false,
                errorText: null,
                onChanged: (notesData) {
                  clearGoogleErrorText();
                  if (notesData != null) {
                    solar = notesData;
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: ourRef,
                labelName: 'Our reference',
                placeholderText: '',
                isMandatory: false,
                onChanged: (notesData) {
                  if (notesData != null) {
                    ourRef = notesData;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: CustomTextFormFiled(
                initialValue: referenceLink,
                labelName: 'Reference link',
                placeholderText: '',
                isMandatory: false,
                errorText: referenceLinkErrorText,
                onChanged: (notesData) {
                  clearReferenceLinkErrorText();
                  if (notesData != null) {
                    referenceLink = notesData;
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: getToggleWidget(
                labelName: "Pool",
                onToggle: (data) {
                  if (data == true) {
                    pool = 'True';
                  } else {
                    pool = "False";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: getToggleWidget(
                labelName: "Parking",
                onToggle: (data) {
                  if (data == true) {
                    parking = 'True';
                  } else {
                    parking = "False";
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: getToggleWidget(
                labelName: "Sold",
                onToggle: (data) {},
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CustomTextFormFiled(
            initialValue: officeNotes,
            labelName: 'Office notes',
            placeholderText: '',
            isMandatory: false,
            onChanged: (notesData) {
              if (notesData != null) {
                officeNotes = notesData;
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CustomTextFormFiled(
            initialValue: clientNotes,
            labelName: 'Client notes',
            placeholderText: '',
            isMandatory: false,
            onChanged: (notesData) {
              if (notesData != null) {
                clientNotes = notesData;
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CustomTextFormFiled(
            initialValue: agentNotes,
            labelName: 'Agent notes',
            placeholderText: '',
            isMandatory: false,
            onChanged: (notesData) {
              if (notesData != null) {
                agentNotes = notesData;
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CustomTextFormFiled(
            initialValue: ourNotes,
            labelName: 'Our notes',
            placeholderText: '',
            isMandatory: false,
            onChanged: (notesData) {
              if (notesData != null) {
                ourNotes = notesData;
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CustomTextFormFiled(
            initialValue: registrationNotes,
            labelName: 'Registration notes',
            placeholderText: '',
            isMandatory: false,
            onChanged: (notesData) {
              if (notesData != null) {
                registrationNotes = notesData;
              }
            },
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        SubmitButton(
          onButtonPress: () {
            bool check = validateFormData();
            if (check == false) {
              widget.onSubmitPress(
                {
                  "propertyId": "",
                  "propertyName": propertyName,
                  "clientLink": clientLink,
                  "pool": pool,
                  "parking": parking,
                  "propertyLocationName": location,
                  "propertyPrice": price,
                  "listingRef": listingRef,
                  "propertyM2": propertyM2,
                  "bedsNumber": beds,
                  "bathsNumber": baths,
                  "plotSize": plotSize,
                  "distanceFromCoast": distanceFromCoast,
                  "googleMapLink": googleMaps,
                  "propertyDescription": propertyDescription,
                  "ourRef": ourRef,
                  "createdBy": widget.agentId,
                  "createdTime": DateTime.now().toString(),
                  "propertyRefLink": referenceLink,
                  "isSold": "False",
                  "propertyImages": propertyImages,
                  "officeNotes": [
                    if (officeNotes.isNotEmpty)
                      {
                        "notesValue": officeNotes,
                        "createdBy": widget.agentId,
                        "createdTime": DateTime.now().toString(),
                        "notesId":
                            AgentDashboardScreenController.generateCustomId()
                      }
                  ],
                  "contact": [
                    // {"contactName": "", "contactType": "", "contactValue": ""}
                  ],
                  "registrationNotes": [
                    if (registrationNotes.isNotEmpty)
                      {
                        "notesValue": registrationNotes,
                        "createdBy": widget.agentId,
                        "createdTime": DateTime.now().toString(),
                        "notesId":
                            AgentDashboardScreenController.generateCustomId(),
                      },
                  ],
                  "clientNotes": [
                    if (clientNotes.isNotEmpty)
                      {
                        "notesValue": clientNotes,
                        "createdBy": widget.agentId,
                        "createdTime": DateTime.now().toString(),
                        "notesId":
                            AgentDashboardScreenController.generateCustomId()
                      },
                  ],
                  "assignedTo": [],
                  "agentNotes": [
                    if (agentNotes.isNotEmpty)
                      {
                        "notesValue": agentNotes,
                        "createdBy": widget.agentId,
                        "createdTime": DateTime.now().toString(),
                        "notesId":
                            AgentDashboardScreenController.generateCustomId(),
                      },
                  ],
                  "ourNotes": [
                    if (ourNotes.isNotEmpty)
                      {
                        "agent_id": widget.agentId,
                        "agent_comments": ourNotes,
                        "comment_added_date": DateTime.now().toString()
                      }
                  ],
                  "visitingDetails": []
                },
              );
            }
          },
          buttonLabel: 'Add property',
        )
      ],
    );
  }
}
