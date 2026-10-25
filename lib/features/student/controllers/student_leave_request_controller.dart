import 'package:flutter/foundation.dart';

import '../../../core/state/safe_notifier.dart';
import '../../../core/state/view_state.dart';
import '../../../models/leave_request_model.dart';
import '../../../models/student_model.dart';
import '../../../repositories/leave_request_repository.dart';

/// Drives the Student Leave Request submission and history view.
class StudentLeaveRequestController extends ChangeNotifier with SafeNotifier {
  final LeaveRequestRepository leaveRequestRepository;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  String? _submitError;
  String? get submitError => _submitError;

  bool _submitSuccess = false;
  bool get submitSuccess => _submitSuccess;

  StudentLeaveRequestController({required this.leaveRequestRepository});

  ViewState<List<LeaveRequestModel>> _state = const ViewState.loading();
  ViewState<List<LeaveRequestModel>> get state => _state;

  /// Loads leave request history for the signed-in student.
  Future<void> loadLeaveRequests(String studentId) async {
    _state = const ViewState.loading();
    _submitError = null;
    _submitSuccess = false;
    safeNotify();

    try {
      final requests = await leaveRequestRepository.getLeaveRequestsByStudent(
        studentId,
      );
      if (requests.isEmpty) {
        _state = const ViewState.empty(
          message: 'You have not submitted any leave requests yet.',
        );
      } else {
        _state = ViewState.ready(requests);
      }
    } catch (e) {
      _state = ViewState.fromError(e);
    }

    safeNotify();
  }

  /// Validates and submits a new leave request.
  Future<bool> submitLeaveRequest({
    required StudentModel student,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    if (_isSubmitting) return false;

    if (reason.trim().isEmpty) {
      _submitError = 'Please provide a valid reason for your leave request.';
      safeNotify();
      return false;
    }

    if (startDate.compareTo(endDate) > 0) {
      _submitError = 'Start date cannot be after end date.';
      safeNotify();
      return false;
    }

    _isSubmitting = true;
    _submitError = null;
    _submitSuccess = false;
    safeNotify();

    try {
      final nowStr = DateTime.now()
          .toIso8601String()
          .substring(0, 16)
          .replaceAll('T', ' ');
      final requestId =
          'lr_${student.studentId}_${DateTime.now().millisecondsSinceEpoch}';

      final newRequest = LeaveRequestModel(
        requestId: requestId,
        studentId: student.studentId,
        studentName: student.name,
        schoolId: student.schoolId,
        className: student.className,
        startDate: startDate.trim(),
        endDate: endDate.trim(),
        reason: reason.trim(),
        status: 'Pending',
        submittedAt: nowStr,
      );

      await leaveRequestRepository.saveLeaveRequest(newRequest);

      _isSubmitting = false;
      _submitSuccess = true;

      await loadLeaveRequests(student.studentId);
      return true;
    } catch (e) {
      _isSubmitting = false;
      final viewError = ViewState<List<LeaveRequestModel>>.fromError(e);
      _submitError = viewError.message ?? 'Failed to submit leave request.';
      safeNotify();
      return false;
    }
  }
}
