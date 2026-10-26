import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/models/exam_attendance_model.dart';
import 'package:my_flutter_edulens/repositories/repository_exception.dart';

import 'support/fake_repositories.dart';

void main() {
  group('ExamAttendanceModel Serialization Unit Tests', () {
    test('serializes toMap and deserializes fromMap correctly', () {
      const record = ExamAttendanceModel(
        examAttendanceId: 'eatt_ex10_stu1',
        examId: 'ex10',
        studentId: 'stu1',
        schoolId: 'sch1',
        className: 'Class 10',
        subject: 'Mathematics',
        status: 'Present',
        recordedBy: 'teacher1',
        recordedAt: '2026-10-25 09:30',
        remarks: 'Punctual',
      );

      final map = record.toMap();
      final fromMap = ExamAttendanceModel.fromMap(map);

      expect(fromMap.examAttendanceId, 'eatt_ex10_stu1');
      expect(fromMap.examId, 'ex10');
      expect(fromMap.studentId, 'stu1');
      expect(fromMap.schoolId, 'sch1');
      expect(fromMap.className, 'Class 10');
      expect(fromMap.subject, 'Mathematics');
      expect(fromMap.status, 'Present');
      expect(fromMap.recordedBy, 'teacher1');
      expect(fromMap.recordedAt, '2026-10-25 09:30');
      expect(fromMap.remarks, 'Punctual');
    });

    test('handles missing or null remarks field gracefully', () {
      final map = {
        'examAttendanceId': 'eatt_ex10_stu2',
        'examId': 'ex10',
        'studentId': 'stu2',
        'schoolId': 'sch1',
        'className': 'Class 10',
        'subject': 'Mathematics',
        'status': 'Absent',
        'recordedBy': 'teacher1',
        'recordedAt': '2026-10-25 09:30',
      };

      final fromMap = ExamAttendanceModel.fromMap(map);
      expect(fromMap.examAttendanceId, 'eatt_ex10_stu2');
      expect(fromMap.status, 'Absent');
      expect(fromMap.remarks, isNull);
    });
  });

  group('ExamAttendanceRepository Scoped Queries & Integrity Tests', () {
    test(
      'queries exam attendance by exam and by student scoped to school',
      () async {
        final repo = FakeExamAttendanceRepository();
        repo.records.addAll([
          examAttendanceRecord(
            'eatt_ex10_stu1',
            schoolId: 'sch1',
            examId: 'ex10',
            studentId: 'stu1',
            status: 'Present',
          ),
          examAttendanceRecord(
            'eatt_ex10_stu2',
            schoolId: 'sch1',
            examId: 'ex10',
            studentId: 'stu2',
            status: 'Absent',
          ),
          examAttendanceRecord(
            'eatt_ex20_stu1',
            schoolId: 'sch1',
            examId: 'ex20', // Different exam
            studentId: 'stu1',
            status: 'Present',
          ),
        ]);

        // Query by exam
        final ex10Records = await repo.getExamAttendanceByExam(
          schoolId: 'sch1',
          examId: 'ex10',
        );
        expect(ex10Records.length, 2);

        // Query specific student for exam
        final student1Ex10Record = await repo.getExamAttendanceForStudent(
          schoolId: 'sch1',
          examId: 'ex10',
          studentId: 'stu1',
        );
        expect(student1Ex10Record, isNotNull);
        expect(student1Ex10Record!.status, 'Present');

        // Query student all exam attendance
        final student1Records = await repo.getExamAttendanceByStudent(
          schoolId: 'sch1',
          studentId: 'stu1',
        );
        expect(student1Records.length, 2);
      },
    );

    test(
      'overwrites duplicate logical records when using deterministic IDs',
      () async {
        final repo = FakeExamAttendanceRepository();
        const initialRecord = ExamAttendanceModel(
          examAttendanceId: 'eatt_ex10_stu1',
          examId: 'ex10',
          studentId: 'stu1',
          schoolId: 'sch1',
          className: 'Class 10',
          subject: 'Mathematics',
          status: 'Absent',
          recordedBy: 'teacher1',
          recordedAt: '2026-10-25 09:30',
        );

        await repo.saveExamAttendanceRecord(initialRecord);
        expect(repo.records.length, 1);
        expect(repo.records.first.status, 'Absent');

        // Update same student & exam record to Present
        final updatedRecord = initialRecord.copyWith(
          status: 'Present',
          recordedAt: '2026-10-25 10:00',
        );

        await repo.saveExamAttendanceRecord(updatedRecord);
        expect(repo.records.length, 1); // No duplicate entry created
        expect(repo.records.first.status, 'Present');
      },
    );

    test('handles repository errors with RepositoryException', () async {
      final repo = FakeExamAttendanceRepository();
      repo.failWith = RepositoryErrorKind.unavailable;

      expect(
        () => repo.getExamAttendanceByExam(schoolId: 'sch1', examId: 'ex10'),
        throwsA(isA<RepositoryException>()),
      );
    });
  });
}
