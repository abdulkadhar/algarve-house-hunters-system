import 'package:algarve_house_hunters_system/customer_property_listing_screen/controller/customer_property_listing_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/option_button.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_feature_card.dart';
import 'package:algarve_house_hunters_system/customer_property_listing_screen/widget/property_info_carousel.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class CustomerPropertyInfoWidget extends StatefulWidget {
  final Map<String, dynamic> propertyInfo;
  final VoidCallback onViewMorePress;
  final CustomerListingOption option;
  final Function(String)? onLikePress;
  final Function(String)? onUnLikePress;
  const CustomerPropertyInfoWidget({
    super.key,
    required this.propertyInfo,
    required this.onViewMorePress,
    this.option = CustomerListingOption.recommendation,
    this.onLikePress,
    this.onUnLikePress,
  });

  @override
  State<CustomerPropertyInfoWidget> createState() =>
      _CustomerPropertyInfoWidgetState();
}

class _CustomerPropertyInfoWidgetState
    extends State<CustomerPropertyInfoWidget> {
  String reason = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          PropertyInfoCarousel(
            imagePaths: List<String>.from(
              widget.propertyInfo["propertyImages"],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.propertyInfo["propertyName"],
                  style: ThemeController.titleTextStyle(
                    size: 18,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    const SizedBox(
                      width: 2,
                    ),
                    Text(
                      widget.propertyInfo["propertyLocationName"],
                      style: ThemeController.smallTextStyle(),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    PropertyFeatureCard(
                      featureName: 'Bedroom',
                      featureValue: widget.propertyInfo["bedsNumber"],
                    ),
                    PropertyFeatureCard(
                      featureName: 'Baths',
                      featureValue: widget.propertyInfo["bathsNumber"],
                    ),
                    PropertyFeatureCard(
                      featureName: 'Coastal distance',
                      featureValue:
                          '${widget.propertyInfo["distanceFromCoast"]} mins',
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.propertyInfo["propertyDescription"],
                  style: ThemeController.smallTextStyle(
                    size: 10,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      'Price:',
                      style: ThemeController.smallTextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '€${widget.propertyInfo["propertyPrice"]}',
                      style: ThemeController.smallTextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: CustomTextFormFiled(
                        labelName: '',
                        placeholderText: 'Reason',
                        onChanged: (data) {
                          if (data != null && data.isNotEmpty) {
                            reason = data;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (widget.option == CustomerListingOption.recommendation ||
                        widget.option == CustomerListingOption.noList)
                      OptionButton(
                        label: 'Like',
                        onTap: () {
                          if (widget.onLikePress != null) {
                            widget.onLikePress!(reason);
                          }
                        },
                        optionColor: Colors.green,
                      ),
                    if (widget.option == CustomerListingOption.recommendation ||
                        widget.option == CustomerListingOption.noList)
                      const SizedBox(
                        width: 10,
                      ),
                    if (widget.option == CustomerListingOption.recommendation ||
                        widget.option == CustomerListingOption.liked)
                      OptionButton(
                        label: 'Dislike',
                        onTap: () {
                          if (widget.onUnLikePress != null) {
                            widget.onUnLikePress!(reason);
                          }
                        },
                        optionColor: Colors.red,
                      ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: widget.onViewMorePress,
                      child: Container(
                        margin: EdgeInsets.only(top: 25),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "View Details",
                          style: ThemeController.smallTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
