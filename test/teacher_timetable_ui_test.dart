import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/state/view_state.dart';
import 'package:my_flutter_edulens/core/theme/app_theme.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/teacher_dashboard_controller.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/teacher_timetable_controller.dart';
import 'package:my_flutter_edulens/features/teacher/screens/teacher_home_screen.dart';
import 'package:my_flutter_edulens/features/teacher/screens/teacher_timetable_screen.dart';
import 'package:my_flutter_edulens/models/school_model.dart';
import 'package:my_flutter_edulens/models/user_model.dart';

import 'support/fake_repositories.dart';

class _TimetableUIFixture {
  final schools = FakeSchoolRepository();
  final students = FakeStudentRepository();
  final users = FakeUserRepository();
  final attendanceRepo = FakeAttendanceRepository();
  final examsRepo = FakeExamRepository();
  final timetableRepo = FakeTimetableRepository();

  void seed() {
    schools.schools.add(
      const SchoolModel(
        schoolId: 'sch1',
        schoolName: 'Greenwood High',
        location: 'North Zone',
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

    timetableRepo.entries.addAll([
      timetableEntry(
        'tt1',
        schoolId: 'sch1',
        teacherId: 't1',
        dayOfWeek: 'Wednesday', // Matches fixed now 2026-10-21
        subject: 'Physics',
        className: 'Class 10',
      ),
      timetableEntry(
        'tt2',
        schoolId: 'sch1',
        teacherId: 't1',
        dayOfWeek: 'Wednesday',
        subject: 'Mathematics',
        className: 'Class 9',
      ),
    ]);
  }
}

DateTime _fixedWednesday() => DateTime(2026, 10, 21); // 2026-10-21 is Wednesday

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  home: Scaffold(body: child),
);

void main() {
  group("Teacher Dashboard Today's Classes Integration Tests", () {
    test(
      "loads today's classes on Wednesday for authenticated teacher",
      () async {
        final f = _TimetableUIFixture()..seed();
        final controller = TeacherDashboardController(
          schoolRepository: f.schools,
          studentRepository: f.students,
          attendanceRepository: f.attendanceRepo,
          examRepository: f.examsRepo,
          userRepository: f.users,
          timetableRepository: f.timetableRepo,
          clock: _fixedWednesday,
        );

        await controller.load(schoolId: 'sch1', profile: f.users.users.first);

        expect(controller.state.status, ViewStatus.ready);
        final data = controller.state.data!;
        expect(data.todayClasses.length, 2);
        expect(data.todayClasses.first.subject, 'Physics');
      },
    );

    testWidgets(
      "TeacherHomeScreen renders Today's Classes section and room number",
      (tester) async {
        final f = _TimetableUIFixture()..seed();
        final controller = TeacherDashboardController(
          schoolRepository: f.schools,
          studentRepository: f.students,
          attendanceRepository: f.attendanceRepo,
          examRepository: f.examsRepo,
          userRepository: f.users,
          timetableRepository: f.timetableRepo,
          clock: _fixedWednesday,
        );

        await controller.load(schoolId: 'sch1', profile: f.users.users.first);

        await tester.pumpWidget(
          _wrap(TeacherHomeScreen(controller: controller, schoolId: 'sch1')),
        );
        await tester.pumpAndSettle();

        expect(find.text("Today's Classes"), findsOneWidget);
        expect(find.text('Physics (Class 10-A)'), findsOneWidget);
        expect(find.textContaining('Room: Room 101'), findsWidgets);
      },
    );

    testWidgets(
      "TeacherHomeScreen displays empty state when no classes scheduled today",
      (tester) async {
        final f = _TimetableUIFixture(); // Unseeded -> no classes
        final controller = TeacherDashboardController(
          schoolRepository: f.schools,
          studentRepository: f.students,
          attendanceRepository: f.attendanceRepo,
          examRepository: f.examsRepo,
          userRepository: f.users,
          timetableRepository: f.timetableRepo,
          clock: _fixedWednesday,
        );

        await controller.load(
          schoolId: 'sch1',
          profile: const UserModel(
            uid: 't1',
            name: 'Rahul Verma',
            email: 'rahul@edulens.test',
            role: 'teacher',
            schoolId: 'sch1',
          ),
        );

        await tester.pumpWidget(
          _wrap(TeacherHomeScreen(controller: controller, schoolId: 'sch1')),
        );
        await tester.pumpAndSettle();

        expect(find.text('No classes scheduled for today.'), findsOneWidget);
      },
    );
  });

  group('TeacherTimetableScreen Widget Tests', () {
    testWidgets('renders daily timetable and switches day choice chips', (
      tester,
    ) async {
      final f = _TimetableUIFixture()..seed();
      final controller = TeacherTimetableController(
        timetableRepository: f.timetableRepo,
      );

      await tester.pumpWidget(
        _wrap(
          TeacherTimetableScreen(
            controller: controller,
            schoolId: 'sch1',
            teacherId: 't1',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Class Timetable'), findsOneWidget);
      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Tuesday'), findsOneWidget);
      expect(find.text('Wednesday'), findsOneWidget);

      // Tap Wednesday choice chip
      await tester.tap(find.text('Wednesday'));
      await tester.pumpAndSettle();

      expect(find.text('Physics (Class 10-A)'), findsOneWidget);
      expect(find.textContaining('9:00 AM – 10:00 AM'), findsWidgets);
    });
  });
}
