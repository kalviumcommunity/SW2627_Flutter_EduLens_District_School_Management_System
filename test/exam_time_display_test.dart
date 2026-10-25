import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/theme/app_theme.dart';
import 'package:my_flutter_edulens/core/utils/app_date.dart';
import 'package:my_flutter_edulens/core/widgets/app_card.dart';
import 'package:my_flutter_edulens/features/district/controllers/exam_details_controller.dart';
import 'package:my_flutter_edulens/features/district/screens/exam_details_screen.dart';
import 'package:my_flutter_edulens/models/exam_model.dart';
import 'package:my_flutter_edulens/models/school_model.dart';

import 'support/fake_repositories.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  home: Scaffold(body: child),
);

void main() {
  group('AppDate.formatTime 12-Hour AM/PM Time Formatting Unit Tests', () {
    test('formats valid 24-hour HH:mm time strings correctly', () {
      expect(AppDate.formatTime('00:00'), '12:00 AM');
      expect(AppDate.formatTime('00:30'), '12:30 AM');
      expect(AppDate.formatTime('09:05'), '9:05 AM');
      expect(AppDate.formatTime('09:30'), '9:30 AM');
      expect(AppDate.formatTime('11:59'), '11:59 AM');
      expect(AppDate.formatTime('12:00'), '12:00 PM');
      expect(AppDate.formatTime('12:30'), '12:30 PM');
      expect(AppDate.formatTime('14:00'), '2:00 PM');
      expect(AppDate.formatTime('16:45'), '4:45 PM');
      expect(AppDate.formatTime('23:59'), '11:59 PM');
    });

    test('handles missing, null, empty, and whitespace strings gracefully', () {
      expect(AppDate.formatTime(null), 'Time not available');
      expect(AppDate.formatTime(''), 'Time not available');
      expect(AppDate.formatTime('   '), 'Time not available');
    });

    test('handles pre-formatted AM/PM strings without duplicating suffixes', () {
      expect(AppDate.formatTime('09:00 AM'), '09:00 AM');
      expect(AppDate.formatTime('02:00 PM'), '02:00 PM');
    });

    test('handles out-of-range or malformed time values safely without crashing', () {
      expect(AppDate.formatTime('25:00'), '25:00');
      expect(AppDate.formatTime('10:75'), '10:75');
      expect(AppDate.formatTime('invalid'), 'invalid');
    });

    test('AppDate.formatWithTime formats date and time with 12-hour AM/PM', () {
      expect(
        AppDate.formatWithTime('2026-10-16', '14:00'),
        '16 Oct 2026 · 2:00 PM',
      );
      expect(
        AppDate.formatWithTime('2026-10-16', '09:30'),
        '16 Oct 2026 · 9:30 AM',
      );
    });
  });

  group('Exam Details Screen Time Display Widget Tests', () {
    testWidgets('renders start time and end time in 12-hour AM/PM format', (
      tester,
    ) async {
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

      expect(find.widgetWithText(AppCard, 'Physics'), findsOneWidget);

      await tester.tap(find.text('Details'));
      await tester.pumpAndSettle();

      expect(find.text('9:30 AM'), findsOneWidget);
      expect(find.text('2:00 PM'), findsOneWidget);
    });
  });
}
