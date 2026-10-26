/// Represents a scheduled period/class entry in the `timetables` collection.
class TimetableModel {
  final String timetableId;
  final String schoolId;
  final String teacherId;
  final String teacherName;
  final String className;
  final String section;
  final String subject;

  /// Weekday name: 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
  final String dayOfWeek;

  /// Stored as 24-hour `HH:mm` format (e.g. '09:00')
  final String startTime;

  /// Stored as 24-hour `HH:mm` format (e.g. '10:00')
  final String endTime;

  /// Optional room or classroom location (e.g. 'Room 101')
  final String? roomNumber;

  const TimetableModel({
    required this.timetableId,
    required this.schoolId,
    required this.teacherId,
    required this.teacherName,
    required this.className,
    required this.section,
    required this.subject,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.roomNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'timetableId': timetableId,
      'schoolId': schoolId,
      'teacherId': teacherId,
      'teacherName': teacherName,
      'className': className,
      'section': section,
      'subject': subject,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'roomNumber': roomNumber,
    };
  }

  factory TimetableModel.fromMap(Map<String, dynamic> map) {
    return TimetableModel(
      timetableId: map['timetableId'] as String? ?? '',
      schoolId: map['schoolId'] as String? ?? '',
      teacherId: map['teacherId'] as String? ?? '',
      teacherName: map['teacherName'] as String? ?? '',
      className: map['className'] as String? ?? '',
      section: map['section'] as String? ?? '',
      subject: map['subject'] as String? ?? '',
      dayOfWeek: map['dayOfWeek'] as String? ?? '',
      startTime: map['startTime'] as String? ?? '',
      endTime: map['endTime'] as String? ?? '',
      roomNumber: map['roomNumber'] as String?,
    );
  }

  TimetableModel copyWith({
    String? timetableId,
    String? schoolId,
    String? teacherId,
    String? teacherName,
    String? className,
    String? section,
    String? subject,
    String? dayOfWeek,
    String? startTime,
    String? endTime,
    String? roomNumber,
  }) {
    return TimetableModel(
      timetableId: timetableId ?? this.timetableId,
      schoolId: schoolId ?? this.schoolId,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      className: className ?? this.className,
      section: section ?? this.section,
      subject: subject ?? this.subject,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      roomNumber: roomNumber ?? this.roomNumber,
    );
  }
}
