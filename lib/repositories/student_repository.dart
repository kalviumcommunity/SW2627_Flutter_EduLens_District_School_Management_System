import '../models/student_model.dart';

abstract class StudentRepository {
  Future<List<StudentModel>> getStudentsBySchool(String schoolId);
  Future<StudentModel?> getStudentById(String studentId);
}
