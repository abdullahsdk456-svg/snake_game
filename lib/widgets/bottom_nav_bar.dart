import 'package:flutter/material.dart';
import '../constants/colors.dart';

enum NavTab { game, rankings, settings, profile }

/// Shared bottom navigation bar across all screens
class NeonBottomNavBar extends StatelessWidget {
  final NavTab activeTab;
  final ValueChanged<NavTab>? onTabChanged;

  const NeonBottomNavBar({
    super.key,
    this.activeTab = NavTab.game,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        decoration: BoxDecoration(
          color: NeonColors.surfaceContainerLowest.withValues(alpha: 0.6),
          border: Border(
            top: BorderSide(color: NeonColors.glassBorder, width: 1),
          ),
        ),
        child: BackdropFilter(
          filter: ColorFilter.matrix([
            1, 0, 0, 0, 0,
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            0, 0, 0, 0.95, 0,
          ]),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.sports_esports_outlined,
                    label: 'GAME',
                    tab: NavTab.game,
                    activeTab: activeTab,
                    onTap: () => onTabChanged?.call(NavTab.game),
                  ),
                  _NavItem(
                    icon: Icons.leaderboard_outlined,
                    label: 'RANKS',
                    tab: NavTab.rankings,
                    activeTab: activeTab,
                    onTap: () => onTabChanged?.call(NavTab.rankings),
                  ),
                  _NavItem(
                    icon: Icons.settings_outlined,
                    label: 'CONFIG',
                    tab: NavTab.settings,
                    activeTab: activeTab,
                    onTap: () => onTabChanged?.call(NavTab.settings),
                  ),
                  _NavItem(
                    icon: Icons.person_outline,
                    label: 'AGENT',
                    tab: NavTab.profile,
                    activeTab: activeTab,
                    onTap: () => onTabChanged?.call(NavTab.profile),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final NavTab tab;
  final NavTab activeTab;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.tab,
    required this.activeTab,
    required this.onTap,
  });

  bool get isActive => tab == activeTab;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? NeonColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: NeonColors.primaryGlow.withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 24,
          color: isActive ? NeonColors.primary : NeonColors.outline,
        ),
      ),
    );
  }
}
