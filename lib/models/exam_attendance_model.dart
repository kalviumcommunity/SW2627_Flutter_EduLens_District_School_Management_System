/// Represents an exam-specific attendance record in the `examAttendance` collection.
///
/// Distinct from daily classroom attendance (`AttendanceModel` in `attendance`).
class ExamAttendanceModel {
  final String examAttendanceId;
  final String examId;
  final String studentId;
  final String schoolId;
  final String className;
  final String subject;

  /// Status values: 'Present', 'Absent'
  final String status;
  final String recordedBy;
  final String recordedAt;
  final String? remarks;

  const ExamAttendanceModel({
    required this.examAttendanceId,
    required this.examId,
    required this.studentId,
    required this.schoolId,
    required this.className,
    required this.subject,
    required this.status,
    required this.recordedBy,
    required this.recordedAt,
    this.remarks,
  });

  Map<String, dynamic> toMap() {
    return {
      'examAttendanceId': examAttendanceId,
      'examId': examId,
      'studentId': studentId,
      'schoolId': schoolId,
      'className': className,
      'subject': subject,
      'status': status,
      'recordedBy': recordedBy,
      'recordedAt': recordedAt,
      'remarks': remarks,
    };
  }

  factory ExamAttendanceModel.fromMap(Map<String, dynamic> map) {
    return ExamAttendanceModel(
      examAttendanceId: map['examAttendanceId'] as String? ?? '',
      examId: map['examId'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      schoolId: map['schoolId'] as String? ?? '',
      className: map['className'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      status: map['status'] as String? ?? 'Present',
      recordedBy: map['recordedBy'] as String? ?? '',
      recordedAt: map['recordedAt'] as String? ?? '',
      remarks: map['remarks'] as String?,
    );
  }

  ExamAttendanceModel copyWith({
    String? examAttendanceId,
    String? examId,
    String? studentId,
    String? schoolId,
    String? className,
    String? subject,
    String? status,
    String? recordedBy,
    String? recordedAt,
    String? remarks,
  }) {
    return ExamAttendanceModel(
      examAttendanceId: examAttendanceId ?? this.examAttendanceId,
      examId: examId ?? this.examId,
      studentId: studentId ?? this.studentId,
      schoolId: schoolId ?? this.schoolId,
      className: className ?? this.className,
      subject: subject ?? this.subject,
      status: status ?? this.status,
      recordedBy: recordedBy ?? this.recordedBy,
      recordedAt: recordedAt ?? this.recordedAt,
      remarks: remarks ?? this.remarks,
    );
  }
}
