import 'package:flutter/foundation.dart';

import '../../../core/state/safe_notifier.dart';
import '../../../core/state/view_state.dart';
import '../../../core/utils/app_date.dart';
import '../../../core/utils/metrics.dart';
import '../../../models/exam_model.dart';
import '../../../models/school_model.dart';
import '../../../models/timetable_model.dart';
import '../../../models/user_model.dart';
import '../../../repositories/attendance_repository.dart';
import '../../../repositories/exam_repository.dart';
import '../../../repositories/school_repository.dart';
import '../../../repositories/student_repository.dart';
import '../../../repositories/timetable_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/user_bootstrap_service.dart';

/// Data payload for the Teacher Home Dashboard.
class TeacherDashboardData {
  final UserModel teacherProfile;
  final SchoolModel? school;
  final int totalStudents;
  final double? attendanceRate;
  final List<ExamModel> upcomingExams;
  final List<TimetableModel> todayClasses;

  const TeacherDashboardData({
    required this.teacherProfile,
    required this.school,
    required this.totalStudents,
    required this.attendanceRate,
    required this.upcomingExams,
    required this.todayClasses,
  });
}

/// Drives the Teacher Home Dashboard screen.
class TeacherDashboardController extends ChangeNotifier with SafeNotifier {
  final SchoolRepository schoolRepository;
  final StudentRepository studentRepository;
  final AttendanceRepository attendanceRepository;
  final ExamRepository examRepository;
  final UserRepository userRepository;
  final TimetableRepository? timetableRepository;
  final UserBootstrapService? bootstrapService;
  final DateTime Function() clock;

  TeacherDashboardController({
    required this.schoolRepository,
    required this.studentRepository,
    required this.attendanceRepository,
    required this.examRepository,
    required this.userRepository,
    this.timetableRepository,
    this.bootstrapService,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  ViewState<TeacherDashboardData> _state = const ViewState.loading();
  ViewState<TeacherDashboardData> get state => _state;

  static String _dayName(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      default:
        return 'Sunday';
    }
  }

  /// Loads teacher profile, school info, student count, attendance %, upcoming exams, and today's classes.
  Future<void> load({String? schoolId, UserModel? profile}) async {
    _state = const ViewState.loading();
    safeNotify();

    try {
      UserModel? teacherProfile = profile;
      if (teacherProfile == null && bootstrapService != null) {
        final bootstrapState = await bootstrapService!.bootstrapUser();
        if (bootstrapState.status == UserBootstrapStatus.profileFound) {
          teacherProfile = bootstrapState.userModel;
        }
      }

      final targetSchoolId = schoolId ?? teacherProfile?.schoolId;

      if (teacherProfile == null &&
          (targetSchoolId == null || targetSchoolId.isEmpty)) {
        _state = const ViewState.error(
          'Unable to load teacher profile. Please sign in again.',
        );
        safeNotify();
        return;
      }

      SchoolModel? school;
      if (targetSchoolId != null && targetSchoolId.isNotEmpty) {
        school = await schoolRepository.getSchoolById(targetSchoolId);
      }

      int totalStudents = 0;
      double? attendanceRate;
      List<ExamModel> upcomingExams = [];
      List<TimetableModel> todayClasses = [];

      if (targetSchoolId != null && targetSchoolId.isNotEmpty) {
        final students = await studentRepository.getStudentsBySchool(
          targetSchoolId,
        );
        totalStudents = students.length;

        final records = await attendanceRepository.getAttendanceBySchool(
          targetSchoolId,
        );
        attendanceRate = Metrics.attendancePercentage(records);

        final exams = await examRepository.getExamsBySchool(targetSchoolId);
        upcomingExams = Metrics.upcomingExams(
          exams,
          from: AppDate.today(clock()),
        );

        if (timetableRepository != null && teacherProfile != null) {
          final todayName = _dayName(clock());
          todayClasses = await timetableRepository!.getTimetableByTeacherAndDay(
            schoolId: targetSchoolId,
            teacherId: teacherProfile.uid,
            dayOfWeek: todayName,
          );
        }
      }

      _state = ViewState.ready(
        TeacherDashboardData(
          teacherProfile:
              teacherProfile ??
              UserModel(
                uid: 'teacher',
                name: 'Teacher',
                email: 'teacher@edulens.org',
                role: 'teacher',
                schoolId: targetSchoolId,
              ),
          school: school,
          totalStudents: totalStudents,
          attendanceRate: attendanceRate,
          upcomingExams: upcomingExams,
          todayClasses: todayClasses,
        ),
      );
    } catch (e) {
      _state = ViewState.fromError(e);
    }

    safeNotify();
  }
}
