import '../models/leave_request_model.dart';

/// Contract for student leave request operations.
abstract class LeaveRequestRepository {
  /// Fetches leave requests for a specific student.
  Future<List<LeaveRequestModel>> getLeaveRequestsByStudent(String studentId);

  /// Fetches leave requests for a specific school.
  Future<List<LeaveRequestModel>> getLeaveRequestsBySchool(String schoolId);

  /// Saves a new leave request record.
  Future<void> saveLeaveRequest(LeaveRequestModel request);

  /// Updates the status of an existing leave request.
  Future<void> updateLeaveRequestStatus({
    required String requestId,
    required String status,
    required String teacherId,
    String? comment,
  });
}
