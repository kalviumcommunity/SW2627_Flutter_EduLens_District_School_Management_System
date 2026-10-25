import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/theme/app_theme.dart';
import 'package:my_flutter_edulens/core/widgets/app_button.dart';
import 'package:my_flutter_edulens/features/district/controllers/district_data_loader.dart';
import 'package:my_flutter_edulens/features/district/screens/district_shell.dart';
import 'package:my_flutter_edulens/features/school_admin/screens/school_admin_shell.dart';
import 'package:my_flutter_edulens/features/student/screens/student_shell.dart';
import 'package:my_flutter_edulens/features/teacher/screens/teacher_shell.dart';
import 'package:my_flutter_edulens/routes/app_routes.dart';
import 'package:my_flutter_edulens/services/auth_service.dart';

import 'support/fake_repositories.dart';

class _FakeAuthService extends AuthService {
  int signOutCalls = 0;
  Completer<void>? signOutCompleter;
  bool shouldFail = false;

  @override
  Future<void> signOut() async {
    signOutCalls++;
    if (signOutCompleter != null) {
      await signOutCompleter!.future;
    }
    if (shouldFail) {
      throw const AuthException('Failed to sign out. Please try again.');
    }
  }
}

DistrictDataLoader fakeDistrictLoader() => DistrictDataLoader(
  schoolRepository: FakeSchoolRepository(),
  studentRepository: FakeStudentRepository(),
  userRepository: FakeUserRepository(),
  attendanceRepository: FakeAttendanceRepository(),
  feeRepository: FakeFeeRepository(),
  examRepository: FakeExamRepository(),
);

Widget _wrapShell(Widget shell) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    routes: AppRoutes.routes,
    home: Scaffold(body: shell),
  );
}

void main() {
  group('Shared Logout Accessibility across all 4 Roles', () {
    testWidgets('DistrictShell displays logout action and opens profile logout', (tester) async {
      final authService = _FakeAuthService();
      final loader = fakeDistrictLoader();

      await tester.pumpWidget(
        _wrapShell(
          DistrictShell(
            loader: loader,
            authService: authService,
            administratorName: 'District Admin',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shell_logout_icon_button')), findsOneWidget);

      // Open Profile Tab
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('District Administrator'), findsOneWidget);
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('profile_logout_button')), findsOneWidget);
    });

    testWidgets('SchoolAdminShell displays logout action and opens profile logout', (tester) async {
      final authService = _FakeAuthService();
      final schools = FakeSchoolRepository();

      await tester.pumpWidget(
        _wrapShell(
          SchoolAdminShell(
            authService: authService,
            schoolRepository: schools,
            schoolId: 's1',
            administratorName: 'Principal',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shell_logout_icon_button')), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('School Administrator'), findsOneWidget);
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('profile_logout_button')), findsOneWidget);
    });

    testWidgets('TeacherShell displays logout action and opens profile logout', (tester) async {
      final authService = _FakeAuthService();

      await tester.pumpWidget(
        _wrapShell(
          TeacherShell(
            authService: authService,
            schoolId: 's1',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shell_logout_icon_button')), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Teacher'), findsOneWidget);
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('profile_logout_button')), findsOneWidget);
    });

    testWidgets('StudentShell displays logout action and opens profile logout', (tester) async {
      final authService = _FakeAuthService();

      await tester.pumpWidget(
        _wrapShell(
          StudentShell(
            authService: authService,
            schoolId: 's1',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shell_logout_icon_button')), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Student'), findsOneWidget);
      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('profile_logout_button')), findsOneWidget);
    });
  });

  group('Logout Dialog, Navigation Clearing, and Failure Behavior', () {
    testWidgets('confirms logout and returns to login screen, clearing nav stack', (tester) async {
      final authService = _FakeAuthService();

      await tester.pumpWidget(
        _wrapShell(
          StudentShell(
            authService: authService,
            schoolId: 's1',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Top Bar Logout Icon
      await tester.tap(find.byKey(const Key('shell_logout_icon_button')));
      await tester.pumpAndSettle();

      expect(find.text('Are you sure you want to log out of EduLens?'), findsOneWidget);

      // Confirm Logout
      await tester.tap(find.widgetWithText(AppButton, 'Log Out'));
      await tester.pumpAndSettle();

      expect(authService.signOutCalls, 1);
      expect(find.text('District School Management System'), findsOneWidget); // LoginScreen
    });

    testWidgets('cancels logout dialog without signing out', (tester) async {
      final authService = _FakeAuthService();

      await tester.pumpWidget(
        _wrapShell(
          StudentShell(
            authService: authService,
            schoolId: 's1',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('shell_logout_icon_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(authService.signOutCalls, 0);
      expect(find.text('Student Home'), findsNothing);
    });

    testWidgets('sign-out failure shows error SnackBar without navigating away', (tester) async {
      final authService = _FakeAuthService()..shouldFail = true;

      await tester.pumpWidget(
        _wrapShell(
          StudentShell(
            authService: authService,
            schoolId: 's1',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('shell_logout_icon_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(AppButton, 'Log Out'));
      await tester.pumpAndSettle();

      expect(authService.signOutCalls, 1);
      expect(find.text('Failed to sign out. Please try again.'), findsOneWidget);
    });
  });
}
