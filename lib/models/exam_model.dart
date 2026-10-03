class ExamModel {
  final String examId;
  final String schoolId;
  final String className;
  final String subject;
  final String date;
  final String startTime;
  final String endTime;
  final String createdBy;

  const ExamModel({
    required this.examId,
    required this.schoolId,
    required this.className,
    required this.subject,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'examId': examId,
      'schoolId': schoolId,
      'className': className,
      'subject': subject,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'createdBy': createdBy,
    };
  }

  factory ExamModel.fromMap(Map<String, dynamic> map) {
    return ExamModel(
      examId: map['examId'] as String? ?? '',
      schoolId: map['schoolId'] as String? ?? '',
      className: map['className'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      date: map['date'] as String? ?? '',
      startTime: map['startTime'] as String? ?? '',
      endTime: map['endTime'] as String? ?? '',
      createdBy: map['createdBy'] as String? ?? '',
    );
  }

  ExamModel copyWith({
    String? examId,
    String? schoolId,
    String? className,
    String? subject,
    String? date,
    String? startTime,
    String? endTime,
    String? createdBy,
  }) {
    return ExamModel(
      examId: examId ?? this.examId,
      schoolId: schoolId ?? this.schoolId,
      className: className ?? this.className,
      subject: subject ?? this.subject,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
