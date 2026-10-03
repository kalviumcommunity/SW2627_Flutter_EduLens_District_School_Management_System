class AttendanceModel {
  final String attendanceId;
  final String studentId;
  final String schoolId;
  final String teacherId;
  final String date;
  final String status;

  const AttendanceModel({
    required this.attendanceId,
    required this.studentId,
    required this.schoolId,
    required this.teacherId,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'attendanceId': attendanceId,
      'studentId': studentId,
      'schoolId': schoolId,
      'teacherId': teacherId,
      'date': date,
      'status': status,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      attendanceId: map['attendanceId'] as String? ?? '',
      studentId: map['studentId'] as String? ?? '',
      schoolId: map['schoolId'] as String? ?? '',
      teacherId: map['teacherId'] as String? ?? '',
      date: map['date'] as String? ?? '',
      status: map['status'] as String? ?? '',
    );
  }

  AttendanceModel copyWith({
    String? attendanceId,
    String? studentId,
    String? schoolId,
    String? teacherId,
    String? date,
    String? status,
  }) {
    return AttendanceModel(
      attendanceId: attendanceId ?? this.attendanceId,
      studentId: studentId ?? this.studentId,
      schoolId: schoolId ?? this.schoolId,
      teacherId: teacherId ?? this.teacherId,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}
