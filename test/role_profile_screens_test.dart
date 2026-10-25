import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/theme/app_theme.dart';
import 'package:my_flutter_edulens/features/district/controllers/district_data_loader.dart';
import 'package:my_flutter_edulens/features/district/screens/district_shell.dart';
import 'package:my_flutter_edulens/features/school_admin/screens/school_admin_shell.dart';
import 'package:my_flutter_edulens/features/student/controllers/student_dashboard_controller.dart';
import 'package:my_flutter_edulens/features/student/screens/student_shell.dart';
import 'package:my_flutter_edulens/features/teacher/screens/teacher_shell.dart';
import 'package:my_flutter_edulens/models/student_model.dart';
import 'package:my_flutter_edulens/models/user_model.dart';
import 'package:my_flutter_edulens/services/auth_service.dart';

import 'support/fake_repositories.dart';

class _FakeAuthService extends AuthService {
  @override
  Future<void> signOut() async {}
}

DistrictDataLoader fakeDistrictLoader() => DistrictDataLoader(
  schoolRepository: FakeSchoolRepository(),
  studentRepository: FakeStudentRepository(),
  userRepository: FakeUserRepository(),
  attendanceRepository: FakeAttendanceRepository(),
  feeRepository: FakeFeeRepository(),
  examRepository: FakeExamRepository(),
);

Widget _wrap(Widget shell) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    home: Scaffold(body: shell),
  );
}

void main() {
  group('Role-Based Profile Screens Tests', () {
    testWidgets('District Admin Profile renders role title and scope details', (
      tester,
    ) async {
      final authService = _FakeAuthService();
      final loader = fakeDistrictLoader();

      await tester.pumpWidget(
        _wrap(
          DistrictShell(
            loader: loader,
            authService: authService,
            administratorName: 'District Director',
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('District Administrator'), findsOneWidget);
      expect(find.text('District Wide (All Schools)'), findsOneWidget);
      expect(find.text('Full Administrative Privilege'), findsOneWidget);
    });

    testWidgets(
      'School Admin Profile renders school name and ID or Not provided fallback',
      (tester) async {
        final authService = _FakeAuthService();
        final schools = FakeSchoolRepository();

        await tester.pumpWidget(
          _wrap(
            SchoolAdminShell(
              authService: authService,
              schoolRepository: schools,
              schoolId: 'school01',
              administratorName: 'Principal Sharma',
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();

        expect(find.text('School Administrator'), findsOneWidget);
        expect(find.text('Assigned School'), findsOneWidget);
        expect(find.text('School Identifier'), findsOneWidget);
        expect(find.text('school01'), findsOneWidget);
      },
    );

    testWidgets(
      'Teacher Profile renders assigned school details and role label',
      (tester) async {
        final authService = _FakeAuthService();

        await tester.pumpWidget(
          _wrap(TeacherShell(authService: authService, schoolId: 'school01')),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();

        expect(find.text('Teacher'), findsOneWidget);
        expect(find.text('Assigned School'), findsOneWidget);
        expect(find.text('school01'), findsOneWidget);
      },
    );

    testWidgets(
      'Student Profile renders school, class, section, roll number and fallbacks',
      (tester) async {
        final authService = _FakeAuthService();
        final students = FakeStudentRepository()
          ..students.add(
            const StudentModel(
              studentId: 'stu-1',
              name: 'Asha Rao',
              schoolId: 'school01',
              className: 'Class 10',
              section: 'A',
              rollNumber: 'RN-101',
            ),
          );

        final controller = StudentDashboardController(
          studentRepository: students,
          attendanceRepository: FakeAttendanceRepository(),
          feeRepository: FakeFeeRepository(),
          examRepository: FakeExamRepository(),
        );

        await controller.load(
          profile: const UserModel(
            uid: 'stu-1',
            name: 'Asha Rao',
            email: 'asha@edulens.test',
            role: 'student',
            schoolId: 'school01',
          ),
        );

        await tester.pumpWidget(
          _wrap(
            StudentShell(
              authService: authService,
              dashboardController: controller,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();

        expect(find.text('Student'), findsOneWidget);
        expect(find.text('Asha Rao'), findsWidgets);
        expect(find.text('Class 10 - Section A'), findsOneWidget);
        expect(find.text('RN-101'), findsOneWidget);
      },
    );
  });
}
