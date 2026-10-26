// Firestore Security Rules runtime tests for EduLens.
//
// These run real read and write requests against the real rules engine in
// the Firebase Emulator Suite. That is the difference between this file
// and everything under `test/*.dart`: the Dart tests use in-memory fakes
// and execute no rules at all, so they can only show how the app responds
// to a denial, never whether Firestore would actually deny it.
//
// Run with:   cd test/rules && npm install && npm test
//
// The emulator is seeded through `withSecurityRulesDisabled`, so the
// fixtures themselves are not an authorization claim; only the assertions
// below are.
import { readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import test, { after } from 'node:test';
import {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} from '@firebase/rules-unit-testing';
import {
  collection,
  doc,
  getDoc,
  getDocs,
  query,
  setDoc,
  updateDoc,
  where,
} from 'firebase/firestore';

const here = path.dirname(fileURLToPath(import.meta.url));
const rulesPath = path.resolve(here, '..', '..', 'firestore.rules');

const SCHOOL_A = 'sch-a';
const SCHOOL_B = 'sch-b';

const testEnv = await initializeTestEnvironment({
  projectId: 'edulens-rules-test',
  firestore: {
    rules: readFileSync(rulesPath, 'utf8'),
    host: '127.0.0.1',
    port: 8080,
  },
});

await testEnv.clearFirestore();
await testEnv.withSecurityRulesDisabled(async (ctx) => {
  const db = ctx.firestore();

  // Users
  await setDoc(doc(db, 'users', 'dist-1'), {
    uid: 'dist-1',
    name: 'District Director',
    role: 'districtAdmin',
  });

  await setDoc(doc(db, 'users', 'admin-a'), {
    uid: 'admin-a',
    name: 'Admin School A',
    role: 'schoolAdmin',
    schoolId: SCHOOL_A,
  });
  await setDoc(doc(db, 'users', 'admin-b'), {
    uid: 'admin-b',
    name: 'Admin School B',
    role: 'schoolAdmin',
    schoolId: SCHOOL_B,
  });

  await setDoc(doc(db, 'users', 'tch-a'), {
    uid: 'tch-a',
    name: 'Teacher School A',
    role: 'teacher',
    schoolId: SCHOOL_A,
  });
  await setDoc(doc(db, 'users', 'tch-b'), {
    uid: 'tch-b',
    name: 'Teacher School B',
    role: 'teacher',
    schoolId: SCHOOL_B,
  });

  await setDoc(doc(db, 'users', 'stu-a'), {
    uid: 'stu-a',
    name: 'Student School A',
    role: 'student',
    schoolId: SCHOOL_A,
  });
  await setDoc(doc(db, 'users', 'stu-a2'), {
    uid: 'stu-a2',
    name: 'Second Student School A',
    role: 'student',
    schoolId: SCHOOL_A,
  });
  await setDoc(doc(db, 'users', 'stu-b'), {
    uid: 'stu-b',
    name: 'Student School B',
    role: 'student',
    schoolId: SCHOOL_B,
  });
  await setDoc(doc(db, 'users', 'stu-nos'), {
    uid: 'stu-nos',
    name: 'Student With No School',
    role: 'student',
  });

  // Schools
  await setDoc(doc(db, 'schools', SCHOOL_A), {
    schoolId: SCHOOL_A,
    schoolName: 'Greenwood High',
    location: 'North Zone',
  });
  await setDoc(doc(db, 'schools', SCHOOL_B), {
    schoolId: SCHOOL_B,
    schoolName: 'Riverside Academy',
    location: 'South Zone',
  });

  // Students records
  await setDoc(doc(db, 'students', 'stu-a'), {
    studentId: 'stu-a',
    name: 'Student School A',
    schoolId: SCHOOL_A,
    className: 'Class 10',
    section: 'A',
  });
  await setDoc(doc(db, 'students', 'stu-a2'), {
    studentId: 'stu-a2',
    name: 'Second Student School A',
    schoolId: SCHOOL_A,
    className: 'Class 10',
    section: 'B',
  });
  await setDoc(doc(db, 'students', 'stu-b'), {
    studentId: 'stu-b',
    name: 'Student School B',
    schoolId: SCHOOL_B,
    className: 'Class 10',
    section: 'A',
  });
  await setDoc(doc(db, 'students', 'stu-nos'), {
    studentId: 'stu-nos',
    name: 'Student With No School',
    className: 'Class 10',
    section: 'A',
  });

  // Attendance
  await setDoc(doc(db, 'attendance', 'att-a1'), {
    attendanceId: 'att-a1',
    studentId: 'stu-a',
    schoolId: SCHOOL_A,
    teacherId: 'tch-a',
    date: '2026-10-14',
    status: 'Present',
  });
  await setDoc(doc(db, 'attendance', 'att-b1'), {
    attendanceId: 'att-b1',
    studentId: 'stu-b',
    schoolId: SCHOOL_B,
    teacherId: 'tch-b',
    date: '2026-10-14',
    status: 'Present',
  });

  // Fees
  await setDoc(doc(db, 'fees', 'fee-a1'), {
    feeId: 'fee-a1',
    studentId: 'stu-a',
    schoolId: SCHOOL_A,
    totalDue: 1000,
    paidAmount: 500,
    status: 'Partial',
  });
  await setDoc(doc(db, 'fees', 'fee-b1'), {
    feeId: 'fee-b1',
    studentId: 'stu-b',
    schoolId: SCHOOL_B,
    totalDue: 1000,
    paidAmount: 1000,
    status: 'Paid',
  });

  // Exams
  await setDoc(doc(db, 'exams', 'exam-a1'), {
    examId: 'exam-a1',
    schoolId: SCHOOL_A,
    className: 'Class 10',
    subject: 'Mathematics',
    date: '2026-10-25',
    startTime: '09:00',
    endTime: '11:00',
    createdBy: 'tch-a',
  });
  await setDoc(doc(db, 'exams', 'exam-b1'), {
    examId: 'exam-b1',
    schoolId: SCHOOL_B,
    className: 'Class 10',
    subject: 'History',
    date: '2026-10-26',
    startTime: '10:00',
    endTime: '12:00',
    createdBy: 'tch-b',
  });
});

after(() => testEnv.cleanup());

function as(uid) {
  return testEnv.authenticatedContext(uid).firestore();
}

function unauth() {
  return testEnv.unauthenticatedContext().firestore();
}

// ------------------------------------------------------------- tests

test('unauthenticated users can read nothing except the school list', async () => {
  const db = unauth();

  await assertFails(getDoc(doc(db, 'schools', SCHOOL_A)));
  await assertFails(getDoc(doc(db, 'users', 'stu-a')));
  await assertFails(getDoc(doc(db, 'students', 'stu-a')));
  await assertFails(getDoc(doc(db, 'attendance', 'att-a1')));
  await assertFails(getDoc(doc(db, 'fees', 'fee-a1')));
  await assertFails(getDoc(doc(db, 'exams', 'exam-a1')));
});

test('a district admin can read and write everything', async () => {
  const db = as('dist-1');

  await assertSucceeds(getDoc(doc(db, 'schools', SCHOOL_A)));
  await assertSucceeds(getDoc(doc(db, 'users', 'stu-a')));
  await assertSucceeds(getDoc(doc(db, 'students', 'stu-a')));
  await assertSucceeds(getDoc(doc(db, 'attendance', 'att-a1')));
  await assertSucceeds(getDoc(doc(db, 'fees', 'fee-a1')));
  await assertSucceeds(getDoc(doc(db, 'exams', 'exam-a1')));

  await assertSucceeds(
    updateDoc(doc(db, 'attendance', 'att-a1'), { status: 'Absent' }),
  );
});

test('a school admin is scoped to their assigned school', async () => {
  const db = as('admin-a');

  await assertSucceeds(getDoc(doc(doc(db, 'schools', SCHOOL_A))));
  await assertSucceeds(getDoc(doc(db, 'students', 'stu-a')));
  await assertSucceeds(getDoc(doc(db, 'attendance', 'att-a1')));
  await assertSucceeds(getDoc(doc(db, 'fees', 'fee-a1')));
  await assertSucceeds(getDoc(doc(db, 'exams', 'exam-a1')));

  await assertSucceeds(
    updateDoc(doc(db, 'fees', 'fee-a1'), {
      status: 'Paid',
      paidAmount: 1000,
    }),
  );

  await assertFails(getDoc(doc(db, 'attendance', 'att-b1')));
  await assertFails(getDoc(doc(db, 'fees', 'fee-b1')));
  await assertFails(getDoc(doc(db, 'exams', 'exam-b1')));
});

test('a teacher can read and write attendance and exams for their school only', async () => {
  const db = as('tch-a');

  await assertSucceeds(getDoc(doc(db, 'attendance', 'att-a1')));
  await assertSucceeds(
    updateDoc(doc(db, 'attendance', 'att-a1'), { status: 'Absent' }),
  );

  await assertSucceeds(getDoc(doc(db, 'exams', 'exam-a1')));
  await assertSucceeds(
    setDoc(doc(db, 'exams', 'exam-new'), {
      examId: 'exam-new',
      schoolId: SCHOOL_A,
      className: 'Class 10',
      subject: 'Physics',
      date: '2026-11-01',
      startTime: '09:00',
      endTime: '11:00',
      createdBy: 'tch-a',
    }),
  );

  await assertFails(
    updateDoc(doc(db, 'fees', 'fee-a1'), { status: 'Paid', paidAmount: 1000 }),
  );

  await assertFails(getDoc(doc(db, 'attendance', 'att-b1')));
  await assertFails(getDoc(doc(db, 'exams', 'exam-b1')));
});

test('a student reads only their own attendance, fees and profile', async () => {
  const db = as('stu-a');

  await assertSucceeds(getDoc(doc(db, 'students', 'stu-a')));
  await assertSucceeds(getDoc(doc(db, 'attendance', 'att-a1')));
  await assertSucceeds(getDoc(doc(db, 'fees', 'fee-a1')));

  await assertFails(getDoc(doc(db, 'students', 'stu-a2')));

  await assertFails(getDoc(doc(db, 'students', 'stu-b')));
  await assertFails(getDoc(doc(db, 'attendance', 'att-b1')));
  await assertFails(getDoc(doc(db, 'fees', 'fee-b1')));
  await assertFails(getDoc(doc(db, 'exams', 'exam-b1')));
});

test('a provisioned student reads their own school exams', async () => {
  const db = as('stu-a');
  await assertSucceeds(getDoc(doc(db, 'exams', 'exam-a1')));
});

test('a student without a schoolId is denied exams', async () => {
  const db = as('stu-nos');
  await assertSucceeds(getDoc(doc(db, 'students', 'stu-nos')));
  await assertFails(getDoc(doc(db, 'exams', 'exam-a1')));
});

test('a student cannot write attendance, fees or exams', async () => {
  const db = as('stu-a');
  await assertFails(
    updateDoc(doc(db, 'attendance', 'att-a1'), { status: 'Absent' }),
  );
  await assertFails(
    setDoc(doc(db, 'attendance', 'att-self'), {
      attendanceId: 'att-self',
      studentId: 'stu-a',
      schoolId: SCHOOL_A,
      teacherId: 'stu-a',
      date: '2026-10-26',
      status: 'Present',
    }),
  );
  await assertFails(
    updateDoc(doc(db, 'fees', 'fee-a1'), { status: 'Paid', paidAmount: 1000 }),
  );
  await assertFails(
    setDoc(doc(db, 'exams', 'exam-self'), {
      examId: 'exam-self',
      schoolId: SCHOOL_A,
      className: 'Class 10',
      subject: 'Free period',
      date: '2026-11-09',
      startTime: '09:00',
      endTime: '11:00',
      createdBy: 'stu-a',
    }),
  );
});

test('a student cannot promote themselves', async () => {
  const db = as('stu-a');
  await assertFails(
    updateDoc(doc(db, 'users', 'stu-a'), { role: 'districtAdmin' }),
  );
  await assertFails(
    updateDoc(doc(db, 'users', 'stu-a'), { schoolId: SCHOOL_B }),
  );
});

test('a student cannot read another user profile', async () => {
  const db = as('stu-a');
  await assertFails(getDoc(doc(db, 'users', 'stu-a2')));
  await assertSucceeds(getDoc(doc(db, 'users', 'stu-a')));
});

test('leaveRequests Security Rules enforcement', async () => {
  const studentA = as('stu-a');
  const studentB = as('stu-b');
  const teacherA = as('tch-a');
  const teacherB = as('tch-b');
  const anon = unauth();

  // 1. Unauthenticated creation denied
  await assertFails(
    setDoc(doc(anon, 'leaveRequests', 'lr-anon'), {
      requestId: 'lr-anon',
      studentId: 'stu-a',
      studentName: 'Asha Rao',
      schoolId: SCHOOL_A,
      className: 'Class 10',
      startDate: '2026-10-25',
      endDate: '2026-10-26',
      reason: 'Sick leave',
      status: 'Pending',
      submittedAt: '2026-10-20 09:00',
    }),
  );

  // 2. Student creating request for another student denied
  await assertFails(
    setDoc(doc(studentA, 'leaveRequests', 'lr-fake'), {
      requestId: 'lr-fake',
      studentId: 'stu-b',
      studentName: 'Bob Jones',
      schoolId: SCHOOL_A,
      className: 'Class 10',
      startDate: '2026-10-25',
      endDate: '2026-10-26',
      reason: 'Sick leave',
      status: 'Pending',
      submittedAt: '2026-10-20 09:00',
    }),
  );

  // 3. Student creating request with initial status Approved denied
  await assertFails(
    setDoc(doc(studentA, 'leaveRequests', 'lr-bypass'), {
      requestId: 'lr-bypass',
      studentId: 'stu-a',
      studentName: 'Asha Rao',
      schoolId: SCHOOL_A,
      className: 'Class 10',
      startDate: '2026-10-25',
      endDate: '2026-10-26',
      reason: 'Self approved',
      status: 'Approved',
      submittedAt: '2026-10-20 09:00',
    }),
  );

  // 4. Valid student creation succeeds
  await assertSucceeds(
    setDoc(doc(studentA, 'leaveRequests', 'lr-a1'), {
      requestId: 'lr-a1',
      studentId: 'stu-a',
      studentName: 'Asha Rao',
      schoolId: SCHOOL_A,
      className: 'Class 10',
      startDate: '2026-10-25',
      endDate: '2026-10-26',
      reason: 'Medical appointment',
      status: 'Pending',
      submittedAt: '2026-10-20 09:00',
    }),
  );

  // 5. Student reading another student's leave request denied
  await assertFails(getDoc(doc(studentB, 'leaveRequests', 'lr-a1')));

  // 6. Student self-read succeeds
  await assertSucceeds(getDoc(doc(studentA, 'leaveRequests', 'lr-a1')));

  // 7. Student updating review status denied
  await assertFails(
    updateDoc(doc(studentA, 'leaveRequests', 'lr-a1'), {
      status: 'Approved',
    }),
  );

  // 8. Cross-school teacher reviewing request denied
  await assertFails(
    updateDoc(doc(teacherB, 'leaveRequests', 'lr-a1'), {
      status: 'Approved',
      reviewedBy: 'tch-b',
    }),
  );

  // 9. Authorized teacher reviewing pending request succeeds
  await assertSucceeds(
    updateDoc(doc(teacherA, 'leaveRequests', 'lr-a1'), {
      status: 'Approved',
      reviewedBy: 'tch-a',
    }),
  );

  // 10. Reviewing an already reviewed request denied
  await assertFails(
    updateDoc(doc(teacherA, 'leaveRequests', 'lr-a1'), {
      status: 'Rejected',
      reviewedBy: 'tch-a',
    }),
  );
});

test('timetables Security Rules enforcement', async () => {
  const studentA = as('stu-a');
  const teacherA = as('tch-a');
  const teacherB = as('tch-b');
  const adminA = as('admin-a');
  const anon = unauth();

  // 1. Unauthenticated creation denied
  await assertFails(
    setDoc(doc(anon, 'timetables', 'tt-anon'), {
      timetableId: 'tt-anon',
      schoolId: SCHOOL_A,
      teacherId: 'tch-a',
      teacherName: 'Teacher School A',
      className: 'Class 10',
      section: 'A',
      subject: 'Physics',
      dayOfWeek: 'Monday',
      startTime: '09:00',
      endTime: '10:00',
    }),
  );

  // 2. Student creating timetable entry denied
  await assertFails(
    setDoc(doc(studentA, 'timetables', 'tt-stu'), {
      timetableId: 'tt-stu',
      schoolId: SCHOOL_A,
      teacherId: 'tch-a',
      teacherName: 'Teacher School A',
      className: 'Class 10',
      section: 'A',
      subject: 'Physics',
      dayOfWeek: 'Monday',
      startTime: '09:00',
      endTime: '10:00',
    }),
  );

  // 3. Authorized teacher creation succeeds
  await assertSucceeds(
    setDoc(doc(teacherA, 'timetables', 'tt-a1'), {
      timetableId: 'tt-a1',
      schoolId: SCHOOL_A,
      teacherId: 'tch-a',
      teacherName: 'Teacher School A',
      className: 'Class 10',
      section: 'A',
      subject: 'Physics',
      dayOfWeek: 'Monday',
      startTime: '09:00',
      endTime: '10:00',
    }),
  );

  // 4. Cross-school teacher reading timetable denied
  await assertFails(getDoc(doc(teacherB, 'timetables', 'tt-a1')));

  // 5. Cross-school teacher updating timetable denied
  await assertFails(
    updateDoc(doc(teacherB, 'timetables', 'tt-a1'), {
      subject: 'Chemistry',
    }),
  );

  // 6. Authorized teacher updating timetable succeeds
  await assertSucceeds(
    updateDoc(doc(teacherA, 'timetables', 'tt-a1'), {
      subject: 'Advanced Physics',
    }),
  );

  // 7. School Admin deleting timetable succeeds
  await assertSucceeds(doc(adminA, 'timetables', 'tt-a1').delete?.());
});

test('examAttendance Security Rules enforcement', async () => {
  const studentA = as('stu-a');
  const studentB = as('stu-b');
  const teacherA = as('tch-a');
  const teacherB = as('tch-b');
  const anon = unauth();

  // 1. Unauthenticated creation denied
  await assertFails(
    setDoc(doc(anon, 'examAttendance', 'eatt-anon'), {
      examAttendanceId: 'eatt-anon',
      examId: 'exam-a1',
      studentId: 'stu-a',
      schoolId: SCHOOL_A,
      className: 'Class 10',
      subject: 'Mathematics',
      status: 'Present',
      recordedBy: 'tch-a',
      recordedAt: '2026-10-25 09:30',
    }),
  );

  // 2. Student creating exam attendance denied
  await assertFails(
    setDoc(doc(studentA, 'examAttendance', 'eatt-stu'), {
      examAttendanceId: 'eatt-stu',
      examId: 'exam-a1',
      studentId: 'stu-a',
      schoolId: SCHOOL_A,
      className: 'Class 10',
      subject: 'Mathematics',
      status: 'Present',
      recordedBy: 'stu-a',
      recordedAt: '2026-10-25 09:30',
    }),
  );

  // 3. Forging recordedBy ID denied
  await assertFails(
    setDoc(doc(teacherA, 'examAttendance', 'eatt-a1'), {
      examAttendanceId: 'eatt-a1',
      examId: 'exam-a1',
      studentId: 'stu-a',
      schoolId: SCHOOL_A,
      className: 'Class 10',
      subject: 'Mathematics',
      status: 'Present',
      recordedBy: 'tch-b',
      recordedAt: '2026-10-25 09:30',
    }),
  );

  // 4. Authorized teacher creation succeeds
  await assertSucceeds(
    setDoc(doc(teacherA, 'examAttendance', 'eatt-a1'), {
      examAttendanceId: 'eatt-a1',
      examId: 'exam-a1',
      studentId: 'stu-a',
      schoolId: SCHOOL_A,
      className: 'Class 10',
      subject: 'Mathematics',
      status: 'Present',
      recordedBy: 'tch-a',
      recordedAt: '2026-10-25 09:30',
    }),
  );

  // 5. Student self-read succeeds
  await assertSucceeds(getDoc(doc(studentA, 'examAttendance', 'eatt-a1')));

  // 6. Student reading another student's exam attendance denied
  await assertFails(getDoc(doc(studentB, 'examAttendance', 'eatt-a1')));

  // 7. Cross-school teacher updating exam attendance denied
  await assertFails(
    updateDoc(doc(teacherB, 'examAttendance', 'eatt-a1'), {
      status: 'Absent',
    }),
  );

  // 8. Authorized teacher updating status succeeds
  await assertSucceeds(
    updateDoc(doc(teacherA, 'examAttendance', 'eatt-a1'), {
      status: 'Absent',
    }),
  );
});
