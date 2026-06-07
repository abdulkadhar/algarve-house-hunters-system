import 'dart:convert';
import 'dart:html' as html;
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/option_label_selector_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/toggle_switch_widget.dart';
import 'package:algarve_house_hunters_system/agent_customer_property_allocation_screen/widgets/user_preference_values_display_widget.dart';
import 'package:algarve_house_hunters_system/agent_dashboard_screen/widgets/agent_quick_action_widget.dart';
import 'package:algarve_house_hunters_system/agent_listing_screen/widgets/add_more_button.dart';
import 'package:algarve_house_hunters_system/agent_onboarding_document_screen/widgets/file_content_tile.dart';
import 'package:algarve_house_hunters_system/api_controller.dart';
import 'package:algarve_house_hunters_system/assets_controller.dart';
import 'package:algarve_house_hunters_system/break_points.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_password_text_form_field.dart';
import 'package:algarve_house_hunters_system/global_widgets/manager_bottom_nav_bar.dart';
import 'package:algarve_house_hunters_system/global_widgets/custom_text_form_filed.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_main_logo_section.dart';
import 'package:algarve_house_hunters_system/global_widgets/dashboard_option_selector.dart';
import 'package:algarve_house_hunters_system/global_widgets/submit_button.dart';
import 'package:algarve_house_hunters_system/manager_agent_info_section_secreen/controller/manager_agent_info_section_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_dashboard_screen/widgets/manager_info_widget.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ManagerAgentInfoSectionScreen extends StatefulWidget {
  final String? agentId;
  const ManagerAgentInfoSectionScreen({
    super.key,
    this.agentId,
  });

  @override
  State<ManagerAgentInfoSectionScreen> createState() =>
      _ManagerAgentInfoSectionScreenState();
}

class _ManagerAgentInfoSectionScreenState
    extends State<ManagerAgentInfoSectionScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AgentInoOption optionData = AgentInoOption.agentInfo;
  ManagerDashboardOption dashboardOption = ManagerDashboardOption.agents;
  Map<String, dynamic>? filesData;
  void changeDashboardOption(ManagerDashboardOption option) {
    dashboardOption = option;
    setState(() {});
  }

  void changeAgentOption(AgentInoOption data) {
    optionData = data;
    setState(() {});
  }

  List<dynamic>? agentData;
  String currentAgentId = '';
  Map<String, dynamic>? selectedAgent;
  Map<String, dynamic>? currentUserChecklist;
  List<dynamic>? assignedClients;

  // void getCurrentUserCheckListData(String agent_id) async {
  //   await ApiController.getAllCheckListDataById(
  //     agent_id,
  //     onSuccess: (data) {
  //       currentUserChecklist = jsonDecode(data);
  //       setState(() {});
  //     },
  //     onError: (data) {
  //       print("CHECKLIST DATA ERROR: ");
  //     },
  //   );
  // }

  // SECTION - Profile state
  bool profileInformationReadOnly = true;
  bool contactInformationReadOnly = true;
  bool securityInformationReadOnly = true;

  String newPasswordHolder = '';
  String reEnterPasswordHolder = '';

  Map<String, dynamic> personalInformationData = {
    "agent_id": "",
    "agent_name": "",
    "agent_phone_number": "",
    "agent_location_name": "",
    "agent_description": "",
    "agent_designation": ""
  };

  Map<String, dynamic> contactInformationData = {
    "agent_id": "",
    "agent_email_address": ""
  };

  Map<String, dynamic> securityInformationData = {
    "agent_id": "",
    "agent_password": ""
  };

  void setProfileReadOnly(bool value) {
    profileInformationReadOnly = value;
    setState(() {});
  }

  void setContactReadOnly(bool value) {
    contactInformationReadOnly = value;
    setState(() {});
  }

  void setSecurityReadOnly(bool value) {
    securityInformationReadOnly = value;
    setState(() {});
  }

  Widget getButtonWidget({
    required VoidCallback onTap,
    required String buttonLabel,
    required Color buttonColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: buttonColor,
          ),
        ),
        child: Text(
          buttonLabel,
          style: ThemeController.smallTextStyle(
            color: buttonColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  //!SECTION

  void getAgentData() async {
    print("INFO:getting in agents details ");
    await ApiController.getAllAgentData(
      onSuccess: (responseData) {
        agentData = jsonDecode(responseData) as List<dynamic>;
        currentAgentId = agentData![0]['agent_id'];
        selectedAgent = agentData![0];
        assignedClients = null;
        setState(() {});
        setAgentId();
      },
      onError: (errorData) {
        print("Agent Data: Error has occured !!!");
      },
    );
  }

  void getAllFiles() async {
    await ApiController.getAllOnBoardingDocuments(
      onSuccess: (documentData) {
        final data = jsonDecode(documentData);
        filesData = data;
        setState(() {});
      },
      onError: (errorData) {
        print("Manager Documents Loading: Error ");
      },
    );
  }

  void setAgentId() {
    print("INFO:entering the set agent id");
    if (widget.agentId != null && agentData != null) {
      print("agent id: ${widget.agentId}");
      currentAgentId = widget.agentId!;
      for (int i = 0; i < agentData!.length; i++) {
        if (agentData![i]["agent_id"] == widget.agentId) {
          currentAgentId = agentData![i]['agent_id'];
          selectedAgent = agentData![i];
          assignedClients = null;
        }
      }
      setState(() {});
    }
  }

  Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text(
            'Do you wish to proceed with deleting the agent?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // close dialog
                onConfirm(); // execute delete action
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getAgentData();
    getAllFiles();

    super.initState();
  }

  // NOTE Mobile header banner with drawer (menu) trigger.
  Widget getMobileHeaderBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            icon: const Icon(Icons.menu, color: Colors.white),
          ),
          Image.asset(
            AssetsController.mainLogoPath,
            height: 48,
            width: 48,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Algarve House Hunters",
              style: ThemeController.normalTextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ManagerInfoWidget(
            onProfilePress: () {},
            managerId: 'MNG-BLR-20250625-0001',
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _agentDrawerTile({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.grey.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black),
            const SizedBox(width: 16),
            Text(
              label,
              style: ThemeController.normalTextStyle(
                fontWeight: selected ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMobileDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 4),
              child: Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                "AGENT OPTIONS",
                style: ThemeController.smallTextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w800,
                  size: 12,
                ),
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                children: [
                  _agentDrawerTile(
                    icon: Icons.info_outline,
                    label: 'Agent Info',
                    selected: optionData == AgentInoOption.agentInfo,
                    onTap: () {
                      changeAgentOption(AgentInoOption.agentInfo);
                      Navigator.pop(context);
                    },
                  ),
                  _agentDrawerTile(
                    icon: Icons.description_outlined,
                    label: 'Documents',
                    selected:
                        optionData == AgentInoOption.onboardingDocument,
                    onTap: () {
                      changeAgentOption(AgentInoOption.onboardingDocument);
                      Navigator.pop(context);
                    },
                  ),
                  _agentDrawerTile(
                    icon: Icons.badge_outlined,
                    label: 'Assigned Clients',
                    selected: optionData == AgentInoOption.assignedClients,
                    onTap: () async {
                      Navigator.pop(context);
                      if (selectedAgent != null &&
                          selectedAgent!['agent_id'] != '') {
                        await ApiController.assignedClients(
                          selectedAgent!['agent_id'],
                          onSuccess: (data) {
                            assignedClients = jsonDecode(data);
                            setState(() {});
                          },
                          onError: (data) {},
                        );
                      }
                      changeAgentOption(AgentInoOption.assignedClients);
                    },
                  ),
                  _agentDrawerTile(
                    icon: Icons.edit_outlined,
                    label: 'Edit Profile',
                    selected: optionData == AgentInoOption.profileEdit,
                    onTap: () {
                      changeAgentOption(AgentInoOption.profileEdit);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMobileAgentList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "AGENT LIST",
              style: ThemeController.smallTextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w800,
                size: 12,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () => context.go('/manager-agent-onboarding'),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (agentData == null)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: Colors.black),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                dropdownColor: Colors.white,
                value: currentAgentId.isEmpty ? null : currentAgentId,
                hint: Text(
                  "Select an agent",
                  style: ThemeController.normalTextStyle(
                    color: Colors.grey.shade500,
                    size: 14,
                  ),
                ),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: agentData!.map<DropdownMenuItem<String>>((agent) {
                  return DropdownMenuItem<String>(
                    value: agent['agent_id'].toString(),
                    child: Text(
                      (agent['agent_name'] ?? '').toString(),
                      style: ThemeController.normalTextStyle(
                        fontWeight: FontWeight.w700,
                        size: 14,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  final agent = agentData!.firstWhere(
                    (a) => a['agent_id'].toString() == value,
                  );
                  currentAgentId = value;
                  selectedAgent = agent;
                  changeAgentOption(AgentInoOption.agentInfo);
                  setState(() {});
                },
              ),
            ),
          ),
      ],
    );
  }

  String _agentInitials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Widget _agentInfoField(String label, String value,
      {bool isMultiline = false}) {
    final bool isEmpty = value.trim().isEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: ThemeController.smallTextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w700,
              size: 12,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(isMultiline ? 16 : 30),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              isEmpty ? 'Not assigned' : value,
              style: ThemeController.normalTextStyle(
                color: isEmpty ? Colors.grey.shade400 : Colors.black,
                fontWeight: FontWeight.w600,
                size: 15,
              ),
              maxLines: isMultiline ? null : 1,
              overflow: isMultiline ? TextOverflow.clip : TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget getMobileAgentInfo() {
    if (selectedAgent == null) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            "Select an agent to view details",
            style: ThemeController.normalTextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }
    final agent = selectedAgent!;
    final String name = (agent['agent_name'] ?? '').toString();
    final String agentId = (agent['agent_id'] ?? '').toString();
    final String email = (agent['agent_email_address'] ?? '').toString();
    final String phone = (agent['agent_phone_number'] ?? '').toString();
    final String location = (agent['agent_location_name'] ?? '').toString();
    final String status = (agent['agent_status'] ?? '').toString();
    final String designation = (agent['agent_designation'] ?? '').toString();
    final String description = (agent['agent_description'] ?? '').toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // NOTE Profile card with initials avatar
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey.withOpacity(0.15),
                child: Text(
                  _agentInitials(name),
                  style: ThemeController.titleTextStyle(size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: ThemeController.titleTextStyle(size: 20),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ID: $agentId",
                      style: ThemeController.smallTextStyle(
                        color: Colors.grey.shade600,
                        size: 12,
                      ),
                    ),
                    if (status.trim().isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: ThemeController.smallTextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w800,
                            size: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _agentInfoField('Agent ID', agentId),
        _agentInfoField('Agent Name', name),
        _agentInfoField('Agent Email Address', email),
        _agentInfoField('Agent Phone Number', phone),
        _agentInfoField('Agent Location', location),
        _agentInfoField('Agent Status', status),
        _agentInfoField(
          'Agent Designation',
          designation.trim().isEmpty ? 'Real Estate Agent' : designation,
        ),
        _agentInfoField(
          'Agent Description',
          description.trim().isEmpty
              ? 'Experienced agent supporting clients across the Algarve property market.'
              : description,
          isMultiline: true,
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () {
            showDeleteConfirmationDialog(
              context: context,
              onConfirm: () {
                ApiController.deleteAgentData(
                  currentAgentId,
                  onSuccess: (response) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Agent deleted successfully'),
                      ),
                    );
                    html.window.location.reload();
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error deleting agent: $error')),
                    );
                  },
                );
              },
            );
          },
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.red),
            ),
            child: Text(
              "DELETE AGENT",
              style: ThemeController.normalTextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // NOTE Mobile Documents section.
  Widget _documentCard(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.withOpacity(0.15),
              child: const Icon(
                Icons.description_outlined,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                  size: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              onTap: () async {
                await ApiController.downloadFileWeb(title);
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.download,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getMobileDocuments() {
    if (selectedAgent == null) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            "Select an agent to view documents",
            style: ThemeController.normalTextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }
    if (filesData == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(color: Colors.black),
        ),
      );
    }
    final List docs = (filesData!['documents-list'] as List?) ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Documents",
              style: ThemeController.titleTextStyle(),
            ),
            const Spacer(),
            Text(
              "${docs.length} Files Total",
              style: ThemeController.smallTextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w700,
                size: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // NOTE Completion status (updated by the agent) — read only here.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Text(
                "Completed",
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              ToggleSwitchWidget(
                isEnabled: false,
                isOn: selectedAgent!['agent_status'] != 'profile-created',
                onToggle: (data) {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (docs.isEmpty)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              "No documents available",
              style: ThemeController.normalTextStyle(color: Colors.grey.shade600),
            ),
          )
        else
          ...docs.map<Widget>(
            (doc) => _documentCard((doc['document_title'] ?? '').toString()),
          ),
      ],
    );
  }

  // NOTE Mobile Assigned Clients section.
  Future<void> _unAssignClient(String clientId) async {
    ManagerLogInScreenController.showLoaderDialog(context);
    await ApiController.unAssignAgent(
      agentId: selectedAgent!['agent_id'],
      clientId: clientId,
      onSuccess: (resData) {
        ManagerLogInScreenController.showSuccess(
          context,
          'Client has been un assigned.',
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) {
            context.push(
                '/manager-agent-info-section-screens/${selectedAgent!['agent_id']}');
          }
        });
      },
      onError: (errData) {
        ManagerLogInScreenController.hideDialogBox(context);
        ManagerLogInScreenController.showError(context, jsonDecode(errData));
      },
    );
  }

  Widget _assignedClientCard(Map<String, dynamic> client) {
    final String ref = (client['client_id'] ?? '').toString();
    final String name = (client['client_name'] ?? '').toString();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "REF: $ref",
              style: ThemeController.smallTextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w700,
                size: 12,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: ThemeController.titleTextStyle(size: 20),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: () => _unAssignClient(ref),
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cancel_outlined,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "Un Assign",
                      style: ThemeController.normalTextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        size: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _onboardingPendingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey.withOpacity(0.15),
            child: Icon(
              Icons.assignment_turned_in_outlined,
              color: Colors.grey.shade700,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Onboarding Pending",
            style: ThemeController.titleTextStyle(size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            "Complete the onboarding document section to get assigned by clients",
            textAlign: TextAlign.center,
            style: ThemeController.normalTextStyle(
              color: Colors.grey.shade600,
              size: 14,
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () => changeAgentOption(AgentInoOption.onboardingDocument),
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                "Complete Onboarding",
                style: ThemeController.normalTextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () => changeAgentOption(AgentInoOption.onboardingDocument),
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: Text(
                "View Requirements",
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getMobileAssignedClients() {
    if (selectedAgent == null) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            "Select an agent to view assigned clients",
            style: ThemeController.normalTextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }
    // Onboarding not complete → pending state.
    if (selectedAgent!['agent_status'] == 'profile-created') {
      return _onboardingPendingCard();
    }
    final List clients = assignedClients ?? const [];
    if (clients.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            "No clients assigned yet",
            style: ThemeController.normalTextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...clients.map<Widget>(
          (client) => _assignedClientCard(client as Map<String, dynamic>),
        ),
      ],
    );
  }

  // NOTE Mobile Edit Profile section — one field per row with Edit/Discard.
  Widget getMobileProfileEdit() {
    if (selectedAgent == null) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            "Select an agent to edit profile",
            style: ThemeController.normalTextStyle(color: Colors.grey.shade600),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // NOTE Profile information
        Row(
          children: [
            Expanded(
              child: Text(
                "Profile information",
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                  size: 16,
                ),
              ),
            ),
            getButtonWidget(
              onTap: () => setProfileReadOnly(!profileInformationReadOnly),
              buttonLabel: profileInformationReadOnly
                  ? 'Edit personal information'
                  : 'Discard',
              buttonColor:
                  profileInformationReadOnly ? Colors.black : Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextFormFiled(
          labelName: 'Name',
          placeholderText: '',
          initialValue: selectedAgent!['agent_name'],
          readOnly: profileInformationReadOnly,
          onChanged: (data) {
            if (data.isNotEmpty) {
              personalInformationData["agent_name"] = data;
              setState(() {});
            }
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormFiled(
          labelName: 'Phone number',
          placeholderText: '',
          initialValue: selectedAgent!['agent_phone_number'],
          isMandatory: false,
          readOnly: profileInformationReadOnly,
          onChanged: (data) {
            if (data.isNotEmpty) {
              personalInformationData["agent_phone_number"] = data;
              setState(() {});
            }
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormFiled(
          labelName: 'Location name',
          placeholderText: '',
          initialValue: selectedAgent!['agent_location_name'],
          isMandatory: false,
          readOnly: profileInformationReadOnly,
          onChanged: (data) {
            if (data.isNotEmpty) {
              personalInformationData["agent_location_name"] = data;
              setState(() {});
            }
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormFiled(
          labelName: 'Agent description',
          placeholderText: '',
          initialValue: selectedAgent!['agent_description'],
          isMandatory: false,
          readOnly: profileInformationReadOnly,
          onChanged: (data) {
            if (data.isNotEmpty) {
              personalInformationData["agent_description"] = data;
              setState(() {});
            }
          },
        ),
        const SizedBox(height: 16),
        CustomTextFormFiled(
          labelName: 'Designation',
          placeholderText: '',
          initialValue: selectedAgent!['agent_designation'],
          isMandatory: false,
          readOnly: profileInformationReadOnly,
          onChanged: (data) {
            if (data.isNotEmpty) {
              personalInformationData["agent_designation"] = data;
              setState(() {});
            }
          },
        ),
        if (!profileInformationReadOnly) ...[
          const SizedBox(height: 20),
          SubmitButton(
            onButtonPress: () async {
              if (selectedAgent!['agent_id'] != null) {
                personalInformationData['agent_id'] =
                    selectedAgent!['agent_id'];
              }
              ManagerLogInScreenController.showLoaderDialog(context);
              await ApiController.updateAgentProfileInformation(
                personalInformationData,
                onSuccess: (resData) {
                  ManagerLogInScreenController.showSuccess(
                    context,
                    'Profile information has been updated',
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    html.window.location.reload();
                  });
                },
                onError: (errData) {
                  ManagerLogInScreenController.hideDialogBox(context);
                  ManagerLogInScreenController.showError(
                      context, jsonDecode(errData));
                },
              );
            },
            buttonLabel: 'Save changes',
          ),
        ],
        const SizedBox(height: 28),
        // NOTE Contact information
        Row(
          children: [
            Expanded(
              child: Text(
                "Contact information",
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                  size: 16,
                ),
              ),
            ),
            getButtonWidget(
              onTap: () => setContactReadOnly(!contactInformationReadOnly),
              buttonLabel: contactInformationReadOnly
                  ? 'Edit contact information'
                  : 'Discard',
              buttonColor:
                  contactInformationReadOnly ? Colors.black : Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomTextFormFiled(
          labelName: 'Email',
          placeholderText: '',
          initialValue: selectedAgent!['agent_email_address'],
          readOnly: contactInformationReadOnly,
          isMandatory: true,
          onChanged: (data) {
            if (data.isNotEmpty) {
              contactInformationData["agent_email_address"] = data;
              setState(() {});
            }
          },
        ),
        if (!contactInformationReadOnly) ...[
          const SizedBox(height: 20),
          SubmitButton(
            onButtonPress: () async {
              if (selectedAgent!['agent_id'] != null) {
                contactInformationData['agent_id'] = selectedAgent!['agent_id'];
              }
              ManagerLogInScreenController.showLoaderDialog(context);
              await ApiController.updateAgentContactInformation(
                contactInformationData,
                onSuccess: (resData) {
                  ManagerLogInScreenController.showSuccess(
                    context,
                    'Contact information has been updated',
                  );
                  Future.delayed(const Duration(seconds: 2), () {
                    html.window.location.reload();
                  });
                },
                onError: (errData) {
                  ManagerLogInScreenController.hideDialogBox(context);
                  ManagerLogInScreenController.showError(
                      context, jsonDecode(errData));
                },
              );
            },
            buttonLabel: 'Save changes',
          ),
        ],
        const SizedBox(height: 28),
        // NOTE Security information
        Row(
          children: [
            Expanded(
              child: Text(
                "Security information",
                style: ThemeController.normalTextStyle(
                  fontWeight: FontWeight.w900,
                  size: 16,
                ),
              ),
            ),
            getButtonWidget(
              onTap: () => setSecurityReadOnly(!securityInformationReadOnly),
              buttonLabel: securityInformationReadOnly
                  ? 'Update password'
                  : 'Discard',
              buttonColor:
                  securityInformationReadOnly ? Colors.black : Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 16),
        CustomPasswordTextField(
          labelName: 'New password',
          placeholderText: '',
          isMandatory: true,
          readOnly: securityInformationReadOnly,
          onChanged: (data) {
            if (data != null && data != '') {
              newPasswordHolder = data;
            }
          },
        ),
        const SizedBox(height: 16),
        CustomPasswordTextField(
          labelName: 'Re-enter password',
          placeholderText: '',
          isMandatory: true,
          readOnly: securityInformationReadOnly,
          onChanged: (data) {
            if (data != null && data != '') {
              reEnterPasswordHolder = data;
            }
          },
        ),
        if (!securityInformationReadOnly) ...[
          const SizedBox(height: 20),
          SubmitButton(
            onButtonPress: () async {
              if (newPasswordHolder != reEnterPasswordHolder) {
                ManagerLogInScreenController.showError(
                    context, 'Both the password must be same !!');
              } else if (newPasswordHolder == '' ||
                  reEnterPasswordHolder == '') {
                ManagerLogInScreenController.showError(
                    context, 'password value cannot be empty!!');
              } else {
                securityInformationData['agent_password'] = newPasswordHolder;
                if (selectedAgent!['agent_id'] != null) {
                  securityInformationData['agent_id'] =
                      selectedAgent!['agent_id'];
                }
                ManagerLogInScreenController.showLoaderDialog(context);
                await ApiController.updateAgentProfilePassword(
                  securityInformationData,
                  onSuccess: (resData) async {
                    ManagerLogInScreenController.showSuccess(
                      context,
                      'Password has been updated. Please login again.',
                    );
                    Future.delayed(const Duration(seconds: 2), () {
                      if (!mounted) return;
                      html.window.location.reload();
                    });
                  },
                  onError: (errData) {
                    ManagerLogInScreenController.hideDialogBox(context);
                    ManagerLogInScreenController.showError(
                        context, jsonDecode(errData));
                  },
                );
              }
            },
            buttonLabel: 'Save changes',
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile =
        MediaQuery.of(context).size.width < Breakpoints.mobile;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: ThemeController.pageBackgroundColor,
      drawer: isMobile ? getMobileDrawer() : null,
      bottomNavigationBar: isMobile
          ? const ManagerBottomNavBar(
              currentOption: ManagerDashboardOption.agents,
            )
          : null,
      body: isMobile
          ? SingleChildScrollView(
              child: Column(
                children: [
                  getMobileHeaderBanner(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getMobileAgentList(),
                        const SizedBox(height: 20),
                        optionData == AgentInoOption.agentInfo
                            ? getMobileAgentInfo()
                            : optionData ==
                                    AgentInoOption.onboardingDocument
                                ? getMobileDocuments()
                                : optionData ==
                                        AgentInoOption.assignedClients
                                    ? getMobileAssignedClients()
                                    : optionData ==
                                            AgentInoOption.profileEdit
                                        ? getMobileProfileEdit()
                                        : getAgentContentArea(showTabs: false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const DashboardMainLogoSection(),
                  const Spacer(),
                  Row(
                    children: [
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.dashboard,
                        iconData: Icons.dashboard,
                        optionLabel: 'Dashboard',
                        onTap: () {
                          context.go(
                            '/manager-dashboard-screen',
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.listings,
                        iconData: Icons.list,
                        optionLabel: 'Listings',
                        onTap: () {
                          changeDashboardOption(
                            ManagerDashboardOption.listings,
                          );
                          context.go('/manager-property-management-screen');
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.agents,
                        iconData: Icons.support_agent,
                        optionLabel: 'Agents',
                        onTap: () {
                          context.go(
                            '/manager-client-info-screen/CLT-BLR-20221117-0001/basicInfo',
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DashboardOptionSelector(
                        isEnabled:
                            dashboardOption == ManagerDashboardOption.clients,
                        iconData: Icons.dashboard_customize_rounded,
                        optionLabel: 'Clients',
                        onTap: () {
                          context.go(
                              '/manager-client-info-screen/CLT-BLR-20221117-0001/basicInfo');
                        },
                      ),
                    ],
                  ),
                  const Spacer(),
                  ManagerInfoWidget(
                    onProfilePress: () {},
                    managerId: 'MNG-BLR-20250625-0001',
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.86,
                    decoration: BoxDecoration(
                      color: ThemeController.pageBackgroundSecondaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.all(15),
                      children: [
                        Row(
                          children: [
                            Text(
                              'Agent list',
                              style: ThemeController.normalTextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                context.go(
                                  '/manager-agent-onboarding',
                                );
                              },
                              child: const Icon(
                                Icons.add,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (agentData == null)
                          const Center(
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        if (agentData != null)
                          Column(
                            children: List.generate(
                              agentData!.length,
                              (index) => AgentQuickActionWidget(
                                userData: agentData![index],
                                isSelected: agentData![index]['agent_id'] ==
                                    currentAgentId,
                                onProfilePress: () {
                                  currentAgentId =
                                      agentData![index]['agent_id'];
                                  selectedAgent = agentData![index];
                                  changeAgentOption(AgentInoOption.agentInfo);
                                  print("INFO:option data: ${optionData}");
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  // NOTE Empty Space
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.01,
                  ),
                  Expanded(
                    child: getAgentContentArea(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget getAgentContentArea({bool showTabs = true}) {
    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: ThemeController.pageBackgroundSecondaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          if (showTabs)
                            Row(
                            children: [
                              OptionLabelSelectorWidget(
                                isEnabled:
                                    optionData == AgentInoOption.agentInfo,
                                onPress: () {
                                  changeAgentOption(AgentInoOption.agentInfo);
                                },
                                optionLabel: 'Agent Info',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentInoOption.onboardingDocument,
                                onPress: () {
                                  changeAgentOption(
                                    AgentInoOption.onboardingDocument,
                                  );
                                },
                                optionLabel: 'On boarding documents',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled:
                                    optionData == AgentInoOption.agentCheckList,
                                onPress: () {
                                  // if (selectedAgent != null) {
                                  //   getCurrentUserCheckListData(
                                  //       selectedAgent!['agent_id']);
                                  // }
                                  changeAgentOption(
                                      AgentInoOption.agentCheckList);
                                },
                                optionLabel: 'Check list',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                isEnabled: optionData ==
                                    AgentInoOption.assignedClients,
                                onPress: () async {
                                  if (selectedAgent != null &&
                                      selectedAgent!['agent_id'] != '') {
                                    await ApiController.assignedClients(
                                      selectedAgent!['agent_id'],
                                      onSuccess: (data) {
                                        assignedClients = jsonDecode(data);
                                        setState(() {});
                                      },
                                      onError: (data) {},
                                    );
                                  }
                                  changeAgentOption(
                                      AgentInoOption.assignedClients);
                                },
                                optionLabel: 'Assigned Clients',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              OptionLabelSelectorWidget(
                                enabledTextColor: Colors.green,
                                enabledBorderColor: Colors.green,
                                disabledBorderColor: Colors.green,
                                disabledTextColor: Colors.green,
                                isEnabled:
                                    optionData == AgentInoOption.profileEdit,
                                onPress: () {
                                  changeAgentOption(AgentInoOption.profileEdit);
                                },
                                optionLabel: 'Edit Profile',
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  showDeleteConfirmationDialog(
                                    context: context,
                                    onConfirm: () {
                                      ApiController.deleteAgentData(
                                        currentAgentId,
                                        onSuccess: (response) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Agent deleted successfully',
                                              ),
                                            ),
                                          );
                                          html.window.location.reload();
                                        },
                                        onError: (error) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error deleting agent: $error')),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.red,
                                    ),
                                  ),
                                  child: Text(
                                    "Delete Agent",
                                    style: ThemeController.smallTextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (optionData == AgentInoOption.agentInfo &&
                              selectedAgent != null)
                            Column(
                              children: [
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent Id',
                                  labelValue: selectedAgent!['agent_id'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent Name',
                                  labelValue: selectedAgent!['agent_name'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent email address',
                                  labelValue:
                                      selectedAgent!['agent_email_address'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent phone number',
                                  labelValue:
                                      selectedAgent!['agent_phone_number'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent location',
                                  labelValue:
                                      selectedAgent!['agent_location_name'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent Status',
                                  labelValue: selectedAgent!['agent_status'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent Designation',
                                  labelValue:
                                      selectedAgent!['agent_designation'],
                                ),
                                const SizedBox(height: 10),
                                UserPreferenceValuesDisplayWidget(
                                  labelName: 'Agent Description',
                                  labelValue:
                                      selectedAgent!['agent_description'],
                                ),
                              ],
                            ),
                          if (optionData == AgentInoOption.profileEdit)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Profile information",
                                      style: ThemeController.normalTextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Spacer(),
                                    getButtonWidget(
                                      onTap: () {
                                        setProfileReadOnly(
                                            !profileInformationReadOnly);
                                      },
                                      buttonLabel: profileInformationReadOnly
                                          ? 'Edit personal information'
                                          : 'Discard',
                                      buttonColor: Colors.black,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        width: 200,
                                        child: CustomTextFormFiled(
                                          labelName: 'Name',
                                          placeholderText: '',
                                          initialValue:
                                              selectedAgent!['agent_name'],
                                          readOnly: profileInformationReadOnly,
                                          onChanged: (data) {
                                            if (data != null && data != '') {
                                              personalInformationData[
                                                  "agent_name"] = data;
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        width: 200,
                                        child: CustomTextFormFiled(
                                          labelName: 'Phone number',
                                          placeholderText: '',
                                          initialValue: selectedAgent![
                                              'agent_phone_number'],
                                          isMandatory: false,
                                          readOnly: profileInformationReadOnly,
                                          onChanged: (data) {
                                            if (data != null && data != '') {
                                              personalInformationData[
                                                  "agent_phone_number"] = data;
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        child: CustomTextFormFiled(
                                          labelName: 'Location name',
                                          placeholderText: '',
                                          initialValue: selectedAgent![
                                              'agent_location_name'],
                                          readOnly: profileInformationReadOnly,
                                          isMandatory: false,
                                          onChanged: (data) {
                                            if (data != null && data != '') {
                                              personalInformationData[
                                                  "agent_location_name"] = data;
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        child: CustomTextFormFiled(
                                          labelName: 'Agent description',
                                          placeholderText: '',
                                          initialValue: selectedAgent![
                                              'agent_description'],
                                          isMandatory: false,
                                          readOnly: profileInformationReadOnly,
                                          onChanged: (data) {
                                            if (data != null && data != '') {
                                              personalInformationData[
                                                  "agent_description"] = data;
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        child: CustomTextFormFiled(
                                          labelName: 'Designation',
                                          placeholderText: '',
                                          initialValue: selectedAgent![
                                              'agent_designation'],
                                          readOnly: profileInformationReadOnly,
                                          isMandatory: false,
                                          onChanged: (data) {
                                            if (data != null && data != '') {
                                              personalInformationData[
                                                  "agent_designation"] = data;
                                              setState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                  ],
                                ),
                                if (!profileInformationReadOnly)
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: SubmitButton(
                                          onButtonPress: () async {
                                            if (selectedAgent!['agent_id'] !=
                                                null) {
                                              personalInformationData[
                                                      'agent_id'] =
                                                  selectedAgent!['agent_id'];
                                            }
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .updateAgentProfileInformation(
                                                    personalInformationData,
                                                    onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(
                                                context,
                                                'Profile information has been updated',
                                              );
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  html.window.location.reload();
                                                },
                                              );
                                            }, onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(context,
                                                      jsonDecode(errData));
                                            });
                                          },
                                          buttonLabel: 'Save changes',
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Contact information",
                                      style: ThemeController.normalTextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Spacer(),
                                    const Spacer(),
                                    getButtonWidget(
                                      onTap: () {
                                        setContactReadOnly(
                                            !contactInformationReadOnly);
                                      },
                                      buttonLabel: contactInformationReadOnly
                                          ? 'Edit contact information'
                                          : 'Discard',
                                      buttonColor: contactInformationReadOnly
                                          ? Colors.black
                                          : Colors.red,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        child: CustomTextFormFiled(
                                            labelName: 'Email',
                                            placeholderText: '',
                                            initialValue: selectedAgent![
                                                'agent_email_address'],
                                            readOnly:
                                                contactInformationReadOnly,
                                            isMandatory: true,
                                            onChanged: (data) {
                                              if (data != null && data != '') {
                                                contactInformationData[
                                                        "agent_email_address"] =
                                                    data;
                                                setState(() {});
                                              }
                                            }),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: SizedBox(),
                                    ),
                                  ],
                                ),
                                if (!contactInformationReadOnly)
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: SubmitButton(
                                          onButtonPress: () async {
                                            if (selectedAgent!['agent_id'] !=
                                                null) {
                                              contactInformationData[
                                                      'agent_id'] =
                                                  selectedAgent!['agent_id'];
                                            }
                                            ManagerLogInScreenController
                                                .showLoaderDialog(context);
                                            await ApiController
                                                .updateAgentContactInformation(
                                                    contactInformationData,
                                                    onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(
                                                context,
                                                'Contact information has been updated',
                                              );
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  html.window.location.reload();
                                                },
                                              );
                                            }, onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(context,
                                                      jsonDecode(errData));
                                            });
                                          },
                                          buttonLabel: 'Save changes',
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Security information",
                                      style: ThemeController.normalTextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Spacer(),
                                    const Spacer(),
                                    getButtonWidget(
                                      onTap: () {
                                        setSecurityReadOnly(
                                            !securityInformationReadOnly);
                                      },
                                      buttonLabel: 'Update password',
                                      buttonColor: Colors.black,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        child: CustomPasswordTextField(
                                          labelName: 'New password',
                                          placeholderText: '',
                                          isMandatory: true,
                                          readOnly: securityInformationReadOnly,
                                          onChanged: (data) {
                                            if (data != null && data != '') {
                                              newPasswordHolder = data;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        child: CustomPasswordTextField(
                                          labelName: 'Re-enter password',
                                          placeholderText: '',
                                          isMandatory: true,
                                          readOnly: securityInformationReadOnly,
                                          onChanged: (data) {
                                            if (data != null && data != '') {
                                              reEnterPasswordHolder = data;
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (!securityInformationReadOnly)
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: SubmitButton(
                                          onButtonPress: () async {
                                            if (newPasswordHolder !=
                                                reEnterPasswordHolder) {
                                              ManagerLogInScreenController
                                                  .showError(context,
                                                      'Both the password must be same !!');
                                            } else if (newPasswordHolder ==
                                                    '' ||
                                                reEnterPasswordHolder == '') {
                                              ManagerLogInScreenController
                                                  .showError(context,
                                                      'password value cannot be empty!!');
                                            } else {
                                              securityInformationData[
                                                      'agent_password'] =
                                                  newPasswordHolder;
                                              if (selectedAgent!['agent_id'] !=
                                                  null) {
                                                securityInformationData[
                                                        'agent_id'] =
                                                    selectedAgent!['agent_id'];
                                              }
                                              ManagerLogInScreenController
                                                  .showLoaderDialog(context);
                                              await ApiController
                                                  .updateAgentProfilePassword(
                                                      securityInformationData,
                                                      onSuccess:
                                                          (resData) async {
                                                ManagerLogInScreenController
                                                    .showSuccess(
                                                  context,
                                                  'Password has been updated. Please login again.',
                                                );
                                                Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                    if (!mounted) return;

                                                    html.window.location
                                                        .reload();
                                                  },
                                                );
                                              }, onError: (errData) {
                                                ManagerLogInScreenController
                                                    .hideDialogBox(context);
                                                ManagerLogInScreenController
                                                    .showError(context,
                                                        jsonDecode(errData));
                                              });
                                            }
                                          },
                                          buttonLabel: 'Save changes',
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          // TODO Need work on this
                          if (optionData == AgentInoOption.assignedClients &&
                              selectedAgent != null)
                            selectedAgent!['agent_status'] == "profile-created"
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.pending_actions_sharp,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          'Complete the onboarding document section to get assigned by clients'),
                                    ],
                                  )
                                : SizedBox.shrink(),
                          // NOTE Onboarding Section
                          if (optionData == AgentInoOption.onboardingDocument &&
                              filesData != null &&
                              selectedAgent != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "On Boarding Documents",
                                      style: ThemeController.normalTextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Spacer(),
                                    ToggleSwitchWidget(
                                      isEnabled: false,
                                      isOn: selectedAgent!['agent_status'] !=
                                          'profile-created',
                                      onToggle: (data) {},
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  children: List.generate(
                                    filesData!['documents-list'].length,
                                    (index) => Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        FileContentTile(
                                          fileName: filesData!['documents-list']
                                              [index]['document_title'],
                                          onDownloadPress: () async {
                                            await ApiController.downloadFileWeb(
                                                filesData!['documents-list']
                                                    [index]['document_title']);
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          // NOTE - Check List Section
                          if (optionData == AgentInoOption.assignedClients &&
                              assignedClients != null &&
                              selectedAgent != null)
                            Column(
                              children: List.generate(
                                assignedClients!.length,
                                (index) => Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            assignedClients![index]
                                                ['client_id'],
                                          ),
                                          Text(
                                            assignedClients![index]
                                                ['client_name'],
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      AddMoreButton(
                                        onButtonPress: () async {
                                          ManagerLogInScreenController
                                              .showLoaderDialog(context);
                                          // NOTE  Un Assign
                                          await ApiController.unAssignAgent(
                                            agentId: selectedAgent!['agent_id'],
                                            clientId: assignedClients![index]
                                                ['client_id'],
                                            onSuccess: (resData) {
                                              ManagerLogInScreenController
                                                  .showSuccess(
                                                context,
                                                'Client has been un assigned.',
                                              );
                                              Future.delayed(
                                                const Duration(seconds: 2),
                                                () {
                                                  if (context.mounted) {
                                                    context.push(
                                                        '/manager-agent-info-section-screens/${selectedAgent!['agent_id']}');
                                                  }
                                                },
                                              );
                                            },
                                            onError: (errData) {
                                              ManagerLogInScreenController
                                                  .hideDialogBox(context);
                                              ManagerLogInScreenController
                                                  .showError(
                                                context,
                                                jsonDecode(errData),
                                              );
                                            },
                                          );
                                        },
                                        buttonLabel: 'Un Assign',
                                        iconData: Icons.cancel,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
    );
  }
}
