import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/controller/agent_controller_property_allocation_controller.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_values_display_widget.dart';
import 'package:algarve_house_hunters_system/global_model/customer_data_model.dart';
import 'package:flutter/material.dart';

class UserPreferenceWidget extends StatelessWidget {
  final CustomerDataModel customerData;
  const UserPreferenceWidget({
    super.key,
    required this.customerData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            UserPreferenceValuesDisplayWidget(
              labelName: 'Name',
              labelValue: customerData.basicData.userName,
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Designation',
              labelValue: customerData.basicData.designation,
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Finding Preference',
              labelValue:
                  AgentControllerPropertyAllocationController.listToString(
                customerData.preferenceData.findingPreference,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Bed numbers',
              labelValue: customerData.preferenceData.bedNumber.toString(),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Bath numbers',
              labelValue: customerData.preferenceData.bathNumber.toString(),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Requirement Preference',
              labelValue:
                  AgentControllerPropertyAllocationController.listToString(
                customerData.preferenceData.requirementPreference,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Other Preference',
              labelValue:
                  AgentControllerPropertyAllocationController.listToString(
                customerData.preferenceData.otherPreference,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'House Regarding Preference',
              labelValue:
                  AgentControllerPropertyAllocationController.listToString(
                customerData.preferenceData.houseRegardsPreference,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Neighbor Preference',
              labelValue:
                  AgentControllerPropertyAllocationController.listToString(
                customerData.preferenceData.neighborPreference,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Location Preference',
              labelValue:
                  AgentControllerPropertyAllocationController.listToString(
                customerData.preferenceData.locationPreference,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Area Interest Preference',
              labelValue: customerData.preferenceData.areaInterestPreference,
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'M2 Preference',
              labelValue: customerData.preferenceData.M2Preference,
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Buying Preference',
              labelValue:
                  AgentControllerPropertyAllocationController.listToString(
                customerData.preferenceData.buyingPreference,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Area Interest Preference',
              labelValue:
                  customerData.preferenceData.valueSpendPreference.toString(),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Tax Preference',
              labelValue:
                  AgentControllerPropertyAllocationController.listToString(
                      customerData.preferenceData.taxPreference),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Residence Preference',
              labelValue: customerData.preferenceData.residenceInfo,
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Language Preference',
              labelValue:
                  AgentControllerPropertyAllocationController.listToString(
                      customerData.preferenceData.languagePreference),
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Viewing Preference',
              labelValue: customerData.preferenceData.viewingPreference,
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Other Agents Status',
              labelValue: customerData.preferenceData.otherAgentsStatus,
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Fiscal Status',
              labelValue: customerData.preferenceData.fiscalStatus,
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Bank Status',
              labelValue: customerData.preferenceData.bankStatus,
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Additional Info',
              labelValue: customerData.preferenceData.additionalInfo,
            ),
            const SizedBox(
              height: 10,
            ),
            UserPreferenceValuesDisplayWidget(
              labelName: 'Appointment Info',
              labelValue: customerData.preferenceData.appointmentInfo,
            ),
          ],
        )
      ],
    );
  }
}
