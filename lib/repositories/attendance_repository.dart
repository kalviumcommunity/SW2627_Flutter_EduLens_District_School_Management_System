import '../models/attendance_model.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceModel>> getAttendanceBySchoolAndDate({
    required String schoolId,
    required String date,
  });
  Future<void> saveAttendance(AttendanceModel attendance);
}
