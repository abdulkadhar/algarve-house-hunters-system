import 'dart:convert';

import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';

import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_status_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class ManagerInfoWidget extends StatefulWidget {
  final String managerId;
  final VoidCallback onProfilePress;
  const ManagerInfoWidget({
    super.key,
    required this.onProfilePress,
    required this.managerId,
  });

  @override
  State<ManagerInfoWidget> createState() => _ManagerInfoWidgetState();
}

class _ManagerInfoWidgetState extends State<ManagerInfoWidget> {
  Map<String, dynamic>? managerData;
  AgentStatus status = AgentStatus.available;
  bool isSetStatus = false;

  void getManagerData() async {
    await ApiController.getManagerData(
      managerId: widget.managerId,
      onSuccess: (data) {
        managerData = jsonDecode(data);
        setState(() {});
      },
      onError: (data) {},
    );
  }

  void setAgentStatus(AgentStatus statusData) {
    status = statusData;
    setState(() {});
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
    getManagerData();
  }

  @override
  Widget build(BuildContext context) {
    if (managerData == null) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      );
    }
    return InkWell(
      onTap: widget.onProfilePress,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              // widget.agentData.profileImgPath,
              managerData!["manager_profile_pic"],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // widget.agentData.agentName,
                managerData!["manager_name"],
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                // widget.agentData.agentDesignation,
                managerData!["manager_designation"],
                style: ThemeController.smallTextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                onTap: () {
                  isSetStatus = !isSetStatus;
                  setState(() {});
                },
                child: !isSetStatus
                    ? Row(
                        children: [
                          AgentStatusWidget(status: status),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            CustomerDashboardScreenController
                                .getAgentLabelString(status),
                            style: ThemeController.smallTextStyle(),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          getSelectedStatusWidget(
                            status == AgentStatus.available,
                            AgentStatus.available,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          getSelectedStatusWidget(
                            status == AgentStatus.away,
                            AgentStatus.away,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          getSelectedStatusWidget(
                            status == AgentStatus.offline,
                            AgentStatus.offline,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              isSetStatus = !isSetStatus;
                              setState(() {});
                            },
                            child: Icon(
                              Icons.cancel_presentation_outlined,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
