import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/theme/app_theme.dart';
import 'package:my_flutter_edulens/core/widgets/app_card.dart';
import 'package:my_flutter_edulens/features/district/controllers/school_details_controller.dart';
import 'package:my_flutter_edulens/features/district/screens/school_details_screen.dart';
import 'package:my_flutter_edulens/models/school_model.dart';

import 'support/fake_repositories.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  home: Scaffold(body: child),
);

void main() {
  group('District SchoolDetailsScreen Contact Info Tests', () {
    testWidgets('renders address, contact number, and email when supplied', (
      tester,
    ) async {
      final schools = FakeSchoolRepository();
      final students = FakeStudentRepository();
      final attendance = FakeAttendanceRepository();
      final fees = FakeFeeRepository();
      final exams = FakeExamRepository();

      schools.schools.add(
        const SchoolModel(
          schoolId: 's1',
          schoolName: 'Greenwood High',
          location: 'North Zone',
          address: '100 Campus Way',
          contactNumber: '+15550100',
          email: 'contact@greenwood.edu',
        ),
      );

      final controller = SchoolDetailsController(
        schoolRepository: schools,
        studentRepository: students,
        attendanceRepository: attendance,
        feeRepository: fees,
        examRepository: exams,
      );

      await tester.pumpWidget(
        _wrap(SchoolDetailsScreen(schoolId: 's1', controller: controller)),
      );
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppCard, 'Greenwood High'), findsOneWidget);
      expect(find.text('North Zone'), findsOneWidget);

      await tester.drag(find.byType(ListView).first, const Offset(0, -300));
      await tester.pumpAndSettle();

      expect(find.text('Contact & Location Details'), findsOneWidget);
      expect(find.text('100 Campus Way'), findsOneWidget);
      expect(find.text('+15550100'), findsOneWidget);
      expect(find.text('contact@greenwood.edu'), findsOneWidget);
    });

    testWidgets(
      'handles missing optional contact fields gracefully with Not provided',
      (tester) async {
        final schools = FakeSchoolRepository();
        final students = FakeStudentRepository();
        final attendance = FakeAttendanceRepository();
        final fees = FakeFeeRepository();
        final exams = FakeExamRepository();

        schools.schools.add(
          const SchoolModel(
            schoolId: 's1',
            schoolName: 'Greenwood High',
            location: 'North Zone',
            // address, contactNumber, email null
          ),
        );

        final controller = SchoolDetailsController(
          schoolRepository: schools,
          studentRepository: students,
          attendanceRepository: attendance,
          feeRepository: fees,
          examRepository: exams,
        );

        await tester.pumpWidget(
          _wrap(SchoolDetailsScreen(schoolId: 's1', controller: controller)),
        );
        await tester.pumpAndSettle();

        expect(find.widgetWithText(AppCard, 'Greenwood High'), findsOneWidget);
        expect(find.text('North Zone'), findsOneWidget);

        await tester.drag(find.byType(ListView).first, const Offset(0, -300));
        await tester.pumpAndSettle();

        expect(find.text('Contact & Location Details'), findsOneWidget);
        expect(find.text('Not provided'), findsNWidgets(3));
      },
    );
  });
}
