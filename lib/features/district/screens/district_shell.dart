import 'package:flutter/material.dart';

import '../../../core/widgets/app_screen_bar.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/placeholder_destination.dart';

/// The District Administrator navigation container.
///
/// It supplies the District tab set to the shared [AppShell] and
/// remembers which tab is selected. Every tab currently shows a
/// placeholder, because the real District screens are built later.
///
/// The shell itself knows nothing about roles; this file is what makes
/// it a District experience.
class DistrictShell extends StatefulWidget {
  const DistrictShell({super.key});

  @override
  State<DistrictShell> createState() => _DistrictShellState();
}

class _DistrictShellState extends State<DistrictShell> {
  /// Which tab is open. Starts on the first one.
  int _currentIndex = 0;

  static const List<AppNavItem> _tabs = [
    AppNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    AppNavItem(
      label: 'Schools',
      icon: Icons.apartment_outlined,
      activeIcon: Icons.apartment,
    ),
    AppNavItem(
      label: 'Exams',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment,
    ),
    AppNavItem(
      label: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  static const List<Widget> _destinations = [
    PlaceholderDestination(title: 'District Home', icon: Icons.home_outlined),
    PlaceholderDestination(title: 'Schools', icon: Icons.apartment_outlined),
    PlaceholderDestination(title: 'Exams', icon: Icons.assignment_outlined),
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
