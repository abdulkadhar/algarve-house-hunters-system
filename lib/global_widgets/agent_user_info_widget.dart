import 'dart:convert';

import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_status_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AgentUserInfoWidget extends StatefulWidget {
  final VoidCallback onProfilePress;
  final AgentModel agentData;
  final String agentId;
  const AgentUserInfoWidget({
    super.key,
    required this.onProfilePress,
    required this.agentData,
    this.agentId = '',
  });

  @override
  State<AgentUserInfoWidget> createState() => _AgentUserInfoWidgetState();
}

class _AgentUserInfoWidgetState extends State<AgentUserInfoWidget> {
  Map<String, dynamic>? agentInfo;
  AgentStatus status = AgentStatus.available;
  bool isSetStatus = false;

  void setAgentStatus(AgentStatus statusData) {
    status = statusData;
    setState(() {});
  }

  void getAgentProfileData() async {
    await ApiController.getAgentInfoById(
      widget.agentId,
      onError: (data) {},
      onSuccess: (data) {
        agentInfo = jsonDecode(data);
        setState(() {});
      },
    );
  }

  Widget getSelectedStatusWidget(bool isSelected, AgentStatus agentStatus) {
    return InkWell(
      onTap: () {
        setAgentStatus(agentStatus);
      },
      child: Row(
        children: [
          AgentStatusWidget(status: agentStatus),
          if (isSelected)
            const SizedBox(
              width: 2,
            ),
          if (isSelected)
            const Icon(
              Icons.done,
              color: Colors.black,
            )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getAgentProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onProfilePress();
        context.go('/agent-info-update-screen/${widget.agentId}');
      },
      child: agentInfo == null
          ? SizedBox.shrink()
          : Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      // widget.agentData.profileImgPath,
                      agentInfo!['agent_profile_pic']),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // widget.agentData.agentName,
                      agentInfo!['agent_name'],
                      style: ThemeController.normalTextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      // widget.agentData.agentDesignation,
                      agentInfo!['agent_email_address'],
                      style: ThemeController.smallTextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     isSetStatus = !isSetStatus;
                    //     setState(() {});
                    //   },
                    //   child: !isSetStatus
                    //       ? Row(
                    //           children: [
                    //             AgentStatusWidget(status: status),
                    //             const SizedBox(
                    //               width: 10,
                    //             ),
                    //             Text(
                    //               CustomerDashboardScreenController
                    //                   .getAgentLabelString(status),
                    //               style: ThemeController.smallTextStyle(),
                    //             )
                    //           ],
                    //         )
                    //       : Row(
                    //           children: [
                    //             getSelectedStatusWidget(
                    //               status == AgentStatus.available,
                    //               AgentStatus.available,
                    //             ),
                    //             const SizedBox(
                    //               width: 5,
                    //             ),
                    //             getSelectedStatusWidget(
                    //               status == AgentStatus.away,
                    //               AgentStatus.away,
                    //             ),
                    //             const SizedBox(
                    //               width: 5,
                    //             ),
                    //             getSelectedStatusWidget(
                    //               status == AgentStatus.offline,
                    //               AgentStatus.offline,
                    //             ),
                    //             const SizedBox(
                    //               width: 5,
                    //             ),
                    //             InkWell(
                    //               onTap: () {
                    //                 isSetStatus = !isSetStatus;
                    //                 setState(() {});
                    //               },
                    //               child: Icon(
                    //                 Icons.cancel_presentation_outlined,
                    //                 color: Colors.black,
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    // ),
                    InkWell(
                      onTap: () {
                        context.replace('/agent-login-screen');
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.power_settings_new,
                            color: Colors.red,
                            size: 14,
                            weight: 10,
                          ),
                          const SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Logout",
                            style: ThemeController.smallTextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }
}
