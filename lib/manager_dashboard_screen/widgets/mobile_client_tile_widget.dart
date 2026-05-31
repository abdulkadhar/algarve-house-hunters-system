import 'package:algarve_house_hunters_system/theme_controller.dart';
import 'package:flutter/material.dart';

/// Client row used in the mobile "Clients" section.
///
/// Shows an initials avatar, the client's name and email, and a trailing
/// chevron, matching the dashboard mobile mockup.
class MobileClientTileWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onProfilePress;

  const MobileClientTileWidget({
    super.key,
    required this.userData,
    required this.onProfilePress,
  });

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String name = (userData["client_name"] ?? '').toString();
    final String email = (userData["client_email_address"] ?? '').toString();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onProfilePress,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.withOpacity(0.15),
                child: Text(
                  _initials(name),
                  style: ThemeController.normalTextStyle(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w800,
                    size: 14,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeController.normalTextStyle(
                        fontWeight: FontWeight.w800,
                        size: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: ThemeController.normalTextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w400,
                        size: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
