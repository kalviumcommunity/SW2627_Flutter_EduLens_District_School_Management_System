import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/state/view_state.dart';
import 'package:my_flutter_edulens/core/theme/app_theme.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/attendance_management_controller.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/teacher_dashboard_controller.dart';
import 'package:my_flutter_edulens/features/teacher/screens/attendance_management_screen.dart';
import 'package:my_flutter_edulens/features/teacher/screens/teacher_home_screen.dart';
import 'package:my_flutter_edulens/features/teacher/screens/teacher_shell.dart';
import 'package:my_flutter_edulens/models/attendance_model.dart';
import 'package:my_flutter_edulens/models/exam_model.dart';
import 'package:my_flutter_edulens/models/school_model.dart';
import 'package:my_flutter_edulens/models/student_model.dart';
import 'package:my_flutter_edulens/models/user_model.dart';

import 'support/fake_repositories.dart';

class _TeacherFixture {
  final schools = FakeSchoolRepository();
  final students = FakeStudentRepository();
  final users = FakeUserRepository();
  final attendanceRepo = FakeAttendanceRepository();
  final examsRepo = FakeExamRepository();

  void seed() {
    schools.schools.add(
      const SchoolModel(
        schoolId: 'sch1',
        schoolName: 'Greenwood High',
        location: 'North District',
      ),
    );

    users.users.add(
      const UserModel(
        uid: 't1',
        name: 'Rahul Verma',
        email: 'rahul@edulens.test',
        role: 'teacher',
        schoolId: 'sch1',
      ),
    );

    students.students.addAll([
      const StudentModel(
        studentId: 'st1',
        name: 'Alice Smith',
        schoolId: 'sch1',
        className: 'Class 10',
        section: 'A',
      ),
      const StudentModel(
        studentId: 'st2',
        name: 'Bob Jones',
        schoolId: 'sch1',
        className: 'Class 10',
        section: 'B',
      ),
      const StudentModel(
        studentId: 'st3',
        name: 'Charlie Brown',
        schoolId: 'sch1',
        className: 'Class 9',
        section: 'A',
      ),
    ]);

    attendanceRepo.records.addAll([
      const AttendanceModel(
        attendanceId: 'a1',
        studentId: 'st1',
        schoolId: 'sch1',
        teacherId: 't1',
        date: '2026-10-20',
        status: 'Present',
      ),
      const AttendanceModel(
        attendanceId: 'a2',
        studentId: 'st2',
        schoolId: 'sch1',
        teacherId: 't1',
        date: '2026-10-20',
        status: 'Absent',
      ),
    ]);

    examsRepo.exams.add(
      const ExamModel(
        examId: 'ex1',
        schoolId: 'sch1',
        className: 'Class 10',
        subject: 'Mathematics',
        date: '2026-10-25',
        startTime: '09:00 AM',
        endTime: '12:00 PM',
        createdBy: 't1',
      ),
    );
  }
}

DateTime _fixedNow() => DateTime(2026, 10, 20);

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  home: Scaffold(body: child),
);

void main() {
  group('TeacherDashboardController Unit Tests', () {
    test(
      'loads teacher profile, school, total students, and upcoming exams',
      () async {
        final f = _TeacherFixture()..seed();
        final controller = TeacherDashboardController(
          schoolRepository: f.schools,
          studentRepository: f.students,
          attendanceRepository: f.attendanceRepo,
          examRepository: f.examsRepo,
          userRepository: f.users,
          clock: _fixedNow,
        );

        await controller.load(schoolId: 'sch1', profile: f.users.users.first);

        expect(controller.state.status, ViewStatus.ready);
        final data = controller.state.data!;
        expect(data.teacherProfile.name, 'Rahul Verma');
        expect(data.school?.schoolName, 'Greenwood High');
        expect(data.totalStudents, 3);
        expect(data.upcomingExams.length, 1);
        expect(data.upcomingExams.first.subject, 'Mathematics');
      },
    );
  });

  group('TeacherHomeScreen & Attendance Count Widget Tests', () {
    testWidgets('renders Teacher Home screen and navigates via shortcuts', (
      tester,
    ) async {
      final f = _TeacherFixture()..seed();
      final homeController = TeacherDashboardController(
        schoolRepository: f.schools,
        studentRepository: f.students,
        attendanceRepository: f.attendanceRepo,
        examRepository: f.examsRepo,
        userRepository: f.users,
        clock: _fixedNow,
      );

      await homeController.load(schoolId: 'sch1', profile: f.users.users.first);

      int attendanceNavCount = 0;
      int examsNavCount = 0;

      await tester.pumpWidget(
        _wrap(
          TeacherHomeScreen(
            controller: homeController,
            schoolId: 'sch1',
            onNavigateToAttendance: () => attendanceNavCount++,
            onNavigateToExams: () => examsNavCount++,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome back, Rahul Verma'), findsOneWidget);
      expect(find.text('Greenwood High • North District'), findsOneWidget);
      expect(find.text('Mathematics'), findsOneWidget);

      await tester.tap(find.text('Mark Attendance'));
      await tester.pumpAndSettle();
      expect(attendanceNavCount, 1);

      await tester.tap(find.text('View Schedule'));
      await tester.pumpAndSettle();
      expect(examsNavCount, 1);
    });

    testWidgets(
      'AttendanceManagementScreen updates student count when Class filter is selected',
      (tester) async {
        final f = _TeacherFixture()..seed();
        final controller = AttendanceManagementController(
          studentRepository: f.students,
          attendanceRepository: f.attendanceRepo,
          clock: _fixedNow,
        );

        await controller.loadAttendance(schoolId: 'sch1', date: '2026-10-20');

        await tester.pumpWidget(
          _wrap(
            AttendanceManagementScreen(
              controller: controller,
              schoolId: 'sch1',
              teacherId: 't1',
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Unfiltered total students count
        expect(find.text('Total Students'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);

        // Tap Class 9 filter chip
        await tester.tap(find.text('Class 9'));
        await tester.pumpAndSettle();

        // Filtered students count
        expect(find.text('Filtered Students'), findsOneWidget);
        expect(find.text('1 of 3'), findsOneWidget);
      },
    );

    testWidgets(
      'TeacherShell opens Teacher Home dashboard by default on Tab 0',
      (tester) async {
        final f = _TeacherFixture()..seed();
        final homeController = TeacherDashboardController(
          schoolRepository: f.schools,
          studentRepository: f.students,
          attendanceRepository: f.attendanceRepo,
          examRepository: f.examsRepo,
          userRepository: f.users,
          clock: _fixedNow,
        );

        await homeController.load(
          schoolId: 'sch1',
          profile: f.users.users.first,
        );

        await tester.pumpWidget(
          _wrap(
            TeacherShell(
              homeDashboardController: homeController,
              schoolId: 'sch1',
              teacherId: 't1',
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Welcome back, Rahul Verma'), findsOneWidget);
        expect(find.text('Quick Actions'), findsOneWidget);
      },
    );
  });
}
