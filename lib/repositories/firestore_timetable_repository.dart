import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/timetable_model.dart';
import 'firestore_document_mapper.dart';
import 'repository_exception.dart';
import 'timetable_repository.dart';

/// Firestore-backed [TimetableRepository].
class FirestoreTimetableRepository implements TimetableRepository {
  final FirebaseFirestore? _customFirestore;

  FirestoreTimetableRepository({FirebaseFirestore? firestore})
    : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('timetables');

  TimetableModel _toModel(DocumentSnapshot<Map<String, dynamic>> doc) =>
      TimetableModel.fromMap(dataWithId(doc, 'timetableId'));

  @override
  Future<List<TimetableModel>> getTimetableBySchool(String schoolId) async {
    try {
      final snapshot = await _collection
          .where(FirestoreFields.schoolId, isEqualTo: schoolId)
          .get();
      final list = snapshot.docs.map(_toModel).toList();
      list.sort((a, b) => a.startTime.compareTo(b.startTime));
      return list;
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'load school timetable');
    }
  }

  @override
  Future<List<TimetableModel>> getTimetableByTeacher({
    required String schoolId,
    required String teacherId,
  }) async {
    try {
      final snapshot = await _collection
          .where(FirestoreFields.schoolId, isEqualTo: schoolId)
          .where('teacherId', isEqualTo: teacherId)
          .get();
      final list = snapshot.docs.map(_toModel).toList();
      list.sort((a, b) => a.startTime.compareTo(b.startTime));
      return list;
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'load teacher timetable');
    }
  }

  @override
  Future<List<TimetableModel>> getTimetableByTeacherAndDay({
    required String schoolId,
    required String teacherId,
    required String dayOfWeek,
  }) async {
    try {
      final snapshot = await _collection
          .where(FirestoreFields.schoolId, isEqualTo: schoolId)
          .where('teacherId', isEqualTo: teacherId)
          .where('dayOfWeek', isEqualTo: dayOfWeek)
          .get();
      final list = snapshot.docs.map(_toModel).toList();
      list.sort((a, b) => a.startTime.compareTo(b.startTime));
      return list;
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'load teacher daily timetable');
    }
  }

  @override
  Future<void> saveTimetableEntry(TimetableModel entry) async {
    try {
      await _collection
          .doc(entry.timetableId)
          .set(entry.toMap(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'save timetable entry');
    }
  }

  @override
  Future<void> deleteTimetableEntry(String timetableId) async {
    try {
      await _collection.doc(timetableId).delete();
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'delete timetable entry');
    }
  }
}
