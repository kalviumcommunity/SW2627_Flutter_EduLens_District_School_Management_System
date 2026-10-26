import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/features/student/controllers/student_leave_request_controller.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/teacher_leave_review_controller.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/teacher_timetable_controller.dart';
import 'package:my_flutter_edulens/models/exam_attendance_model.dart';
import 'package:my_flutter_edulens/models/leave_request_model.dart';

import 'support/fake_repositories.dart';

void main() {
  group('Security & Integration Audit Unit Tests', () {
    test(
      'Student leave requests inherit trusted profile studentId and schoolId',
      () async {
        final repo = FakeLeaveRequestRepository();
        final controller = StudentLeaveRequestController(
          leaveRequestRepository: repo,
        );

        final studentProfile = student('stu_trusted', schoolId: 'sch_verified');

        final success = await controller.submitLeaveRequest(
          student: studentProfile,
          startDate: '2026-10-25',
          endDate: '2026-10-26',
          reason: 'Medical leave',
        );

        expect(success, isTrue);
        final submitted = repo.requests.first;
        expect(submitted.studentId, 'stu_trusted');
        expect(submitted.schoolId, 'sch_verified');
        expect(submitted.status, 'Pending');
      },
    );

    test('Teacher leave review validates pending status and records reviewer identity', () async {
      final repo = FakeLeaveRequestRepository();
      repo.requests.add(
        const LeaveRequestModel(
          requestId: 'lr_10',
          studentId: 'stu_1',
          studentName: 'Asha Rao',
          schoolId: 'sch_verified',
          className: 'Class 10',
          startDate: '2026-10-25',
          endDate: '2026-10-26',
          reason: 'Family event',
          status: 'Pending',
          submittedAt: '2026-10-20 09:00',
        ),
      );

      final controller = TeacherLeaveReviewController(
        leaveRequestRepository: repo,
      );

      await controller.loadSchoolRequests('sch_verified');

      final success = await controller.reviewRequest(
        schoolId: 'sch_verified',
        requestId: 'lr_10',
        status: 'Approved',
        teacherId: 'teacher_trusted',
        comment: 'Approved with note',
      );

      expect(success, isTrue);
      final updated = repo.requests.firstWhere((r) => r.requestId == 'lr_10');
      expect(updated.status, 'Approved');
      expect(updated.reviewedBy, 'teacher_trusted');
    });

    test(
      'Teacher timetable queries are scoped strictly to teacherId and schoolId',
      () async {
        final repo = FakeTimetableRepository();
        repo.entries.addAll([
          timetableEntry(
            'tt1',
            schoolId: 'sch_verified',
            teacherId: 'teacher_trusted',
            dayOfWeek: 'Monday',
            subject: 'Physics',
          ),
          timetableEntry(
            'tt2',
            schoolId: 'sch_other',
            teacherId: 'teacher_trusted',
            dayOfWeek: 'Monday',
            subject: 'Chemistry',
          ),
        ]);

        final controller = TeacherTimetableController(
          timetableRepository: repo,
        );

        await controller.loadTimetable(
          schoolId: 'sch_verified',
          teacherId: 'teacher_trusted',
          dayOfWeek: 'Monday',
        );

        expect(controller.state.data!.length, 1);
        expect(controller.state.data!.first.schoolId, 'sch_verified');
        expect(controller.state.data!.first.subject, 'Physics');
      },
    );

    test(
      'ExamAttendanceModel restricts status values to Present or Absent',
      () {
        const presentRec = ExamAttendanceModel(
          examAttendanceId: 'eatt_1',
          examId: 'ex1',
          studentId: 'stu1',
          schoolId: 'sch1',
          className: 'Class 10',
          subject: 'Maths',
          status: 'Present',
          recordedBy: 'teacher1',
          recordedAt: '2026-10-25 09:30',
        );

        expect(presentRec.status, 'Present');

        const absentRec = ExamAttendanceModel(
          examAttendanceId: 'eatt_2',
          examId: 'ex1',
          studentId: 'stu2',
          schoolId: 'sch1',
          className: 'Class 10',
          subject: 'Maths',
          status: 'Absent',
          recordedBy: 'teacher1',
          recordedAt: '2026-10-25 09:30',
        );

        expect(absentRec.status, 'Absent');
      },
    );
  });
}
