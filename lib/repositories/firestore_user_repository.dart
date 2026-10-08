import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

/// Concrete Firestore implementation of [UserRepository].
class FirestoreUserRepository implements UserRepository {
  final FirebaseFirestore? _customFirestore;

  FirestoreUserRepository({FirebaseFirestore? firestore})
      : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  @override
  Future<UserModel?> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        return null;
      }
      return UserModel.fromMap(doc.data()!);
    } catch (e) {
      throw Exception('Failed to fetch user profile: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.uid).set(
            user.toMap(),
            SetOptions(merge: true),
          );
    } catch (e) {
      throw Exception('Failed to save user profile: ${e.toString()}');
    }
  }
}
