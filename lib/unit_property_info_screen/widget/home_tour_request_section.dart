import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/model/home_tour_request_model.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/get_in_touch_button.dart';
import 'package:algarve_house_hunters_system/unit_property_info_screen/widget/home_tour_request_label_widget.dart';
import 'package:flutter/material.dart';

class HomeTourRequestSection extends StatelessWidget {
  final HomeTourRequestModel requestData;
  final VoidCallback? onTourRequestPress;
  const HomeTourRequestSection({
    super.key,
    required this.requestData,
    this.onTourRequestPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ThemeController.pageBackgroundSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Home tour request",
              style: ThemeController.normalTextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          HomeTourRequestLabelWidget(
            labelName: 'Name',
            labelValue: requestData.name,
          ),
          const SizedBox(
            height: 6,
          ),
          HomeTourRequestLabelWidget(
            labelName: 'Contact',
            labelValue: requestData.contact,
          ),
          const SizedBox(
            height: 6,
          ),
          HomeTourRequestLabelWidget(
            labelName: 'Date',
            labelValue: requestData.date,
          ),
          const SizedBox(
            height: 6,
          ),
          HomeTourRequestLabelWidget(
            labelName: 'Time',
            labelValue: requestData.time,
          ),
          const SizedBox(
            height: 6,
          ),
          HomeTourRequestLabelWidget(
            labelName: 'Message',
            labelValue: requestData.message,
          ),
          const SizedBox(
            height: 20,
          ),
          GetInTouchButton(
            onBtnPress: onTourRequestPress,
            btnLabel: 'Request',
          ),
        ],
      ),
    );
  }
}
