import 'package:flutter/material.dart';

import '../../../core/widgets/app_screen_bar.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/placeholder_destination.dart';

/// The School Administrator navigation container.
///
/// Same shared [AppShell] as the other roles, with the School Admin tab
/// set and placeholder destinations behind each tab.
class SchoolAdminShell extends StatefulWidget {
  const SchoolAdminShell({super.key});

  @override
  State<SchoolAdminShell> createState() => _SchoolAdminShellState();
}

class _SchoolAdminShellState extends State<SchoolAdminShell> {
  int _currentIndex = 0;

  static const List<AppNavItem> _tabs = [
    AppNavItem(
      label: 'Students',
      icon: Icons.groups_outlined,
      activeIcon: Icons.groups,
    ),
    AppNavItem(
      label: 'School',
      icon: Icons.school_outlined,
      activeIcon: Icons.school,
    ),
    AppNavItem(
      label: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  static const List<Widget> _destinations = [
    PlaceholderDestination(title: 'Students', icon: Icons.groups_outlined),
    PlaceholderDestination(title: 'School', icon: Icons.school_outlined),
    PlaceholderDestination(title: 'Profile', icon: Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    return AppShell(
      items: _tabs,
      currentIndex: _currentIndex,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      appBar: AppScreenBar.large(title: _tabs[_currentIndex].label),
      body: _destinations[_currentIndex],
    );
  }
}
