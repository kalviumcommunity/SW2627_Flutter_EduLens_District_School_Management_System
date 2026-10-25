/// Represents a student leave request in the `leaveRequests` collection.
class LeaveRequestModel {
  final String requestId;
  final String studentId;
  final String studentName;
  final String schoolId;
  final String className;
  final String startDate;
  final String endDate;
  final String reason;

  /// Status values: 'Pending', 'Approved', 'Rejected'
  final String status;
  final String submittedAt;
  final String? reviewedBy;
  final String? reviewedAt;
  final String? reviewComment;

  const LeaveRequestModel({
    required this.requestId,
    required this.studentId,
    required this.studentName,
    required this.schoolId,
    required this.className,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.submittedAt,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewComment,
  });

  Map<String, dynamic> toMap() {
    return {
      'requestId': requestId,
      'studentId': studentId,
      'studentName': studentName,
      'schoolId': schoolId,
      'className': className,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'status': status,
      'submittedAt': submittedAt,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt,
      'reviewComment': reviewComment,
    };
  }

  factory LeaveRequestModel.fromMap(Map<String, dynamic> map) {
    return LeaveRequestModel(
      requestId: map['requestId'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      studentName: map['studentName'] as String? ?? '',
      schoolId: map['schoolId'] as String? ?? '',
      className: map['className'] as String? ?? '',
      startDate: map['startDate'] as String? ?? '',
      endDate: map['endDate'] as String? ?? '',
      reason: map['reason'] as String? ?? '',
      status: map['status'] as String? ?? 'Pending',
      submittedAt: map['submittedAt'] as String? ?? '',
      reviewedBy: map['reviewedBy'] as String?,
      reviewedAt: map['reviewedAt'] as String?,
      reviewComment: map['reviewComment'] as String?,
    );
  }

  LeaveRequestModel copyWith({
    String? requestId,
    String? studentId,
    String? studentName,
    String? schoolId,
    String? className,
    String? startDate,
    String? endDate,
    String? reason,
    String? status,
    String? submittedAt,
    String? reviewedBy,
    String? reviewedAt,
    String? reviewComment,
  }) {
    return LeaveRequestModel(
      requestId: requestId ?? this.requestId,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      schoolId: schoolId ?? this.schoolId,
      className: className ?? this.className,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewComment: reviewComment ?? this.reviewComment,
    );
  }
}
