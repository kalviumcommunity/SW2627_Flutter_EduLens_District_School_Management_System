import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/exam_attendance_model.dart';
import 'exam_attendance_repository.dart';
import 'firestore_document_mapper.dart';
import 'repository_exception.dart';

/// Firestore-backed [ExamAttendanceRepository].
class FirestoreExamAttendanceRepository implements ExamAttendanceRepository {
  final FirebaseFirestore? _customFirestore;

  FirestoreExamAttendanceRepository({FirebaseFirestore? firestore})
    : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('examAttendance');

  ExamAttendanceModel _toModel(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ExamAttendanceModel.fromMap(dataWithId(doc, 'examAttendanceId'));

  @override
  Future<List<ExamAttendanceModel>> getExamAttendanceByExam({
    required String schoolId,
    required String examId,
  }) async {
    try {
      final snapshot = await _collection
          .where(FirestoreFields.schoolId, isEqualTo: schoolId)
          .where('examId', isEqualTo: examId)
          .get();
      return snapshot.docs.map(_toModel).toList();
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'load exam attendance by exam');
    }
  }

  @override
  Future<ExamAttendanceModel?> getExamAttendanceForStudent({
    required String schoolId,
    required String examId,
    required String studentId,
  }) async {
    try {
      final snapshot = await _collection
          .where(FirestoreFields.schoolId, isEqualTo: schoolId)
          .where('examId', isEqualTo: examId)
          .where('studentId', isEqualTo: studentId)
          .get();
      if (snapshot.docs.isEmpty) return null;
      return _toModel(snapshot.docs.first);
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'load student exam attendance');
    }
  }

  @override
  Future<List<ExamAttendanceModel>> getExamAttendanceByStudent({
    required String schoolId,
    required String studentId,
  }) async {
    try {
      final snapshot = await _collection
          .where(FirestoreFields.schoolId, isEqualTo: schoolId)
          .where('studentId', isEqualTo: studentId)
          .get();
      return snapshot.docs.map(_toModel).toList();
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(
        e,
        'load exam attendance by student',
      );
    }
  }

  @override
  Future<void> saveExamAttendanceRecord(ExamAttendanceModel record) async {
    try {
      await _collection
          .doc(record.examAttendanceId)
          .set(record.toMap(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'save exam attendance record');
    }
  }

  @override
  Future<void> saveExamAttendanceBatch(
    List<ExamAttendanceModel> records,
  ) async {
    if (records.isEmpty) return;
    try {
      final batch = _firestore.batch();
      for (final rec in records) {
        batch.set(
          _collection.doc(rec.examAttendanceId),
          rec.toMap(),
          SetOptions(merge: true),
        );
      }
      await batch.commit();
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'save exam attendance batch');
    }
  }
}
