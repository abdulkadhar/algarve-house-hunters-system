import 'package:algarve_house_hunters_system/agent_dashboard_screen/controller/agent_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/manager_log_in_screen/controller/manager_log_in_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable bottom navigation bar for the agent section.
///
/// The options mirror the web header's navigation
/// (Dashboard, Listings, Onboarding, Client) so the experience stays
/// consistent across screens. Drop it into any agent screen's
/// [Scaffold.bottomNavigationBar] and pass the [currentOption] for that screen.
///
/// [agentInfo] and [assignedClients] are used to replicate the web header's
/// guards: the Listings and Client tabs are blocked (with an error message)
/// until onboarding is complete and at least one client is assigned.
class AgentBottomNavBar extends StatelessWidget {
  final AgentDashboardOption currentOption;
  final String agentId;
  final Map<String, dynamic>? agentInfo;
  final List<dynamic>? assignedClients;

  const AgentBottomNavBar({
    super.key,
    required this.currentOption,
    required this.agentId,
    this.agentInfo,
    this.assignedClients,
  });

  /// Returns true (and shows the matching error) when the agent is not yet
  /// allowed to open the Listings / Client sections.
  bool _guardBlocked(BuildContext context) {
    if (agentInfo != null && agentInfo!['agent_status'] == 'profile-created') {
      ManagerLogInScreenController.showError(context,
          'Please do complete the on boarding process in order to proceed to client section !!!');
      return true;
    } else if (assignedClients == null || assignedClients!.isEmpty) {
      ManagerLogInScreenController.showError(context,
          'No client has been assigned. Please do contact manager !!!');
      return true;
    }
    return false;
  }

  void _onTap(BuildContext context, AgentDashboardOption option) {
    if (option == currentOption) return;
    switch (option) {
      case AgentDashboardOption.dashboard:
        context.go('/agent-dashboard-screen/$agentId');
        break;
      case AgentDashboardOption.listings:
        if (_guardBlocked(context)) return;
        context.go('/agent-listing-screen/$agentId');
        break;
      case AgentDashboardOption.calendar:
        context.go(
            '/agent-onboarding-document-screen/${agentInfo?['agent_id'] ?? agentId}');
        break;
      case AgentDashboardOption.customer:
        if (_guardBlocked(context)) return;
        context.go('/agent-customer-property-allocation/$agentId');
        break;
      case AgentDashboardOption.actions:
        break;
    }
  }

  Widget _buildItem(
    BuildContext context, {
    required AgentDashboardOption option,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = option == currentOption;
    return Expanded(
      child: InkWell(
        onTap: () => _onTap(context, option),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: ThemeController.normalTextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                  size: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            _buildItem(
              context,
              option: AgentDashboardOption.dashboard,
              icon: Icons.dashboard,
              label: 'Dashboard',
            ),
            _buildItem(
              context,
              option: AgentDashboardOption.listings,
              icon: Icons.list,
              label: 'Listings',
            ),
            _buildItem(
              context,
              option: AgentDashboardOption.calendar,
              icon: Icons.document_scanner,
              label: 'Onboarding',
            ),
            _buildItem(
              context,
              option: AgentDashboardOption.customer,
              icon: Icons.dashboard_customize_rounded,
              label: 'Client',
            ),
          ],
        ),
      ),
    );
  }
}
