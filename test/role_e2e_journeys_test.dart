import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/theme/app_theme.dart';
import 'package:my_flutter_edulens/features/district/controllers/district_dashboard_controller.dart';
import 'package:my_flutter_edulens/features/district/controllers/district_data_loader.dart';
import 'package:my_flutter_edulens/features/district/controllers/exam_details_controller.dart';
import 'package:my_flutter_edulens/features/district/screens/district_dashboard_screen.dart';
import 'package:my_flutter_edulens/features/district/screens/exam_details_screen.dart';
import 'package:my_flutter_edulens/features/school_admin/controllers/school_admin_dashboard_controller.dart';
import 'package:my_flutter_edulens/features/school_admin/controllers/school_exam_schedule_controller.dart';
import 'package:my_flutter_edulens/features/school_admin/controllers/student_fee_management_controller.dart';
import 'package:my_flutter_edulens/features/school_admin/screens/school_admin_dashboard_screen.dart';
import 'package:my_flutter_edulens/features/school_admin/screens/student_fee_management_screen.dart';
import 'package:my_flutter_edulens/features/student/controllers/student_dashboard_controller.dart';
import 'package:my_flutter_edulens/features/student/controllers/student_leave_request_controller.dart';
import 'package:my_flutter_edulens/features/student/screens/student_shell.dart';
import 'package:my_flutter_edulens/features/student/widgets/submit_leave_request_dialog.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/attendance_management_controller.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/teacher_dashboard_controller.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/teacher_leave_review_controller.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/teacher_timetable_controller.dart';
import 'package:my_flutter_edulens/features/teacher/screens/attendance_management_screen.dart';
import 'package:my_flutter_edulens/features/teacher/screens/teacher_home_screen.dart';
import 'package:my_flutter_edulens/features/teacher/screens/teacher_leave_review_screen.dart';
import 'package:my_flutter_edulens/features/teacher/screens/teacher_timetable_screen.dart';
import 'package:my_flutter_edulens/models/leave_request_model.dart';
import 'package:my_flutter_edulens/models/user_model.dart';
import 'package:my_flutter_edulens/routes/app_routes.dart';

import 'support/fake_repositories.dart';

class _E2EFixture {
  final schools = FakeSchoolRepository();
  final students = FakeStudentRepository();
  final users = FakeUserRepository();
  final attendanceRepo = FakeAttendanceRepository();
  final feesRepo = FakeFeeRepository();
  final examsRepo = FakeExamRepository();
  final leaveRepo = FakeLeaveRequestRepository();
  final timetableRepo = FakeTimetableRepository();
  final examAttendanceRepo = FakeExamAttendanceRepository();

  DistrictDataLoader get loader => DistrictDataLoader(
    schoolRepository: schools,
    studentRepository: students,
    userRepository: users,
    attendanceRepository: attendanceRepo,
    feeRepository: feesRepo,
    examRepository: examsRepo,
  );

  void seed() {
    schools.schools.addAll([
      school('sch1', name: 'Oakridge International', location: 'North Zone'),
      school('sch2', name: 'St. Mary School', location: 'South Zone'),
    ]);

    students.students.addAll([
      student(
        'stu1',
        schoolId: 'sch1',
        name: 'Asha Rao',
        className: 'Class 10',
      ),
      student(
        'stu2',
        schoolId: 'sch1',
        name: 'Bob Smith',
        className: 'Class 10',
      ),
      student(
        'stu3',
        schoolId: 'sch2',
        name: 'Charlie Brown',
        className: 'Class 9',
      ),
    ]);

    users.users.addAll([
      teacher('t1', schoolId: 'sch1'),
      teacher('t2', schoolId: 'sch2'),
    ]);

    attendanceRepo.records.addAll([
      attendance('a1', schoolId: 'sch1', studentId: 'stu1', status: 'Present'),
      attendance('a2', schoolId: 'sch1', studentId: 'stu2', status: 'Present'),
      attendance('a3', schoolId: 'sch2', studentId: 'stu3', status: 'Absent'),
    ]);

    feesRepo.fees.addAll([
      fee(
        'f1',
        schoolId: 'sch1',
        studentId: 'stu1',
        totalDue: 1000,
        paidAmount: 500,
        status: 'Partial',
      ),
      fee(
        'f2',
        schoolId: 'sch1',
        studentId: 'stu2',
        totalDue: 1000,
        paidAmount: 1000,
        status: 'Paid',
      ),
      fee(
        'f3',
        schoolId: 'sch2',
        studentId: 'stu3',
        totalDue: 1000,
        paidAmount: 0,
        status: 'Outstanding',
      ),
    ]);

    examsRepo.exams.addAll([
      exam(
        'ex1',
        schoolId: 'sch1',
        date: '2026-10-25',
        subject: 'Mathematics',
        className: 'Class 10',
      ),
      exam(
        'ex2',
        schoolId: 'sch2',
        date: '2026-10-26',
        subject: 'History',
        className: 'Class 9',
      ),
    ]);

    timetableRepo.entries.addAll([
      timetableEntry(
        'tt1',
        schoolId: 'sch1',
        teacherId: 't1',
        dayOfWeek: 'Wednesday',
        subject: 'Physics',
        className: 'Class 10',
      ),
    ]);

    leaveRepo.requests.add(
      const LeaveRequestModel(
        requestId: 'lr1',
        studentId: 'stu1',
        studentName: 'Asha Rao',
        schoolId: 'sch1',
        className: 'Class 10',
        startDate: '2026-10-25',
        endDate: '2026-10-26',
        reason: 'Family emergency',
        status: 'Pending',
        submittedAt: '2026-10-20 09:00',
      ),
    );
  }
}

DateTime _fixedWednesday() => DateTime(2026, 10, 21); // 2026-10-21 is Wednesday

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  onGenerateRoute: AppRoutes.onGenerateRoute,
  home: Scaffold(body: child),
);

void main() {
  group('Day 19 E2E Role-Based Workflow Journeys', () {
    testWidgets('Journey A: District Admin E2E Dashboard & Exam Details Flow', (
      tester,
    ) async {
      final f = _E2EFixture()..seed();
      final controller = DistrictDashboardController(
        loader: f.loader,
        clock: _fixedWednesday,
      );

      await tester.pumpWidget(
        _wrap(
          DistrictDashboardScreen(
            controller: controller,
            administratorName: 'Dr. Mehta',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Greeting & District Metrics
      expect(find.text('Welcome back, Dr. Mehta'), findsOneWidget);
      expect(find.text('Total Schools'), findsOneWidget);
      expect(find.text('2'), findsWidgets);

      // Verify Upcoming Exams
      expect(find.text('Mathematics'), findsOneWidget);

      // Navigate to Exam Details Screen
      final examDetailsController = ExamDetailsController(
        examRepository: f.examsRepo,
        schoolRepository: f.schools,
        studentRepository: f.students,
      );

      await tester.pumpWidget(
        _wrap(
          ExamDetailsScreen(examId: 'ex1', controller: examDetailsController),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Scheduled'), findsWidgets);
      expect(find.text('Oakridge International · Class 10'), findsOneWidget);
    });

    testWidgets(
      'Journey B: School Admin E2E Dashboard, Search, & Fee Edit Flow',
      (tester) async {
        final f = _E2EFixture()..seed();

        final adminController = SchoolAdminDashboardController(
          schoolRepository: f.schools,
          studentRepository: f.students,
          userRepository: f.users,
          attendanceRepository: f.attendanceRepo,
          feeRepository: f.feesRepo,
          examRepository: f.examsRepo,
          clock: _fixedWednesday,
        );

        const adminProfile = UserModel(
          uid: 'admin1',
          name: 'Sarah Connor',
          email: 'sarah@oakridge.edu',
          role: 'schoolAdmin',
          schoolId: 'sch1',
        );

        await adminController.load(schoolId: 'sch1', profile: adminProfile);

        await tester.pumpWidget(
          _wrap(
            SchoolAdminDashboardScreen(
              controller: adminController,
              schoolId: 'sch1',
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Welcome back, Sarah Connor'), findsOneWidget);
        expect(
          find.text('Overview for Oakridge International'),
          findsOneWidget,
        );

        // Navigate to Student & Fee Management
        final feeController = StudentFeeManagementController(
          studentRepository: f.students,
          feeRepository: f.feesRepo,
        );

        await feeController.load(schoolId: 'sch1', profile: adminProfile);

        await tester.pumpWidget(
          _wrap(
            StudentFeeManagementScreen(
              controller: feeController,
              schoolId: 'sch1',
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Asha Rao'), findsOneWidget);
        expect(find.text('Bob Smith'), findsOneWidget);

        // Search student 'Asha'
        await tester.enterText(find.byType(TextField).first, 'Asha');
        await tester.pumpAndSettle();

        expect(find.text('Asha Rao'), findsOneWidget);
        expect(find.text('Bob Smith'), findsNothing);
        expect(find.text('1 of 2'), findsOneWidget); // Filtered roster StatCard

        // Open Edit Fee Dialog for Asha Rao
        await tester.tap(find.text('Edit Fee').first);
        await tester.pumpAndSettle();

        expect(find.text('Edit Fee Status'), findsOneWidget);

        // Enter invalid paid amount (> totalDue 1000) into dialog paid amount field (TextField index 1)
        await tester.enterText(find.byType(TextField).at(1), '1500');
        await tester.tap(find.text('Update Fee Status'));
        await tester.pumpAndSettle();

        expect(find.textContaining('cannot exceed total due'), findsOneWidget);

        // Enter valid paid amount 800 and submit
        await tester.enterText(find.byType(TextField).at(1), '800');
        await tester.tap(find.text('Update Fee Status'));
        await tester.pumpAndSettle();

        expect(find.text('Fee record updated successfully.'), findsOneWidget);
      },
    );

    testWidgets(
      'Journey C: Teacher E2E Dashboard, Timetable, Attendance, & Leave Review Flow',
      (tester) async {
        final f = _E2EFixture()..seed();

        final teacherController = TeacherDashboardController(
          schoolRepository: f.schools,
          studentRepository: f.students,
          attendanceRepository: f.attendanceRepo,
          examRepository: f.examsRepo,
          userRepository: f.users,
          timetableRepository: f.timetableRepo,
          clock: _fixedWednesday,
        );

        final teacherProfile = f.users.users.first;
        await teacherController.load(schoolId: 'sch1', profile: teacherProfile);

        await tester.pumpWidget(
          _wrap(
            TeacherHomeScreen(controller: teacherController, schoolId: 'sch1'),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Welcome back, Teacher t1'), findsOneWidget);
        expect(find.text("Today's Classes"), findsOneWidget);
        expect(find.text('Physics (Class 10-A)'), findsOneWidget);

        // Open Timetable Screen
        final timetableController = TeacherTimetableController(
          timetableRepository: f.timetableRepo,
        );

        await tester.pumpWidget(
          _wrap(
            TeacherTimetableScreen(
              controller: timetableController,
              schoolId: 'sch1',
              teacherId: 't1',
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Class Timetable'), findsOneWidget);
        await tester.tap(find.text('Wednesday'));
        await tester.pumpAndSettle();

        expect(find.text('Physics (Class 10-A)'), findsOneWidget);

        // Open Attendance Management Screen
        final attendanceController = AttendanceManagementController(
          attendanceRepository: f.attendanceRepo,
          studentRepository: f.students,
        );

        await attendanceController.loadAttendance(
          schoolId: 'sch1',
          date: '2026-10-21',
        );

        await tester.pumpWidget(
          _wrap(
            AttendanceManagementScreen(
              controller: attendanceController,
              schoolId: 'sch1',
              teacherId: 't1',
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Asha Rao'), findsOneWidget);
        expect(find.text('Save Attendance Register'), findsOneWidget);

        // Open Review Leave Requests Screen
        final reviewController = TeacherLeaveReviewController(
          leaveRequestRepository: f.leaveRepo,
        );

        await tester.pumpWidget(
          _wrap(
            TeacherLeaveReviewScreen(
              controller: reviewController,
              schoolId: 'sch1',
              teacherId: 't1',
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Asha Rao'), findsOneWidget);
        expect(find.text('Pending'), findsWidgets);

        // Approve leave request
        await tester.tap(find.text('Approve'));
        await tester.pumpAndSettle();

        expect(find.text('Confirm Approved'), findsOneWidget);
        await tester.tap(find.text('Confirm Approved'));
        await tester.pumpAndSettle();

        expect(
          find.text('Leave request Approved successfully.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Journey D: Student E2E Dashboard, Read-Only Exams, & Leave Submission Flow',
      (tester) async {
        final f = _E2EFixture()..seed();

        final dashboardController = StudentDashboardController(
          studentRepository: f.students,
          attendanceRepository: f.attendanceRepo,
          feeRepository: f.feesRepo,
          examRepository: f.examsRepo,
          clock: _fixedWednesday,
        );

        const studentProfile = UserModel(
          uid: 'stu1',
          name: 'Asha Rao',
          email: 'asha@oakridge.edu',
          role: 'student',
          schoolId: 'sch1',
        );

        await dashboardController.load(profile: studentProfile);

        final scheduleController = SchoolExamScheduleController(
          examRepository: f.examsRepo,
          schoolRepository: f.schools,
          clock: _fixedWednesday,
        );

        await scheduleController.load(schoolId: 'sch1');

        await tester.pumpWidget(
          _wrap(
            StudentShell(
              schoolId: 'sch1',
              dashboardController: dashboardController,
              examScheduleController: scheduleController,
              studentRepository: f.students,
              attendanceRepository: f.attendanceRepo,
              feeRepository: f.feesRepo,
              examRepository: f.examsRepo,
              schoolRepository: f.schools,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Welcome back, Asha Rao'), findsOneWidget);

        // Scroll down to Upcoming Exams card on Student Dashboard Home tab
        await tester.scrollUntilVisible(find.text('Mathematics'), 300);
        expect(find.text('Mathematics'), findsOneWidget);

        // Open Student Exams tab (Read-Only)
        await tester.tap(find.text('Exams'));
        await tester.pumpAndSettle();

        expect(find.text('Schedule Exam'), findsNothing); // Verified read-only
        expect(find.text('Mathematics'), findsOneWidget);

        // Submit Leave Request
        final leaveController = StudentLeaveRequestController(
          leaveRequestRepository: f.leaveRepo,
        );

        final studentModel = student(
          'stu1',
          schoolId: 'sch1',
          name: 'Asha Rao',
        );

        await tester.pumpWidget(
          _wrap(
            SubmitLeaveRequestDialog(
              student: studentModel,
              controller: leaveController,
              onSubmitted: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Submit invalid date range (start > end)
        await tester.enterText(find.byType(TextField).at(0), '2026-10-28');
        await tester.enterText(find.byType(TextField).at(1), '2026-10-25');
        await tester.enterText(find.byType(TextField).at(2), 'Medical leave');
        await tester.tap(find.text('Submit Request'));
        await tester.pumpAndSettle();

        expect(
          find.text('Start date cannot be after end date.'),
          findsOneWidget,
        );

        // Submit valid date range
        await tester.enterText(find.byType(TextField).at(0), '2026-10-25');
        await tester.enterText(find.byType(TextField).at(1), '2026-10-26');
        await tester.tap(find.text('Submit Request'));
        await tester.pumpAndSettle();

        expect(f.leaveRepo.requests.length, 2);
      },
    );
  });
}
