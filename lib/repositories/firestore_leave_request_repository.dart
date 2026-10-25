import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/constants/firestore_collections.dart';
import '../models/leave_request_model.dart';
import 'firestore_document_mapper.dart';
import 'leave_request_repository.dart';
import 'repository_exception.dart';

/// Firestore-backed [LeaveRequestRepository].
class FirestoreLeaveRequestRepository implements LeaveRequestRepository {
  final FirebaseFirestore? _customFirestore;

  FirestoreLeaveRequestRepository({FirebaseFirestore? firestore})
    : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('leaveRequests');

  LeaveRequestModel _toModel(DocumentSnapshot<Map<String, dynamic>> doc) =>
      LeaveRequestModel.fromMap(dataWithId(doc, 'requestId'));

  @override
  Future<List<LeaveRequestModel>> getLeaveRequestsByStudent(
    String studentId,
  ) async {
    try {
      final snapshot = await _collection
          .where('studentId', isEqualTo: studentId)
          .get();
      final list = snapshot.docs.map(_toModel).toList();
      list.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
      return list;
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'load student leave requests');
    }
  }

  @override
  Future<List<LeaveRequestModel>> getLeaveRequestsBySchool(
    String schoolId,
  ) async {
    try {
      final snapshot = await _collection
          .where(FirestoreFields.schoolId, isEqualTo: schoolId)
          .get();
      final list = snapshot.docs.map(_toModel).toList();
      list.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
      return list;
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'load school leave requests');
    }
  }

  @override
  Future<void> saveLeaveRequest(LeaveRequestModel request) async {
    try {
      await _collection
          .doc(request.requestId)
          .set(request.toMap(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'save leave request');
    }
  }

  @override
  Future<void> updateLeaveRequestStatus({
    required String requestId,
    required String status,
    required String teacherId,
    String? comment,
  }) async {
    try {
      final nowStr = DateTime.now()
          .toIso8601String()
          .substring(0, 16)
          .replaceAll('T', ' ');
      await _collection.doc(requestId).update({
        'status': status,
        'reviewedBy': teacherId,
        'reviewedAt': nowStr,
        if (comment != null && comment.trim().isNotEmpty)
          'reviewComment': comment.trim(),
      });
    } on FirebaseException catch (e) {
      throw RepositoryException.fromFirebase(e, 'update leave request status');
    }
  }
}
