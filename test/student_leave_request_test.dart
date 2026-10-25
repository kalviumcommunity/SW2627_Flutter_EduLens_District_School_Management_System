import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/core/state/view_state.dart';
import 'package:my_flutter_edulens/features/student/controllers/student_leave_request_controller.dart';
import 'package:my_flutter_edulens/features/teacher/controllers/teacher_leave_review_controller.dart';
import 'package:my_flutter_edulens/models/leave_request_model.dart';

import 'support/fake_repositories.dart';

void main() {
  group('LeaveRequestModel Unit Tests', () {
    test('serializes and deserializes correctly', () {
      const model = LeaveRequestModel(
        requestId: 'lr_100',
        studentId: 'stu_1',
        studentName: 'Asha Rao',
        schoolId: 'sch1',
        className: 'Class 10',
        startDate: '2026-10-25',
        endDate: '2026-10-26',
        reason: 'Medical appointment',
        status: 'Pending',
        submittedAt: '2026-10-20 09:00',
      );

      final map = model.toMap();
      final fromMap = LeaveRequestModel.fromMap(map);

      expect(fromMap.requestId, 'lr_100');
      expect(fromMap.studentId, 'stu_1');
      expect(fromMap.studentName, 'Asha Rao');
      expect(fromMap.schoolId, 'sch1');
      expect(fromMap.reason, 'Medical appointment');
      expect(fromMap.status, 'Pending');
    });
  });

  group('StudentLeaveRequestController Unit Tests', () {
    test(
      'submits valid leave request as Pending for authenticated student',
      () async {
        final repo = FakeLeaveRequestRepository();
        final controller = StudentLeaveRequestController(
          leaveRequestRepository: repo,
        );

        final studentModel = student('stu_1', schoolId: 'sch1');

        final success = await controller.submitLeaveRequest(
          student: studentModel,
          startDate: '2026-10-25',
          endDate: '2026-10-26',
          reason: 'Family emergency',
        );

        expect(success, isTrue);
        expect(repo.requests.length, 1);
        final submitted = repo.requests.first;
        expect(submitted.studentId, 'stu_1');
        expect(submitted.schoolId, 'sch1');
        expect(submitted.status, 'Pending');
        expect(submitted.reason, 'Family emergency');
      },
    );

    test('rejects blank reason and invalid date range', () async {
      final repo = FakeLeaveRequestRepository();
      final controller = StudentLeaveRequestController(
        leaveRequestRepository: repo,
      );

      final studentModel = student('stu_1', schoolId: 'sch1');

      // Blank reason
      final blankSuccess = await controller.submitLeaveRequest(
        student: studentModel,
        startDate: '2026-10-25',
        endDate: '2026-10-26',
        reason: '   ',
      );
      expect(blankSuccess, isFalse);
      expect(controller.submitError, contains('valid reason'));

      // Start date after end date
      final invalidDateSuccess = await controller.submitLeaveRequest(
        student: studentModel,
        startDate: '2026-10-28',
        endDate: '2026-10-25',
        reason: 'Medical appointment',
      );
      expect(invalidDateSuccess, isFalse);
      expect(controller.submitError, contains('Start date cannot be after'));
    });
  });

  group('TeacherLeaveReviewController Unit Tests', () {
    test('loads school-scoped leave requests and approves pending request with comment', () async {
      final repo = FakeLeaveRequestRepository();
      repo.requests.add(
        leaveRequest(
          'lr_1',
          studentId: 'stu_1',
          schoolId: 'sch1',
          status: 'Pending',
        ),
      );

      final controller = TeacherLeaveReviewController(
        leaveRequestRepository: repo,
      );

      await controller.loadSchoolRequests('sch1');

      expect(controller.state.status, ViewStatus.ready);
      expect(controller.state.data!.length, 1);

      final success = await controller.reviewRequest(
        schoolId: 'sch1',
        requestId: 'lr_1',
        status: 'Approved',
        teacherId: 'teacher_1',
        comment: 'Approved for medical cause',
      );

      expect(success, isTrue);
      final updated = repo.requests.firstWhere((r) => r.requestId == 'lr_1');
      expect(updated.status, 'Approved');
      expect(updated.reviewedBy, 'teacher_1');
      expect(updated.reviewComment, 'Approved for medical cause');
    });

    test('rejects pending request and records review metadata', () async {
      final repo = FakeLeaveRequestRepository();
      repo.requests.add(
        leaveRequest(
          'lr_2',
          studentId: 'stu_2',
          schoolId: 'sch1',
          status: 'Pending',
        ),
      );

      final controller = TeacherLeaveReviewController(
        leaveRequestRepository: repo,
      );

      await controller.loadSchoolRequests('sch1');

      final success = await controller.reviewRequest(
        schoolId: 'sch1',
        requestId: 'lr_2',
        status: 'Rejected',
        teacherId: 'teacher_1',
        comment: 'Exam on requested date',
      );

      expect(success, isTrue);
      final updated = repo.requests.firstWhere((r) => r.requestId == 'lr_2');
      expect(updated.status, 'Rejected');
      expect(updated.reviewedBy, 'teacher_1');
    });
  });
}
