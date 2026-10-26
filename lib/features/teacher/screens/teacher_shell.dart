import 'package:flutter/material.dart';

import '../../../core/widgets/app_list_tile.dart';
import '../../../core/widgets/app_screen_bar.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/profile_logout_section.dart';
import '../../../repositories/attendance_repository.dart';
import '../../../repositories/exam_repository.dart';
import '../../../repositories/firestore_attendance_repository.dart';
import '../../../repositories/firestore_exam_repository.dart';
import '../../../repositories/firestore_school_repository.dart';
import '../../../repositories/firestore_student_repository.dart';
import '../../../repositories/firestore_timetable_repository.dart';
import '../../../repositories/firestore_user_repository.dart';
import '../../../repositories/school_repository.dart';
import '../../../repositories/student_repository.dart';
import '../../../repositories/timetable_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_bootstrap_service.dart';
import '../../school_admin/controllers/school_exam_schedule_controller.dart';
import '../../school_admin/screens/school_exam_schedule_screen.dart';
import '../controllers/attendance_management_controller.dart';
import '../controllers/teacher_dashboard_controller.dart';
import 'attendance_management_screen.dart';
import 'teacher_home_screen.dart';

/// The Teacher navigation container.
class TeacherShell extends StatefulWidget {
  final String? schoolId;
  final String? teacherId;
  final AttendanceRepository? attendanceRepository;
  final StudentRepository? studentRepository;
  final ExamRepository? examRepository;
  final SchoolRepository? schoolRepository;
  final UserRepository? userRepository;
  final TimetableRepository? timetableRepository;
  final UserBootstrapService? bootstrapService;
  final TeacherDashboardController? homeDashboardController;
  final AttendanceManagementController? attendanceController;
  final SchoolExamScheduleController? examScheduleController;
  final AuthService? authService;

  const TeacherShell({
    super.key,
    this.schoolId,
    this.teacherId,
    this.attendanceRepository,
    this.studentRepository,
    this.examRepository,
    this.schoolRepository,
    this.userRepository,
    this.timetableRepository,
    this.bootstrapService,
    this.homeDashboardController,
    this.attendanceController,
    this.examScheduleController,
    this.authService,
  });

  @override
  State<TeacherShell> createState() => _TeacherShellState();
}

class _TeacherShellState extends State<TeacherShell> {
  int _currentIndex = 0;

  late final TeacherDashboardController _homeDashboardController;
  late final AttendanceManagementController _attendanceController;
  late final SchoolExamScheduleController _examScheduleController;
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = widget.authService ?? AuthService();
    final userRepository = widget.userRepository ?? FirestoreUserRepository();
    final schoolRepository =
        widget.schoolRepository ?? FirestoreSchoolRepository();
    final studentRepository =
        widget.studentRepository ?? FirestoreStudentRepository();
    final attendanceRepository =
        widget.attendanceRepository ?? FirestoreAttendanceRepository();
    final examRepository = widget.examRepository ?? FirestoreExamRepository();
    final timetableRepository =
        widget.timetableRepository ?? FirestoreTimetableRepository();
    final bootstrapService =
        widget.bootstrapService ??
        UserBootstrapService(userRepository: userRepository);

    _homeDashboardController =
        widget.homeDashboardController ??
        TeacherDashboardController(
          schoolRepository: schoolRepository,
          studentRepository: studentRepository,
          attendanceRepository: attendanceRepository,
          examRepository: examRepository,
          userRepository: userRepository,
          timetableRepository: timetableRepository,
          bootstrapService: bootstrapService,
        );

    _attendanceController =
        widget.attendanceController ??
        AttendanceManagementController(
          studentRepository: studentRepository,
          attendanceRepository: attendanceRepository,
          bootstrapService: bootstrapService,
        );

    _examScheduleController =
        widget.examScheduleController ??
        SchoolExamScheduleController(
          examRepository: examRepository,
          schoolRepository: schoolRepository,
          bootstrapService: bootstrapService,
        );
  }

  @override
  void dispose() {
    _homeDashboardController.dispose();
    _attendanceController.dispose();
    _examScheduleController.dispose();
    super.dispose();
  }

  static const List<AppNavItem> _tabs = [
    AppNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    AppNavItem(
      label: 'Attendance',
      icon: Icons.fact_check_outlined,
      activeIcon: Icons.fact_check,
    ),
    AppNavItem(
      label: 'Exams',
      icon: Icons.assignment_outlined,
      activeIcon: Icons.assignment,
    ),
    AppNavItem(
      label: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

  Widget _destination(int index) {
    switch (index) {
      case 0:
        return TeacherHomeScreen(
          controller: _homeDashboardController,
          schoolId: widget.schoolId,
          onNavigateToAttendance: () => setState(() => _currentIndex = 1),
          onNavigateToExams: () => setState(() => _currentIndex = 2),
        );
      case 1:
        return AttendanceManagementScreen(
          controller: _attendanceController,
          schoolId: widget.schoolId,
          teacherId: widget.teacherId,
        );
      case 2:
        return SchoolExamScheduleScreen(
          controller: _examScheduleController,
          schoolId: widget.schoolId,
        );
      default:
        final schoolName =
            _homeDashboardController.state.data?.school?.schoolName ??
            _examScheduleController.school?.schoolName;
        final targetSchoolId =
            widget.schoolId ?? _examScheduleController.targetSchoolId;

        return ProfileLogoutSection(
          authService: _authService,
          roleTitle: 'Teacher',
          userName: _homeDashboardController.state.data?.teacherProfile.name,
          details: [
            AppListTile(
              icon: Icons.school_outlined,
              title: 'Assigned School',
              subtitle: schoolName ?? 'Not provided',
              showChevron: false,
            ),
            const SizedBox(height: 8),
            AppListTile(
              icon: Icons.tag,
              title: 'School Identifier',
              subtitle: targetSchoolId ?? 'Not provided',
              showChevron: false,
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      items: _tabs,
      currentIndex: _currentIndex,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      appBar: AppScreenBar.large(
        title: _tabs[_currentIndex].label,
        actions: [
          IconButton(
            key: const Key('shell_logout_icon_button'),
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Log Out',
            onPressed: () => ProfileLogoutSection.performLogout(
              context: context,
              authService: _authService,
            ),
          ),
        ],
      ),
      body: _destination(_currentIndex),
    );
  }
}
