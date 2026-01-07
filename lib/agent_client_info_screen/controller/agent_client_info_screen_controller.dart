enum AgentClientInfoOption {
  basicInfo,
  preferenceInfo,
  agentInfo,
  clientChecklist,
}

class AgentClientInfoScreenController {
  static AgentClientInfoOption getAgentClientInfoOption(String type) {
    if (type == "basicInfo") {
      return AgentClientInfoOption.basicInfo;
    } else if (type == "preferenceInfo") {
      return AgentClientInfoOption.preferenceInfo;
    } else if (type == "agentInfo") {
      return AgentClientInfoOption.agentInfo;
    } else {
      return AgentClientInfoOption.clientChecklist;
    }
  }
}
