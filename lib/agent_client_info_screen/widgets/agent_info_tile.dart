import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_values_display_widget.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AgentInfoTile extends StatelessWidget {
  final Map<String, dynamic> agent;
  final VoidCallback? onRemovePress;

  const AgentInfoTile({
    super.key,
    required this.agent,
    this.onRemovePress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Row(
          children: [
            Text(
              agent['agent_name'] ?? 'Unknown Agent',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            if (onRemovePress != null) const Spacer(),
            if (onRemovePress != null)
              AddMoreButton(
                onButtonPress: onRemovePress!,
                buttonLabel: 'Un Assign',
                iconData: Icons.cancel,
              ),
          ],
        ),
        subtitle: Text(agent['agent_designation'] ?? ''),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserPreferenceValuesDisplayWidget(
                  labelName: 'Agent Id',
                  labelValue: agent['agent_id'],
                ),
                const SizedBox(height: 8),
                UserPreferenceValuesDisplayWidget(
                  labelName: 'Agent Name',
                  labelValue: agent['agent_name'],
                ),
                const SizedBox(height: 8),
                UserPreferenceValuesDisplayWidget(
                  labelName: 'Agent email address',
                  labelValue: agent['agent_email_address'],
                ),
                const SizedBox(height: 8),
                UserPreferenceValuesDisplayWidget(
                  labelName: 'Agent phone number',
                  labelValue: agent['agent_phone_number'],
                ),
                const SizedBox(height: 8),
                UserPreferenceValuesDisplayWidget(
                  labelName: 'Agent location',
                  labelValue: agent['agent_location_name'],
                ),
                const SizedBox(height: 8),
                UserPreferenceValuesDisplayWidget(
                  labelName: 'Agent Status',
                  labelValue: agent['agent_status'],
                ),
                const SizedBox(height: 8),
                UserPreferenceValuesDisplayWidget(
                  labelName: 'Agent Designation',
                  labelValue: agent['agent_designation'],
                ),
                const SizedBox(height: 8),
                UserPreferenceValuesDisplayWidget(
                  labelName: 'Agent Description',
                  labelValue: agent['agent_description'],
                ),
                const SizedBox(height: 8),
                UserPreferenceValuesDisplayWidget(
                  labelName: 'Clients on pipeline',
                  labelValue: agent['assigned_clients'].length.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
