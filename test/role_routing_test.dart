import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/routes/app_routes.dart';

void main() {
  group('Role-Based Routing Helper Tests', () {
    test('districtAdmin maps to District Dashboard route', () {
      expect(
        AppRoutes.getDashboardRouteForRole('districtAdmin'),
        AppRoutes.districtDashboard,
      );
      expect(
        AppRoutes.getDashboardRouteForRole('district_admin'),
        AppRoutes.districtDashboard,
      );
    });

    test('schoolAdmin maps to School Admin Dashboard route', () {
      expect(
        AppRoutes.getDashboardRouteForRole('schoolAdmin'),
        AppRoutes.schoolAdminDashboard,
      );
      expect(
        AppRoutes.getDashboardRouteForRole('school_admin'),
        AppRoutes.schoolAdminDashboard,
      );
    });

    test('teacher maps to Teacher Dashboard route', () {
      expect(
        AppRoutes.getDashboardRouteForRole('teacher'),
        AppRoutes.teacherDashboard,
      );
    });

    test('student maps to Student Dashboard route', () {
      expect(
        AppRoutes.getDashboardRouteForRole('student'),
        AppRoutes.studentDashboard,
      );
    });

    test('invalid or missing role returns null', () {
      expect(AppRoutes.getDashboardRouteForRole(null), isNull);
      expect(AppRoutes.getDashboardRouteForRole('unknown_role'), isNull);
    });
  });
}
