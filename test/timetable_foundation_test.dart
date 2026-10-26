import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/models/timetable_model.dart';
import 'package:my_flutter_edulens/repositories/repository_exception.dart';

import 'support/fake_repositories.dart';

void main() {
  group('TimetableModel Serialization & Mapping Unit Tests', () {
    test('serializes toMap and deserializes fromMap correctly', () {
      const entry = TimetableModel(
        timetableId: 'tt_101',
        schoolId: 'sch1',
        teacherId: 'tch1',
        teacherName: 'Rahul Verma',
        className: 'Class 10',
        section: 'A',
        subject: 'Physics',
        dayOfWeek: 'Monday',
        startTime: '09:00',
        endTime: '10:00',
        roomNumber: 'Lab 2',
      );

      final map = entry.toMap();
      final fromMap = TimetableModel.fromMap(map);

      expect(fromMap.timetableId, 'tt_101');
      expect(fromMap.schoolId, 'sch1');
      expect(fromMap.teacherId, 'tch1');
      expect(fromMap.teacherName, 'Rahul Verma');
      expect(fromMap.className, 'Class 10');
      expect(fromMap.section, 'A');
      expect(fromMap.subject, 'Physics');
      expect(fromMap.dayOfWeek, 'Monday');
      expect(fromMap.startTime, '09:00');
      expect(fromMap.endTime, '10:00');
      expect(fromMap.roomNumber, 'Lab 2');
    });

    test('handles missing or null optional roomNumber gracefully', () {
      final map = {
        'timetableId': 'tt_102',
        'schoolId': 'sch1',
        'teacherId': 'tch1',
        'teacherName': 'Rahul Verma',
        'className': 'Class 9',
        'section': 'B',
        'subject': 'Mathematics',
        'dayOfWeek': 'Tuesday',
        'startTime': '10:00',
        'endTime': '11:00',
      };

      final fromMap = TimetableModel.fromMap(map);
      expect(fromMap.timetableId, 'tt_102');
      expect(fromMap.roomNumber, isNull);
    });
  });

  group('TimetableRepository Scoped Queries Unit Tests', () {
    test(
      'filters timetable entries by school, teacher, and day of week',
      () async {
        final repo = FakeTimetableRepository();
        repo.entries.addAll([
          timetableEntry(
            'tt1',
            schoolId: 'sch1',
            teacherId: 'tch1',
            dayOfWeek: 'Monday',
            subject: 'Physics',
          ),
          timetableEntry(
            'tt2',
            schoolId: 'sch1',
            teacherId: 'tch1',
            dayOfWeek: 'Tuesday',
            subject: 'Chemistry',
          ),
          timetableEntry(
            'tt3',
            schoolId: 'sch2', // Different school
            teacherId: 'tch1',
            dayOfWeek: 'Monday',
            subject: 'Biology',
          ),
        ]);

        // School query
        final school1Entries = await repo.getTimetableBySchool('sch1');
        expect(school1Entries.length, 2);

        // Teacher query
        final teacher1Entries = await repo.getTimetableByTeacher(
          schoolId: 'sch1',
          teacherId: 'tch1',
        );
        expect(teacher1Entries.length, 2);

        // Teacher & Day query
        final mondayEntries = await repo.getTimetableByTeacherAndDay(
          schoolId: 'sch1',
          teacherId: 'tch1',
          dayOfWeek: 'Monday',
        );
        expect(mondayEntries.length, 1);
        expect(mondayEntries.first.subject, 'Physics');
      },
    );

    test('handles repository failure with RepositoryException', () async {
      final repo = FakeTimetableRepository();
      repo.failWith = RepositoryErrorKind.unavailable;

      expect(
        () => repo.getTimetableBySchool('sch1'),
        throwsA(isA<RepositoryException>()),
      );
    });
  });
}
