import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/models/attendance_model.dart';
import 'package:my_flutter_edulens/models/exam_model.dart';
import 'package:my_flutter_edulens/models/fee_model.dart';
import 'package:my_flutter_edulens/models/school_model.dart';
import 'package:my_flutter_edulens/models/student_model.dart';
import 'package:my_flutter_edulens/models/user_model.dart';
import 'package:my_flutter_edulens/repositories/attendance_repository.dart';
import 'package:my_flutter_edulens/repositories/exam_repository.dart';
import 'package:my_flutter_edulens/repositories/fee_repository.dart';
import 'package:my_flutter_edulens/repositories/school_repository.dart';
import 'package:my_flutter_edulens/repositories/student_repository.dart';
import 'package:my_flutter_edulens/repositories/user_repository.dart';

class TestUserRepository implements UserRepository {
  UserModel? user;
  @override
  Future<UserModel?> getUserById(String uid) async => user;
  @override
  Future<void> saveUser(UserModel user) async => this.user = user;
}

class TestSchoolRepository implements SchoolRepository {
  final List<SchoolModel> schools = [];
  @override
  Future<List<SchoolModel>> getSchools() async => schools;
  @override
  Future<SchoolModel?> getSchoolById(String schoolId) async =>
      schools.firstWhere((s) => s.schoolId == schoolId);
}

class TestStudentRepository implements StudentRepository {
  final List<StudentModel> students = [];
  @override
  Future<List<StudentModel>> getStudentsBySchool(String schoolId) async =>
      students.where((s) => s.schoolId == schoolId).toList();
  @override
  Future<StudentModel?> getStudentById(String studentId) async =>
      students.firstWhere((s) => s.studentId == studentId);
}

class TestAttendanceRepository implements AttendanceRepository {
  final List<AttendanceModel> records = [];
  @override
  Future<List<AttendanceModel>> getAttendanceBySchoolAndDate({
    required String schoolId,
    required String date,
  }) async =>
      records.where((a) => a.schoolId == schoolId && a.date == date).toList();
  @override
  Future<void> saveAttendance(AttendanceModel attendance) async =>
      records.add(attendance);
}

class TestFeeRepository implements FeeRepository {
  FeeModel? fee;
  @override
  Future<FeeModel?> getFeeByStudentId(String studentId) async => fee;
  @override
  Future<void> updateFeeStatus(FeeModel fee) async => this.fee = fee;
}

class TestExamRepository implements ExamRepository {
  final List<ExamModel> exams = [];
  @override
  Future<List<ExamModel>> getExamsBySchool(String schoolId) async =>
      exams.where((e) => e.schoolId == schoolId).toList();
  @override
  Future<void> saveExam(ExamModel exam) async => exams.add(exam);
}

void main() {
  group('Repository Contracts Tests', () {
    test('UserRepository contract test', () async {
      final repo = TestUserRepository();
      const user = UserModel(
        uid: 'u1',
        name: 'Admin',
        email: 'admin@edulens.org',
        role: 'district_admin',
      );
      await repo.saveUser(user);
      final fetched = await repo.getUserById('u1');
      expect(fetched?.name, 'Admin');
    });

    test('SchoolRepository contract test', () async {
      final repo = TestSchoolRepository();
      const school = SchoolModel(
        schoolId: 's1',
        schoolName: 'City Academy',
        location: 'North Zone',
      );
      repo.schools.add(school);
      final fetched = await repo.getSchoolById('s1');
      expect(fetched?.schoolName, 'City Academy');
    });

    test('StudentRepository contract test', () async {
      final repo = TestStudentRepository();
      const student = StudentModel(
        studentId: 'st1',
        name: 'Bob',
        schoolId: 's1',
        className: '10',
        section: 'B',
      );
      repo.students.add(student);
      final list = await repo.getStudentsBySchool('s1');
      expect(list.length, 1);
      expect(list.first.name, 'Bob');
    });

    test('AttendanceRepository contract test', () async {
      final repo = TestAttendanceRepository();
      const record = AttendanceModel(
        attendanceId: 'att1',
        studentId: 'st1',
        schoolId: 's1',
        teacherId: 't1',
        date: '2026-03-30',
        status: 'Present',
      );
      await repo.saveAttendance(record);
      final list = await repo.getAttendanceBySchoolAndDate(
        schoolId: 's1',
        date: '2026-03-30',
      );
      expect(list.length, 1);
      expect(list.first.status, 'Present');
    });

    test('FeeRepository contract test', () async {
      final repo = TestFeeRepository();
      const fee = FeeModel(
        feeId: 'f1',
        studentId: 'st1',
        schoolId: 's1',
        totalDue: 1000.0,
        paidAmount: 1000.0,
        status: 'Paid',
        updatedAt: '2026-03-30',
      );
      await repo.updateFeeStatus(fee);
      final fetched = await repo.getFeeByStudentId('st1');
      expect(fetched?.status, 'Paid');
    });

    test('ExamRepository contract test', () async {
      final repo = TestExamRepository();
      const exam = ExamModel(
        examId: 'ex1',
        schoolId: 's1',
        className: '10',
        subject: 'Science',
        date: '2026-04-15',
        startTime: '10:00 AM',
        endTime: '01:00 PM',
        createdBy: 't1',
      );
      await repo.saveExam(exam);
      final list = await repo.getExamsBySchool('s1');
      expect(list.length, 1);
      expect(list.first.subject, 'Science');
    });
  });
}
