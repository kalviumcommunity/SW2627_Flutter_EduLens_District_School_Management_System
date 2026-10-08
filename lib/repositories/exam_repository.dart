import '../models/exam_model.dart';

abstract class ExamRepository {
  Future<List<ExamModel>> getExamsBySchool(String schoolId);
  Future<void> saveExam(ExamModel exam);
}
