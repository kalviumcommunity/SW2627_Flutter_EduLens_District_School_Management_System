import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/theme/app_theme.dart';
import 'package:my_flutter_edulens/features/district/controllers/exam_details_controller.dart';
import 'package:my_flutter_edulens/features/district/screens/exam_details_screen.dart';
import 'package:my_flutter_edulens/features/district/widgets/exam_list_tile.dart';
import 'package:my_flutter_edulens/models/exam_model.dart';
import 'package:my_flutter_edulens/models/school_model.dart';

import 'support/fake_repositories.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  home: Scaffold(body: child),
);

void main() {
  group('ExamModel Scheduled Status Unit Tests', () {
    test(
      'ExamModel defaults status to Scheduled on creation and deserialization',
      () {
        const exam = ExamModel(
          examId: 'ex_1',
          schoolId: 'sch1',
          className: 'Class 10',
          subject: 'Mathematics',
          date: '2026-10-25',
          startTime: '09:00',
          endTime: '11:00',
          createdBy: 'teacher_1',
        );

        expect(exam.status, 'Scheduled');

        final map = exam.toMap();
        expect(map['status'], 'Scheduled');

        final fromMap = ExamModel.fromMap(map);
        expect(fromMap.status, 'Scheduled');
      },
    );

    test(
      'deserializes legacy documents without status field cleanly to Scheduled',
      () {
        final legacyMap = {
          'examId': 'ex_legacy',
          'schoolId': 'sch1',
          'className': 'Class 10',
          'subject': 'Science',
          'date': '2026-10-25',
          'startTime': '09:00',
          'endTime': '11:00',
          'createdBy': 'teacher_1',
        };

        final fromLegacy = ExamModel.fromMap(legacyMap);
        expect(fromLegacy.status, 'Scheduled');
      },
    );
  });

  group('Exam Scheduled Status Badge Widget Tests', () {
    testWidgets('ExamListTile renders Scheduled status badge', (tester) async {
      const exam = ExamModel(
        examId: 'ex_1',
        schoolId: 'sch1',
        className: 'Class 10',
        subject: 'Mathematics',
        date: '2026-10-25',
        startTime: '09:00',
        endTime: '11:00',
        createdBy: 'teacher_1',
      );

      await tester.pumpWidget(
        _wrap(const ExamListTile(exam: exam, schoolName: 'Greenwood High')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mathematics'), findsOneWidget);
      expect(find.text('Scheduled'), findsOneWidget);
    });

    testWidgets(
      'ExamDetailsScreen renders Scheduled status badge and info row',
      (tester) async {
        final exams = FakeExamRepository();
        final schools = FakeSchoolRepository();
        final students = FakeStudentRepository();

        exams.exams.add(
          const ExamModel(
            examId: 'ex100',
            schoolId: 'sch1',
            className: 'Class 10',
            subject: 'Physics',
            date: '2026-10-16',
            startTime: '09:30',
            endTime: '14:00',
            createdBy: 't1',
          ),
        );

        schools.schools.add(
          const SchoolModel(
            schoolId: 'sch1',
            schoolName: 'Greenwood High',
            location: 'North Zone',
          ),
        );

        final controller = ExamDetailsController(
          examRepository: exams,
          schoolRepository: schools,
          studentRepository: students,
        );

        await tester.pumpWidget(
          _wrap(ExamDetailsScreen(examId: 'ex100', controller: controller)),
        );
        await tester.pumpAndSettle();

        expect(find.text('Scheduled'), findsOneWidget);

        await tester.tap(find.text('Details'));
        await tester.pumpAndSettle();

        expect(find.text('Scheduled'), findsWidgets);
      },
    );
  });
}
