import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/models/user_model.dart';
import 'package:my_flutter_edulens/repositories/user_repository.dart';
import 'package:my_flutter_edulens/services/user_bootstrap_service.dart';

class FakeUserRepository implements UserRepository {
  final Map<String, UserModel> _storage = {};
  bool shouldThrow = false;

  @override
  Future<UserModel?> getUserById(String uid) async {
    if (shouldThrow) {
      throw Exception('Database connection error');
    }
    return _storage[uid];
  }

  @override
  Future<void> saveUser(UserModel user) async {
    if (shouldThrow) {
      throw Exception('Database save error');
    }
    _storage[user.uid] = user;
  }
}

void main() {
  group('UserBootstrapService Unit Tests', () {
    late FakeUserRepository fakeRepo;
    late UserBootstrapService bootstrapService;

    setUp(() {
      fakeRepo = FakeUserRepository();
      bootstrapService = UserBootstrapService(userRepository: fakeRepo);
    });

    test('Returns unauthenticated when no user is logged in', () async {
      final state = await bootstrapService.bootstrapUser(null);
      expect(state.status, UserBootstrapStatus.unauthenticated);
      expect(state.userModel, isNull);
    });

    test('Returns profileNotFound when user exists in Auth but not in Firestore', () async {
      final state = await fakeRepo.getUserById('uid_123');
      expect(state, isNull);
    });

    test('Returns profileFound when user exists in Firestore', () async {
      const userModel = UserModel(
        uid: 'uid_123',
        name: 'Jane Teacher',
        email: 'jane@edulens.org',
        role: 'teacher',
        schoolId: 'school_1',
      );
      await fakeRepo.saveUser(userModel);

      final fetched = await fakeRepo.getUserById('uid_123');
      expect(fetched, isNotNull);
      expect(fetched?.uid, 'uid_123');
      expect(fetched?.name, 'Jane Teacher');
      expect(fetched?.role, 'teacher');
    });

    test('Returns error state when repository throws exception', () async {
      fakeRepo.shouldThrow = true;
      expect(
        () async => await fakeRepo.getUserById('uid_123'),
        throwsException,
      );
    });
  });
}
