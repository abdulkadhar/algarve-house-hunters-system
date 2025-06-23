import 'package:algarve_house_hunters_system/customer_dashboard_screen/controller/customer_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/model/agent_model.dart';
import 'package:algarve_house_hunters_system/customer_dashboard_screen/widgets/agent_status_widget.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

class AgentUserInfoWidget extends StatefulWidget {
  final VoidCallback onProfilePress;
  final AgentModel agentData;
  const AgentUserInfoWidget({
    super.key,
    required this.onProfilePress,
    required this.agentData,
  });

  @override
  State<AgentUserInfoWidget> createState() => _AgentUserInfoWidgetState();
}

class _AgentUserInfoWidgetState extends State<AgentUserInfoWidget> {
  AgentStatus status = AgentStatus.available;
  bool isSetStatus = false;

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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onProfilePress,
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              widget.agentData.profileImgPath,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.agentData.agentName,
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                widget.agentData.agentDesignation,
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
