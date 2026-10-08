import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/app.dart';
import 'package:my_flutter_edulens/routes/app_routes.dart';

void main() {
  group('EduLens Routing Tests', () {
    testWidgets('Initial route renders Login placeholder', (WidgetTester tester) async {
      await tester.pumpWidget(const EduLensApp());
      await tester.pumpAndSettle();

      expect(find.text('Login'), findsNWidgets(2));
      expect(find.text('EduLens Role-Based Sign In'), findsOneWidget);
    });

    testWidgets('Navigates to District Dashboard route', (WidgetTester tester) async {
      await tester.pumpWidget(const EduLensApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(Scaffold));
      Navigator.pushNamed(context, AppRoutes.districtDashboard);
      await tester.pumpAndSettle();

      expect(find.text('District Dashboard'), findsNWidgets(2));
      expect(find.text('District Administrator View'), findsOneWidget);
    });

    testWidgets('Navigates to School Admin Dashboard route', (WidgetTester tester) async {
      await tester.pumpWidget(const EduLensApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(Scaffold));
      Navigator.pushNamed(context, AppRoutes.schoolAdminDashboard);
      await tester.pumpAndSettle();

      expect(find.text('School Admin Dashboard'), findsNWidgets(2));
    });

    testWidgets('Navigates to Teacher Dashboard route', (WidgetTester tester) async {
      await tester.pumpWidget(const EduLensApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(Scaffold));
      Navigator.pushNamed(context, AppRoutes.teacherDashboard);
      await tester.pumpAndSettle();

      expect(find.text('Teacher Dashboard'), findsNWidgets(2));
    });

    testWidgets('Navigates to Student Dashboard route', (WidgetTester tester) async {
      await tester.pumpWidget(const EduLensApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(Scaffold));
      Navigator.pushNamed(context, AppRoutes.studentDashboard);
      await tester.pumpAndSettle();

      expect(find.text('Student Dashboard'), findsNWidgets(2));
    });

    testWidgets('Navigates to Profile route', (WidgetTester tester) async {
      await tester.pumpWidget(const EduLensApp());
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(Scaffold));
      Navigator.pushNamed(context, AppRoutes.profile);
      await tester.pumpAndSettle();

      expect(find.text('Profile & Settings'), findsNWidgets(2));
    });
  });
}
