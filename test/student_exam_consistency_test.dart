import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/theme/app_theme.dart';
import 'package:my_flutter_edulens/features/district/screens/exam_details_screen.dart';
import 'package:my_flutter_edulens/features/district/widgets/exam_list_tile.dart';
import 'package:my_flutter_edulens/features/school_admin/controllers/school_exam_schedule_controller.dart';
import 'package:my_flutter_edulens/features/school_admin/screens/school_exam_schedule_screen.dart';
import 'package:my_flutter_edulens/features/student/controllers/student_dashboard_controller.dart';
import 'package:my_flutter_edulens/features/student/screens/student_dashboard_screen.dart';
import 'package:my_flutter_edulens/features/student/screens/student_shell.dart';
import 'package:my_flutter_edulens/models/exam_model.dart';
import 'package:my_flutter_edulens/models/school_model.dart';
import 'package:my_flutter_edulens/models/student_model.dart';
import 'package:my_flutter_edulens/models/user_model.dart';
import 'package:my_flutter_edulens/routes/app_routes.dart';

import 'support/fake_repositories.dart';

class _ConsistencyFixture {
  final schools = FakeSchoolRepository();
  final students = FakeStudentRepository();
  final attendance = FakeAttendanceRepository();
  final fees = FakeFeeRepository();
  final exams = FakeExamRepository();

  void seed() {
    schools.schools.add(
      const SchoolModel(
        schoolId: 'sch1',
        schoolName: 'Greenwood High',
        location: 'North Zone',
      ),
    );

    students.students.add(
      const StudentModel(
        studentId: 'stu1',
        name: 'Asha Rao',
        schoolId: 'sch1',
        className: 'Class 10',
        section: 'A',
      ),
    );

    exams.exams.addAll([
      const ExamModel(
        examId: 'ex10',
        schoolId: 'sch1',
        className: 'Class 10',
        subject: 'Mathematics',
        date: '2026-10-25',
        startTime: '09:30',
        endTime: '12:00',
        createdBy: 't1',
      ),
      const ExamModel(
        examId: 'ex20',
        schoolId: 'sch1',
        className: 'Class 9', // Different class
        subject: 'History',
        date: '2026-10-26',
        startTime: '14:00',
        endTime: '16:30',
        createdBy: 't1',
      ),
    ]);
  }
}

DateTime _fixedNow() => DateTime(2026, 10, 20);

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  onGenerateRoute: AppRoutes.onGenerateRoute,
  home: Scaffold(body: child),
);

void main() {
  group('Student Exam Consistency Tests', () {
    testWidgets(
      'Student Dashboard Home tab renders class-scoped exams with AM/PM time and navigates on tap',
      (tester) async {
        final f = _ConsistencyFixture()..seed();

        final controller = StudentDashboardController(
          studentRepository: f.students,
          attendanceRepository: f.attendance,
          feeRepository: f.fees,
          examRepository: f.exams,
          clock: _fixedNow,
        );

        await controller.load(
          profile: const UserModel(
            uid: 'stu1',
            name: 'Asha Rao',
            email: 'asha@edulens.test',
            role: 'student',
            schoolId: 'sch1',
          ),
        );

        await tester.pumpWidget(
          _wrap(StudentDashboardScreen(controller: controller)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Mathematics'), findsOneWidget);
        expect(find.text('History'), findsNothing); // Filtered out Class 9 exam
        expect(find.textContaining('9:30 AM – 12:00 PM'), findsOneWidget);

        // Tap exam card to open ExamDetailsScreen
        await tester.tap(find.text('Mathematics'));
        await tester.pumpAndSettle();

        expect(find.byType(ExamDetailsScreen), findsOneWidget);
      },
    );

    testWidgets(
      'Student Exams tab renders school-wide schedule read-only with search filter',
      (tester) async {
        final f = _ConsistencyFixture()..seed();

        final controller = SchoolExamScheduleController(
          examRepository: f.exams,
          schoolRepository: f.schools,
          clock: _fixedNow,
        );

        await controller.load(schoolId: 'sch1');

        await tester.pumpWidget(
          _wrap(
            SchoolExamScheduleScreen(
              controller: controller,
              schoolId: 'sch1',
              allowScheduling: false,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Read-only check: Schedule Exam button is absent
        expect(find.text('Schedule Exam'), findsNothing);

        expect(find.text('Mathematics'), findsOneWidget);
        expect(find.text('History'), findsOneWidget);
        expect(find.textContaining('9:30 AM'), findsOneWidget);

        // Search filter check
        await tester.enterText(find.byType(TextField).first, 'Mathematics');
        await tester.pumpAndSettle();

        expect(
          find.widgetWithText(ExamListTile, 'Mathematics'),
          findsOneWidget,
        );
        expect(find.text('History'), findsNothing);
      },
    );

    testWidgets(
      'StudentShell integrates Home dashboard and read-only Exams tab',
      (tester) async {
        final f = _ConsistencyFixture()..seed();

        final dashboardController = StudentDashboardController(
          studentRepository: f.students,
          attendanceRepository: f.attendance,
          feeRepository: f.fees,
          examRepository: f.exams,
          clock: _fixedNow,
        );

        await dashboardController.load(
          profile: const UserModel(
            uid: 'stu1',
            name: 'Asha Rao',
            email: 'asha@edulens.test',
            role: 'student',
            schoolId: 'sch1',
          ),
        );

        final scheduleController = SchoolExamScheduleController(
          examRepository: f.exams,
          schoolRepository: f.schools,
          clock: _fixedNow,
        );

        await tester.pumpWidget(
          _wrap(
            StudentShell(
              schoolId: 'sch1',
              dashboardController: dashboardController,
              examScheduleController: scheduleController,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Welcome back, Asha Rao'), findsOneWidget);
        expect(find.text('Mathematics'), findsOneWidget);

        // Switch to Exams tab
        await tester.tap(find.text('Exams'));
        await tester.pumpAndSettle();

        expect(find.text('Schedule Exam'), findsNothing);
        expect(find.text('History'), findsOneWidget);
      },
    );
  });
}
