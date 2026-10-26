import '../models/timetable_model.dart';

/// Contract for teacher timetable operations.
abstract class TimetableRepository {
  /// Fetches all timetable entries for a specific school.
  Future<List<TimetableModel>> getTimetableBySchool(String schoolId);

  /// Fetches timetable entries for a specific teacher in a school.
  Future<List<TimetableModel>> getTimetableByTeacher({
    required String schoolId,
    required String teacherId,
  });

  /// Fetches timetable entries for a specific teacher on a specific weekday.
  Future<List<TimetableModel>> getTimetableByTeacherAndDay({
    required String schoolId,
    required String teacherId,
    required String dayOfWeek,
  });

  /// Saves or updates a timetable entry.
  Future<void> saveTimetableEntry(TimetableModel entry);

  /// Deletes a timetable entry.
  Future<void> deleteTimetableEntry(String timetableId);
}
