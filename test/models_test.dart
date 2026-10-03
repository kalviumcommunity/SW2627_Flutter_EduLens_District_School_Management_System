import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/models/attendance_model.dart';
import 'package:my_flutter_edulens/models/exam_model.dart';
import 'package:my_flutter_edulens/models/fee_model.dart';
import 'package:my_flutter_edulens/models/school_model.dart';
import 'package:my_flutter_edulens/models/student_model.dart';
import 'package:my_flutter_edulens/models/user_model.dart';

void main() {
  group('Data Models Serialization Tests', () {
    test('UserModel serialization and copyWith', () {
      const user = UserModel(
        uid: 'u123',
        name: 'John Doe',
        email: 'john@edulens.org',
        role: 'district_admin',
        schoolId: 's101',
      );

      final map = user.toMap();
      final fromMap = UserModel.fromMap(map);

      expect(fromMap.uid, 'u123');
      expect(fromMap.name, 'John Doe');
      expect(fromMap.email, 'john@edulens.org');
      expect(fromMap.role, 'district_admin');
      expect(fromMap.schoolId, 's101');

      final copied = user.copyWith(name: 'Jane Doe');
      expect(copied.name, 'Jane Doe');
      expect(copied.uid, 'u123');
    });

    test('SchoolModel serialization', () {
      const school = SchoolModel(
        schoolId: 's101',
        schoolName: 'Central High School',
        location: 'District 1',
      );

      final map = school.toMap();
      final fromMap = SchoolModel.fromMap(map);

      expect(fromMap.schoolId, 's101');
      expect(fromMap.schoolName, 'Central High School');
      expect(fromMap.location, 'District 1');
    });

    test('StudentModel serialization', () {
      const student = StudentModel(
        studentId: 'st10',
        name: 'Alice Smith',
        schoolId: 's101',
        className: '10',
        section: 'A',
      );

      final map = student.toMap();
      final fromMap = StudentModel.fromMap(map);

      expect(fromMap.studentId, 'st10');
      expect(fromMap.name, 'Alice Smith');
      expect(fromMap.schoolId, 's101');
      expect(fromMap.className, '10');
      expect(fromMap.section, 'A');
    });

    test('AttendanceModel serialization', () {
      const attendance = AttendanceModel(
        attendanceId: 'a55',
        studentId: 'st10',
        schoolId: 's101',
        teacherId: 't20',
        date: '2026-03-30',
        status: 'Present',
      );

      final map = attendance.toMap();
      final fromMap = AttendanceModel.fromMap(map);

      expect(fromMap.attendanceId, 'a55');
      expect(fromMap.status, 'Present');
    });

    test('FeeModel serialization', () {
      const fee = FeeModel(
        feeId: 'f99',
        studentId: 'st10',
        schoolId: 's101',
        totalDue: 500.0,
        paidAmount: 250.0,
        status: 'Partial',
        updatedAt: '2026-03-30T10:00:00Z',
      );

      final map = fee.toMap();
      final fromMap = FeeModel.fromMap(map);

      expect(fromMap.feeId, 'f99');
      expect(fromMap.totalDue, 500.0);
      expect(fromMap.paidAmount, 250.0);
      expect(fromMap.status, 'Partial');
    });

    test('ExamModel serialization', () {
      const exam = ExamModel(
        examId: 'e1',
        schoolId: 's101',
        className: '10',
        subject: 'Mathematics',
        date: '2026-04-10',
        startTime: '09:00 AM',
        endTime: '12:00 PM',
        createdBy: 't20',
      );

      final map = exam.toMap();
      final fromMap = ExamModel.fromMap(map);

      expect(fromMap.examId, 'e1');
      expect(fromMap.subject, 'Mathematics');
      expect(fromMap.startTime, '09:00 AM');
    });
  });
}
