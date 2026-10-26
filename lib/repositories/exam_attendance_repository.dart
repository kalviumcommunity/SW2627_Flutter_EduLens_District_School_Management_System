import '../models/exam_attendance_model.dart';

/// Contract for exam-specific student attendance operations.
abstract class ExamAttendanceRepository {
  /// Fetches exam attendance records for a specific exam in a school.
  Future<List<ExamAttendanceModel>> getExamAttendanceByExam({
    required String schoolId,
    required String examId,
  });

  /// Fetches a specific student's attendance record for an exam.
  Future<ExamAttendanceModel?> getExamAttendanceForStudent({
    required String schoolId,
    required String examId,
    required String studentId,
  });

  /// Fetches all exam attendance records for a student in a school.
  Future<List<ExamAttendanceModel>> getExamAttendanceByStudent({
    required String schoolId,
    required String studentId,
  });

  /// Saves or updates a single exam attendance record.
  Future<void> saveExamAttendanceRecord(ExamAttendanceModel record);

  /// Saves a batch of exam attendance records atomically.
  Future<void> saveExamAttendanceBatch(List<ExamAttendanceModel> records);
}
