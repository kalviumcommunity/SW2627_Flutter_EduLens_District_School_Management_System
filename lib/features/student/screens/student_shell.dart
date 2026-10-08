import 'package:flutter/material.dart';

import '../../../core/widgets/app_screen_bar.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/placeholder_destination.dart';

/// The Student navigation container.
///
/// Same shared [AppShell] as the other roles, with the Student tab set
/// and placeholder destinations behind each tab.
class StudentShell extends StatefulWidget {
  const StudentShell({super.key});

  @override
  State<StudentShell> createState() => _StudentShellState();
}

class _StudentShellState extends State<StudentShell> {
  int _currentIndex = 0;

  static const List<AppNavItem> _tabs = [
    AppNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
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
    PlaceholderDestination(title: 'Student Home', icon: Icons.home_outlined),
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
