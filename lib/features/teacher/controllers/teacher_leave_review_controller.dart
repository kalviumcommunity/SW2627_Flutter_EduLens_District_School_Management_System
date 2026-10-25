import 'package:flutter/foundation.dart';

import '../../../core/state/safe_notifier.dart';
import '../../../core/state/view_state.dart';
import '../../../models/leave_request_model.dart';
import '../../../repositories/leave_request_repository.dart';

/// Drives Teacher review and approval/rejection of student leave requests.
class TeacherLeaveReviewController extends ChangeNotifier with SafeNotifier {
  final LeaveRequestRepository leaveRequestRepository;

  bool _isReviewing = false;
  bool get isReviewing => _isReviewing;

  String? _reviewError;
  String? get reviewError => _reviewError;

  TeacherLeaveReviewController({required this.leaveRequestRepository});

  ViewState<List<LeaveRequestModel>> _state = const ViewState.loading();
  ViewState<List<LeaveRequestModel>> get state => _state;

  /// Loads school-scoped leave requests for teacher review.
  Future<void> loadSchoolRequests(String schoolId) async {
    _state = const ViewState.loading();
    _reviewError = null;
    safeNotify();

    try {
      final requests = await leaveRequestRepository.getLeaveRequestsBySchool(
        schoolId,
      );
      if (requests.isEmpty) {
        _state = const ViewState.empty(
          message: 'No leave requests submitted for this school.',
        );
      } else {
        _state = ViewState.ready(requests);
      }
    } catch (e) {
      _state = ViewState.fromError(e);
    }

    safeNotify();
  }

  /// Approves or rejects a pending leave request.
  Future<bool> reviewRequest({
    required String schoolId,
    required String requestId,
    required String status,
    required String teacherId,
    String? comment,
  }) async {
    if (_isReviewing) return false;

    _isReviewing = true;
    _reviewError = null;
    safeNotify();

    try {
      await leaveRequestRepository.updateLeaveRequestStatus(
        requestId: requestId,
        status: status,
        teacherId: teacherId,
        comment: comment,
      );

      _isReviewing = false;
      await loadSchoolRequests(schoolId);
      return true;
    } catch (e) {
      _isReviewing = false;
      final viewError = ViewState<List<LeaveRequestModel>>.fromError(e);
      _reviewError =
          viewError.message ?? 'Failed to update leave request status.';
      safeNotify();
      return false;
    }
  }
}
