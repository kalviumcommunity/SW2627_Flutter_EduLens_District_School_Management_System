import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/theme/app_theme.dart';
import 'package:my_flutter_edulens/features/teacher/screens/teacher_shell.dart';
import 'package:my_flutter_edulens/models/school_model.dart';
import 'package:my_flutter_edulens/models/user_model.dart';

import 'support/fake_repositories.dart';

class _BugFixFixture {
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
        schoolName: 'Oakridge High',
        location: 'North Zone',
      ),
    );

    users.users.add(
      const UserModel(
        uid: 't1',
        name: 'Rahul Verma',
        email: 'rahul@oakridge.edu',
        role: 'teacher',
        schoolId: 'sch1',
      ),
    );

    timetableRepo.entries.add(
      timetableEntry(
        'tt1',
        schoolId: 'sch1',
        teacherId: 't1',
        dayOfWeek: 'Wednesday',
        subject: 'Physics',
        className: 'Class 10',
      ),
    );
  }
}

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  home: Scaffold(body: child),
);

void main() {
  group('Day 19 PR 2 Critical Bug Fixes & Regression Tests', () {
    testWidgets(
      'TeacherShell wires TimetableRepository into TeacherDashboardController',
      (tester) async {
        final f = _BugFixFixture()..seed();

        await tester.pumpWidget(
          _wrap(
            TeacherShell(
              schoolId: 'sch1',
              teacherId: 't1',
              schoolRepository: f.schools,
              studentRepository: f.students,
              attendanceRepository: f.attendanceRepo,
              examRepository: f.examsRepo,
              userRepository: f.users,
              timetableRepository: f.timetableRepo,
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Today's Classes section is present
        expect(find.text("Today's Classes"), findsOneWidget);
      },
    );
  });
}
