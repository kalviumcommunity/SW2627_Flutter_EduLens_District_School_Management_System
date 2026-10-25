import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/models/student_model.dart';
import 'package:my_flutter_edulens/repositories/repository_exception.dart';

import 'support/fake_repositories.dart';

void main() {
  group('StudentRepository Behavior & Fallback Lookup Tests', () {
    test(
      'direct document-ID lookup succeeds when document ID matches studentId',
      () async {
        final repo = FakeStudentRepository();
        repo.students.add(
          const StudentModel(
            studentId: 'uid-student-100',
            name: 'Ananya Gupta',
            schoolId: 'school01',
            className: 'Class 10',
            section: 'A',
            rollNumber: '12',
          ),
        );

        final student = await repo.getStudentById('uid-student-100');

        expect(student, isNotNull);
        expect(student?.name, 'Ananya Gupta');
        expect(student?.studentId, 'uid-student-100');
      },
    );

    test('fallback field lookup succeeds when student document exists in repository list', () async {
      final repo = FakeStudentRepository();
      // Document seeded with custom student ID 'school01-student1'
      repo.students.add(
        const StudentModel(
          studentId: 'school01-student1',
          name: 'Rohan Kumar',
          schoolId: 'school01',
          className: 'Class 10',
          section: 'B',
        ),
      );

      final student = await repo.getStudentById('school01-student1');

      expect(student, isNotNull);
      expect(student?.name, 'Rohan Kumar');
      expect(student?.schoolId, 'school01');
    });

    test('returns null when no matching record exists', () async {
      final repo = FakeStudentRepository();

      final student = await repo.getStudentById('non-existent-uid');

      expect(student, isNull);
    });

    test(
      'propagates repository error on permission denied or service failure',
      () async {
        final repo = FakeStudentRepository();
        repo.failWith = RepositoryErrorKind.permissionDenied;

        expect(
          () async => await repo.getStudentById('uid-student-100'),
          throwsA(isA<RepositoryException>()),
        );
      },
    );
  });
}
