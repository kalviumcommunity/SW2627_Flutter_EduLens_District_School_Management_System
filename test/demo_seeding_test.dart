import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_edulens/models/exam_attendance_model.dart';
import 'package:my_flutter_edulens/models/exam_model.dart';
import 'package:my_flutter_edulens/models/leave_request_model.dart';
import 'package:my_flutter_edulens/models/school_model.dart';
import 'package:my_flutter_edulens/models/student_model.dart';
import 'package:my_flutter_edulens/models/timetable_model.dart';
import 'package:my_flutter_edulens/models/user_model.dart';

import 'support/fake_repositories.dart';

void main() {
  group('Multi-School Demo Seeding & Account Verification Tests', () {
    test(
      'seed dataset maintains multi-school data isolation and correct roles',
      () async {
        final schools = FakeSchoolRepository();
        final users = FakeUserRepository();
        final students = FakeStudentRepository();
        final exams = FakeExamRepository();
        final timetables = FakeTimetableRepository();
        final leave = FakeLeaveRequestRepository();
        final examAttendance = FakeExamAttendanceRepository();

        // Seed 4 schools
        schools.schools.addAll([
          const SchoolModel(
            schoolId: 'school01',
            schoolName: 'Greenwood High',
            location: 'North Zone',
          ),
          const SchoolModel(
            schoolId: 'school02',
            schoolName: 'Riverside Public',
            location: 'East District',
          ),
          const SchoolModel(
            schoolId: 'school03',
            schoolName: 'Hilltop Academy',
            location: 'West District',
          ),
          const SchoolModel(
            schoolId: 'school04',
            schoolName: 'Oakridge International',
            location: 'Central District',
          ),
        ]);

        // Seed Accounts
        users.users.addAll([
          const UserModel(
            uid: 'u_dist',
            name: 'Dr. Aditya Mehta',
            email: 'district.admin@edulens.demo',
            role: 'districtAdmin',
            schoolId: '',
          ),
          const UserModel(
            uid: 'u_admin1',
            name: 'Sarah Connor',
            email: 'admin.school01@edulens.demo',
            role: 'schoolAdmin',
            schoolId: 'school01',
          ),
          const UserModel(
            uid: 'u_admin2',
            name: 'David Miller',
            email: 'admin.school02@edulens.demo',
            role: 'schoolAdmin',
            schoolId: 'school02',
          ),
          const UserModel(
            uid: 'u_teacher1',
            name: 'Rahul Verma',
            email: 'teacher1.school01@edulens.demo',
            role: 'teacher',
            schoolId: 'school01',
          ),
          const UserModel(
            uid: 'u_student1',
            name: 'Asha Rao',
            email: 'student1.school01@edulens.demo',
            role: 'student',
            schoolId: 'school01',
          ),
        ]);

        students.students.add(
          const StudentModel(
            studentId: 'u_student1',
            name: 'Asha Rao',
            schoolId: 'school01',
            className: 'Class 10',
            section: 'A',
            rollNumber: '101',
          ),
        );

        exams.exams.add(
          const ExamModel(
            examId: 'exam01',
            schoolId: 'school01',
            className: 'Class 10',
            subject: 'Mathematics',
            date: '2026-10-25',
            startTime: '10:00',
            endTime: '12:00',
            createdBy: 'u_teacher1',
            status: 'Scheduled',
          ),
        );

        timetables.entries.add(
          const TimetableModel(
            timetableId: 'tt1',
            schoolId: 'school01',
            teacherId: 'u_teacher1',
            teacherName: 'Rahul Verma',
            className: 'Class 10',
            section: 'A',
            subject: 'Physics',
            dayOfWeek: 'Monday',
            startTime: '09:00',
            endTime: '10:00',
            roomNumber: 'Room 101',
          ),
        );

        leave.requests.add(
          const LeaveRequestModel(
            requestId: 'lr1',
            studentId: 'u_student1',
            studentName: 'Asha Rao',
            schoolId: 'school01',
            className: 'Class 10',
            startDate: '2026-10-25',
            endDate: '2026-10-26',
            reason: 'Medical emergency',
            status: 'Pending',
            submittedAt: '2026-10-20 09:00',
          ),
        );

        examAttendance.records.add(
          const ExamAttendanceModel(
            examAttendanceId: 'eatt_exam01_u_student1',
            examId: 'exam01',
            studentId: 'u_student1',
            schoolId: 'school01',
            className: 'Class 10',
            subject: 'Mathematics',
            status: 'Present',
            recordedBy: 'u_admin1',
            recordedAt: '2026-10-20 09:00',
          ),
        );

        // Verify School count
        final allSchools = await schools.getSchools();
        expect(allSchools.length, 4);

        // Verify School Admin 01 profile
        final admin1 = await users.getUserById('u_admin1');
        expect(admin1, isNotNull);
        expect(admin1!.role, 'schoolAdmin');
        expect(admin1.schoolId, 'school01');

        // Verify Student 01 profile & domain model
        final student1User = await users.getUserById('u_student1');
        final student1Model = await students.getStudentById('u_student1');
        expect(student1User!.role, 'student');
        expect(student1Model!.schoolId, 'school01');
        expect(student1Model.rollNumber, '101');

        // Verify Exam Scheduled status
        final schoolExams = await exams.getExamsBySchool('school01');
        expect(schoolExams.first.status, 'Scheduled');

        // Verify Timetable entry
        final teacherClasses = await timetables.getTimetableByTeacherAndDay(
          schoolId: 'school01',
          teacherId: 'u_teacher1',
          dayOfWeek: 'Monday',
        );
        expect(teacherClasses.length, 1);
        expect(teacherClasses.first.subject, 'Physics');

        // Verify Leave Request
        final studentLeaves = await leave.getLeaveRequestsByStudent(
          'u_student1',
        );
        expect(studentLeaves.first.status, 'Pending');

        // Verify Exam Attendance
        final examAtt = await examAttendance.getExamAttendanceForStudent(
          schoolId: 'school01',
          examId: 'exam01',
          studentId: 'u_student1',
        );
        expect(examAtt!.status, 'Present');
      },
    );
  });
}
