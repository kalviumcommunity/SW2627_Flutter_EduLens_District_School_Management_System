import 'package:flutter/material.dart';

abstract class AppRoutes {
  static const String login = '/login';
  static const String districtDashboard = '/district-dashboard';
  static const String schoolAdminDashboard = '/school-admin-dashboard';
  static const String teacherDashboard = '/teacher-dashboard';
  static const String studentDashboard = '/student-dashboard';
  static const String profile = '/profile';

  static const String initial = login;

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const _PlaceholderScreen(
              title: 'Login',
              subtitle: 'EduLens Role-Based Sign In',
            ),
        districtDashboard: (context) => const _PlaceholderScreen(
              title: 'District Dashboard',
              subtitle: 'District Administrator View',
            ),
        schoolAdminDashboard: (context) => const _PlaceholderScreen(
              title: 'School Admin Dashboard',
              subtitle: 'School Administrator View',
            ),
        teacherDashboard: (context) => const _PlaceholderScreen(
              title: 'Teacher Dashboard',
              subtitle: 'Teacher View',
            ),
        studentDashboard: (context) => const _PlaceholderScreen(
              title: 'Student Dashboard',
              subtitle: 'Student / Parent View',
            ),
        profile: (context) => const _PlaceholderScreen(
              title: 'Profile & Settings',
              subtitle: 'User Account Details',
            ),
      };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = routes[settings.name];
    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
      );
    }
    return MaterialPageRoute(
      builder: (context) => const _PlaceholderScreen(
        title: 'Destination Not Found',
        subtitle: 'The requested route does not exist.',
      ),
      settings: settings,
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;

  const _PlaceholderScreen({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
