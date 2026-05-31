import 'package:algarve_house_hunters_system/manager_dashboard_screen/controller/manager_dashboard_screen_controller.dart';
import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable bottom navigation bar for the manager section.
///
/// The options mirror the web version's navigation
/// (Dashboard, Listings, Agents, Clients) so the experience stays
/// consistent across screens. Drop it into any manager screen's
/// [Scaffold.bottomNavigationBar] and pass the [currentOption] for that screen.
class ManagerBottomNavBar extends StatelessWidget {
  final ManagerDashboardOption currentOption;

  /// Client id used for the Clients route. Defaults to the same id used by the
  /// web header so behaviour matches across the app.
  final String clientId;

  const ManagerBottomNavBar({
    super.key,
    required this.currentOption,
    this.clientId = 'CLT-BLR-20221117-0001',
  });

  void _onTap(BuildContext context, ManagerDashboardOption option) {
    if (option == currentOption) return;
    switch (option) {
      case ManagerDashboardOption.dashboard:
        context.go('/manager-dashboard-screen');
        break;
      case ManagerDashboardOption.listings:
        context.go('/manager-property-management-screen');
        break;
      case ManagerDashboardOption.agents:
        context.go('/manager-agent-info-section-screen');
        break;
      case ManagerDashboardOption.clients:
        context.go('/manager-client-info-screen/$clientId/basicInfo');
        break;
    }
  }

  Widget _buildItem(
    BuildContext context, {
    required ManagerDashboardOption option,
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
              option: ManagerDashboardOption.dashboard,
              icon: Icons.dashboard,
              label: 'Dashboard',
            ),
            _buildItem(
              context,
              option: ManagerDashboardOption.listings,
              icon: Icons.list,
              label: 'Listings',
            ),
            _buildItem(
              context,
              option: ManagerDashboardOption.agents,
              icon: Icons.support_agent,
              label: 'Agents',
            ),
            _buildItem(
              context,
              option: ManagerDashboardOption.clients,
              icon: Icons.dashboard_customize_rounded,
              label: 'Clients',
            ),
          ],
        ),
      ),
    );
  }
}
