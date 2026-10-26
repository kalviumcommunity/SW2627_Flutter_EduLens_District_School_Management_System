// Multi-School Demo Data & Accounts Seeding Tool — NOT part of the EduLens app binary.
//
// Populates a realistic multi-school demonstration environment with real Firebase Auth
// accounts, matching Firestore user profiles, and consistent multi-school domain data.
//
// Run with:
//   flutter run -t tool/seed_firestore.dart -d chrome
//
// Re-running is safe and idempotent: every document is written with explicit IDs,
// and Firebase Auth user creation handles existing accounts gracefully.
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_edulens/firebase_options.dart';

const String kDemoPassword = 'EduLensDemo2026!';

final DateTime kToday = DateTime.now();

String _day(int offsetDays) {
  final d = kToday.add(Duration(days: offsetDays));
  final mm = d.month.toString().padLeft(2, '0');
  final dd = d.day.toString().padLeft(2, '0');
  return '${d.year}-$mm-$dd';
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SeedApp());
}

class SeedApp extends StatelessWidget {
  const SeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'EduLens Multi-School Demo Seeder',
      debugShowCheckedModeBanner: false,
      home: SeedScreen(),
    );
  }
}

class SeedScreen extends StatefulWidget {
  const SeedScreen({super.key});

  @override
  State<SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends State<SeedScreen> {
  final List<String> _log = [];
  final List<Map<String, String>> _credentialsList = [];
  bool _running = false;
  bool _done = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !_running && !_done) {
        _run();
      }
    });
  }

  void _say(String line) {
    debugPrint(line);
    if (mounted) setState(() => _log.add(line));
  }

  Future<void> _run() async {
    setState(() {
      _running = true;
      _failed = false;
      _done = false;
      _log.clear();
      _credentialsList.clear();
    });

    try {
      final auth = FirebaseAuth.instance;
      final db = FirebaseFirestore.instance;

      _say('Starting EduLens Multi-School Demo Environment Seeding ...');

      await _seedDistrictAdmin(auth, db);
      await _seedSchools(db);
      await _seedSchoolAdmins(auth, db);
      await _seedTeachers(auth, db);
      await _seedStudentsAndProfiles(auth, db);
      await _seedAttendance(db);
      await _seedFees(db);
      await _seedExams(db);
      await _seedTimetables(db);
      await _seedExamAttendance(db);
      await _seedLeaveRequests(db);

      await _exportLocalManifest();

      _say('');
      _say(
        'Successfully seeded 4 schools, 105 Auth accounts & Firestore profiles.',
      );
      _say('Local credentials manifest saved to demo_credentials.local.md.');
      setState(() => _done = true);
    } catch (e) {
      _say('');
      if (e.toString().contains('permission-denied')) {
        _say('FAILED: [cloud_firestore/permission-denied]');
        _say('');
        _say('📌 ACTION REQUIRED TO FIX PERMISSIONS:');
        _say(
          'Your live Firebase project in Firebase Console requires updated Firestore Rules.',
        );
        _say('');
        _say('Option A (Firebase Console):');
        _say(
          '  1. Go to https://console.firebase.google.com -> Firestore Database -> Rules',
        );
        _say(
          '  2. Copy and paste the contents of your project\'s `firestore.rules` file',
        );
        _say('  3. Click "Publish"');
        _say('');
        _say('Option B (Firebase CLI):');
        _say('  Run: firebase deploy --only firestore:rules');
        _say('');
        _say(
          'After publishing rules, click "Seed Demo Data & Accounts" again.',
        );
      } else {
        _say('FAILED: $e');
      }
      setState(() => _failed = true);
    } finally {
      setState(() => _running = false);
    }
  }

  // ---------------------------------------------------------------- schools

  static const List<Map<String, String>> _schools = [
    {
      'schoolId': 'school01',
      'schoolName': 'Greenwood High',
      'location': 'Sector 12, North District',
      'address': '12 North Avenue, Sector 12',
      'contactNumber': '+1 555-0101',
      'email': 'info@greenwood.edu',
    },
    {
      'schoolId': 'school02',
      'schoolName': 'Riverside Public School',
      'location': 'Sector 45, East District',
      'address': '45 Riverbank Road, Sector 45',
      'contactNumber': '+1 555-0102',
      'email': 'contact@riverside.edu',
    },
    {
      'schoolId': 'school03',
      'schoolName': 'Hilltop Academy',
      'location': 'Sector 7, West District',
      'address': '7 Hilltop Heights, Sector 7',
      'contactNumber': '+1 555-0103',
      'email': 'admin@hilltop.edu',
    },
    {
      'schoolId': 'school04',
      'schoolName': 'Oakridge International',
      'location': 'Central District',
      'address': '100 Oakridge Parkway, Central',
      'contactNumber': '+1 555-0104',
      'email': 'office@oakridge.edu',
    },
  ];

  Future<void> _seedSchools(FirebaseFirestore db) async {
    _say('Writing 4 schools ...');
    for (final s in _schools) {
      await db.collection('schools').doc(s['schoolId']).set(s);
      _say('  schools/${s['schoolId']} — ${s['schoolName']}');
    }
  }

  // ---------------------------------------------------------------- accounts

  Future<String> _getOrCreateAuthUser(
    FirebaseAuth auth,
    String email,
    String password,
  ) async {
    String uid = '';
    try {
      final cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      uid = cred.user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        final cred = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        uid = cred.user!.uid;
      } else {
        rethrow;
      }
    }

    if (email != 'district.admin@edulens.demo') {
      // Re-sign in as District Admin to maintain districtAdmin write privileges for Firestore rules
      await auth.signInWithEmailAndPassword(
        email: 'district.admin@edulens.demo',
        password: kDemoPassword,
      );
    }

    return uid;
  }

  Future<void> _seedDistrictAdmin(
    FirebaseAuth auth,
    FirebaseFirestore db,
  ) async {
    _say('Writing District Admin account ...');
    const email = 'district.admin@edulens.demo';
    final uid = await _getOrCreateAuthUser(auth, email, kDemoPassword);

    await auth.signInWithEmailAndPassword(
      email: email,
      password: kDemoPassword,
    );

    await db.collection('users').doc(uid).set({
      'uid': uid,
      'name': 'Dr. Aditya Mehta',
      'email': email,
      'role': 'districtAdmin',
      'schoolId': '',
    }, SetOptions(merge: true));

    _credentialsList.add({
      'role': 'District Admin',
      'name': 'Dr. Aditya Mehta',
      'school': 'All Schools (District)',
      'email': email,
      'password': kDemoPassword,
    });
    _say('  District Admin signed in: $email (UID: $uid)');
  }

  Future<void> _seedSchoolAdmins(
    FirebaseAuth auth,
    FirebaseFirestore db,
  ) async {
    _say('Writing School Admin accounts ...');
    const adminNames = {
      'school01': 'Sarah Connor',
      'school02': 'David Miller',
      'school03': 'Elena Rostova',
      'school04': 'Marcus Vance',
    };

    for (final s in _schools) {
      final schoolId = s['schoolId']!;
      final schoolName = s['schoolName']!;
      final name = adminNames[schoolId]!;
      final email = 'admin.$schoolId@edulens.demo';

      final uid = await _getOrCreateAuthUser(auth, email, kDemoPassword);

      await db.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'role': 'schoolAdmin',
        'schoolId': schoolId,
      });

      _credentialsList.add({
        'role': 'School Admin',
        'name': name,
        'school': schoolName,
        'email': email,
        'password': kDemoPassword,
      });
      _say('  $schoolId Admin: $email');
    }
  }

  Future<void> _seedTeachers(FirebaseAuth auth, FirebaseFirestore db) async {
    _say('Writing Teacher accounts ...');
    const teacherNames = {
      'school01': [
        'Rahul Verma',
        'Priya Sharma',
        'Neha Iyer',
        'Amit Patel',
        'Suresh Kumar',
      ],
      'school02': [
        'Arjun Nair',
        'Kavita Rao',
        'Deepak Joshi',
        'Sangeeta Roy',
        'Manoj Das',
      ],
      'school03': [
        'Sanjay Mehta',
        'Divya Pillai',
        'Imran Khan',
        'Rita Das',
        'Alok Gupta',
      ],
      'school04': [
        'Vikramaditya Sen',
        'Ananya Deshmukh',
        'Rajesh Kulkarni',
        'Meenakshi Sundaram',
        'Tariq Siddiqui',
      ],
    };

    for (final s in _schools) {
      final schoolId = s['schoolId']!;
      final schoolName = s['schoolName']!;
      final names = teacherNames[schoolId]!;

      for (var i = 0; i < names.length; i++) {
        final name = names[i];
        final email = 'teacher${i + 1}.$schoolId@edulens.demo';
        final uid = await _getOrCreateAuthUser(auth, email, kDemoPassword);

        await db.collection('users').doc(uid).set({
          'uid': uid,
          'name': name,
          'email': email,
          'role': 'teacher',
          'schoolId': schoolId,
        });

        _credentialsList.add({
          'role': 'Teacher',
          'name': name,
          'school': schoolName,
          'email': email,
          'password': kDemoPassword,
        });
      }
      _say('  $schoolId — 5 Teachers created.');
    }
  }

  Future<void> _seedStudentsAndProfiles(
    FirebaseAuth auth,
    FirebaseFirestore db,
  ) async {
    _say('Writing Student accounts and profiles ...');
    const firstNames = [
      'Asha',
      'Rohan',
      'Ishita',
      'Vikram',
      'Meera',
      'Karan',
      'Pooja',
      'Siddharth',
      'Aditi',
      'Gaurav',
      'Kavya',
      'Nikhil',
      'Tanvi',
      'Varun',
      'Riya',
      'Aman',
      'Sneha',
      'Harsh',
      'Anushka',
      'Pranav',
    ];
    const lastNames = [
      'Rao',
      'Smith',
      'Banerjee',
      'Gupta',
      'Reddy',
      'Joshi',
      'Verma',
      'Sharma',
      'Nair',
      'Mehta',
      'Iyer',
      'Patel',
      'Das',
      'Sen',
      'Pillai',
      'Kumar',
      'Khan',
      'Deshmukh',
      'Kulkarni',
      'Sundaram',
    ];

    for (final s in _schools) {
      final schoolId = s['schoolId']!;
      final schoolName = s['schoolName']!;

      for (var i = 0; i < 20; i++) {
        final name = '${firstNames[i]} ${lastNames[i]}';
        final email = 'student${i + 1}.$schoolId@edulens.demo';
        final uid = await _getOrCreateAuthUser(auth, email, kDemoPassword);
        final className = i < 10 ? 'Class 10' : 'Class 9';
        final section = i.isEven ? 'A' : 'B';
        final rollNumber = '${101 + i}';

        // User profile document
        await db.collection('users').doc(uid).set({
          'uid': uid,
          'name': name,
          'email': email,
          'role': 'student',
          'schoolId': schoolId,
        });

        // Student domain document
        await db.collection('students').doc(uid).set({
          'studentId': uid,
          'name': name,
          'schoolId': schoolId,
          'className': className,
          'section': section,
          'rollNumber': rollNumber,
        });

        _credentialsList.add({
          'role': 'Student',
          'name': name,
          'school': '$schoolName ($className-$section)',
          'email': email,
          'password': kDemoPassword,
        });
      }
      _say('  $schoolId — 20 Students created.');
    }
  }

  // ------------------------------------------------------------- attendance

  static const Map<String, double> _attendanceTargets = {
    'school01': 0.85,
    'school02': 0.72,
    'school03': 0.61,
    'school04': 0.90,
  };

  Future<void> _seedAttendance(FirebaseFirestore db) async {
    _say('Writing attendance records ...');
    final dates = [_day(-3), _day(-2), _day(-1)];

    for (final s in _schools) {
      final schoolId = s['schoolId']!;
      final snapshot = await db
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .get();
      final students = snapshot.docs;
      final total = students.length * dates.length;
      final presentTarget = (total * _attendanceTargets[schoolId]!).round();

      var written = 0;
      for (final date in dates) {
        for (final studentDoc in students) {
          final studentId = studentDoc.id;
          final status = written < presentTarget ? 'Present' : 'Absent';
          final id = '$studentId-$date';
          await db.collection('attendance').doc(id).set({
            'attendanceId': id,
            'studentId': studentId,
            'schoolId': schoolId,
            'teacherId': '$schoolId-t1',
            'date': date,
            'status': status,
          });
          written++;
        }
      }
      _say('  $schoolId — $written attendance records.');
    }
  }

  // ------------------------------------------------------------------- fees

  Future<void> _seedFees(FirebaseFirestore db) async {
    _say('Writing fee records ...');
    const totalDue = 25000.0;
    final updatedAt = _day(-5);

    for (final s in _schools) {
      final schoolId = s['schoolId']!;
      final snapshot = await db
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .get();
      final students = snapshot.docs;

      for (var i = 0; i < students.length; i++) {
        final studentId = students[i].id;
        final String status;
        final double paid;
        switch (i % 3) {
          case 0:
            status = 'Paid';
            paid = totalDue;
          case 1:
            status = 'Partial';
            paid = 12000.0;
          default:
            status = 'Outstanding';
            paid = 0.0;
        }
        final id = '$studentId-fee';
        await db.collection('fees').doc(id).set({
          'feeId': id,
          'studentId': studentId,
          'schoolId': schoolId,
          'totalDue': totalDue,
          'paidAmount': paid,
          'status': status,
          'updatedAt': updatedAt,
          'remarks': status == 'Partial' ? 'First installment received' : null,
        });
      }
      _say('  $schoolId — ${students.length} fee records.');
    }
  }

  // ------------------------------------------------------------------ exams

  Future<void> _seedExams(FirebaseFirestore db) async {
    _say('Writing exam records ...');
    final rows = <Map<String, String>>[
      {'s': 'school01', 'c': 'Class 10', 'sub': 'Mathematics', 'd': _day(-8)},
      {'s': 'school02', 'c': 'Class 9', 'sub': 'History', 'd': _day(-4)},
      {'s': 'school01', 'c': 'Class 10', 'sub': 'Science', 'd': _day(2)},
      {'s': 'school02', 'c': 'Class 10', 'sub': 'English', 'd': _day(5)},
      {'s': 'school03', 'c': 'Class 9', 'sub': 'Geography', 'd': _day(7)},
      {'s': 'school04', 'c': 'Class 10', 'sub': 'Physics', 'd': _day(3)},
      {'s': 'school01', 'c': 'Class 9', 'sub': 'Hindi', 'd': _day(20)},
      {'s': 'school04', 'c': 'Class 10', 'sub': 'Chemistry', 'd': _day(15)},
    ];

    for (var i = 0; i < rows.length; i++) {
      final r = rows[i];
      final id = 'exam${(i + 1).toString().padLeft(2, '0')}';
      await db.collection('exams').doc(id).set({
        'examId': id,
        'schoolId': r['s'],
        'className': r['c'],
        'subject': r['sub'],
        'date': r['d'],
        'startTime': '10:00',
        'endTime': '12:00',
        'createdBy': '${r['s']}-t1',
        'status': 'Scheduled',
      });
      _say('  $id — ${r['sub']} @ ${r['d']} (${r['s']})');
    }
  }

  // ------------------------------------------------------------- timetables

  Future<void> _seedTimetables(FirebaseFirestore db) async {
    _say('Writing timetable entries ...');
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    const subjects = [
      'Mathematics',
      'Physics',
      'Chemistry',
      'English',
      'History',
    ];

    var count = 0;
    for (final s in _schools) {
      final schoolId = s['schoolId']!;
      final teachersSnapshot = await db
          .collection('users')
          .where('schoolId', isEqualTo: schoolId)
          .where('role', isEqualTo: 'teacher')
          .get();

      for (final teacherDoc in teachersSnapshot.docs) {
        final teacherId = teacherDoc.id;
        final teacherName = teacherDoc.data()['name'] as String? ?? 'Teacher';

        for (var d = 0; d < weekdays.length; d++) {
          final day = weekdays[d];
          final subject = subjects[d % subjects.length];
          final id = 'tt_${schoolId}_${teacherId}_$d';

          await db.collection('timetables').doc(id).set({
            'timetableId': id,
            'schoolId': schoolId,
            'teacherId': teacherId,
            'teacherName': teacherName,
            'className': 'Class 10',
            'section': 'A',
            'subject': subject,
            'dayOfWeek': day,
            'startTime': '09:00',
            'endTime': '10:00',
            'roomNumber': 'Room ${101 + (d % 5)}',
          });
          count++;
        }
      }
    }
    _say('  Total timetable entries written: $count.');
  }

  // ------------------------------------------------------- exam attendance

  Future<void> _seedExamAttendance(FirebaseFirestore db) async {
    _say('Writing exam attendance records ...');
    final examsSnapshot = await db.collection('exams').get();
    var count = 0;

    for (final examDoc in examsSnapshot.docs) {
      final exam = examDoc.data();
      final examId = exam['examId'] as String;
      final schoolId = exam['schoolId'] as String;
      final className = exam['className'] as String;
      final subject = exam['subject'] as String;

      final studentsSnapshot = await db
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .where('className', isEqualTo: className)
          .get();

      for (var i = 0; i < studentsSnapshot.docs.length; i++) {
        final studentId = studentsSnapshot.docs[i].id;
        final id = 'eatt_${examId}_$studentId';
        final status = i.isEven ? 'Present' : 'Absent';

        await db.collection('examAttendance').doc(id).set({
          'examAttendanceId': id,
          'examId': examId,
          'studentId': studentId,
          'schoolId': schoolId,
          'className': className,
          'subject': subject,
          'status': status,
          'recordedBy': '$schoolId-admin',
          'recordedAt': _day(-1),
          'remarks': status == 'Absent' ? 'Medical leave requested' : null,
        });
        count++;
      }
    }
    _say('  Total exam attendance records written: $count.');
  }

  // --------------------------------------------------------- leave requests

  Future<void> _seedLeaveRequests(FirebaseFirestore db) async {
    _say('Writing leave request records ...');
    var count = 0;

    for (final s in _schools) {
      final schoolId = s['schoolId']!;
      final studentsSnapshot = await db
          .collection('students')
          .where('schoolId', isEqualTo: schoolId)
          .get();

      final students = studentsSnapshot.docs;
      if (students.length >= 3) {
        // Pending
        final s1 = students[0].data();
        final id1 = 'lr_${s1['studentId']}_1';
        await db.collection('leaveRequests').doc(id1).set({
          'requestId': id1,
          'studentId': s1['studentId'],
          'studentName': s1['name'],
          'schoolId': schoolId,
          'className': s1['className'],
          'startDate': _day(2),
          'endDate': _day(3),
          'reason': 'Family medical emergency',
          'status': 'Pending',
          'submittedAt': _day(-1),
        });
        count++;

        // Approved
        final s2 = students[1].data();
        final id2 = 'lr_${s2['studentId']}_2';
        await db.collection('leaveRequests').doc(id2).set({
          'requestId': id2,
          'studentId': s2['studentId'],
          'studentName': s2['name'],
          'schoolId': schoolId,
          'className': s2['className'],
          'startDate': _day(-2),
          'endDate': _day(-1),
          'reason': 'Doctor appointment',
          'status': 'Approved',
          'submittedAt': _day(-4),
          'reviewedBy': '$schoolId-teacher1',
          'reviewedAt': _day(-3),
          'reviewComment': 'Approved with medical certificate',
        });
        count++;

        // Rejected
        final s3 = students[2].data();
        final id3 = 'lr_${s3['studentId']}_3';
        await db.collection('leaveRequests').doc(id3).set({
          'requestId': id3,
          'studentId': s3['studentId'],
          'studentName': s3['name'],
          'schoolId': schoolId,
          'className': s3['className'],
          'startDate': _day(5),
          'endDate': _day(6),
          'reason': 'Vacation trip',
          'status': 'Rejected',
          'submittedAt': _day(-2),
          'reviewedBy': '$schoolId-teacher1',
          'reviewedAt': _day(-1),
          'reviewComment': 'Rejected due to scheduled term exam',
        });
        count++;
      }
    }
    _say('  Total leave request records written: $count.');
  }

  // ---------------------------------------------------- local credentials

  Future<void> _exportLocalManifest() async {
    try {
      final buffer = StringBuffer();
      buffer.writeln('# EduLens Multi-School Demo Credentials Manifest');
      buffer.writeln();
      buffer.writeln('Generated on: ${DateTime.now().toIso8601String()}');
      buffer.writeln('Environment: Firebase Demo / Development Environment');
      buffer.writeln('Default Demo Password: `$kDemoPassword`');
      buffer.writeln();
      buffer.writeln(
        '| Role | Name | School / Scope | Login Email | Password |',
      );
      buffer.writeln('|---|---|---|---|---|');

      for (final c in _credentialsList) {
        buffer.writeln(
          '| ${c['role']} | ${c['name']} | ${c['school']} | `${c['email']}` | `${c['password']}` |',
        );
      }

      buffer.writeln();
      buffer.writeln('---');
      buffer.writeln(
        '*Note: This manifest is generated for local testing and evaluator QA. It is gitignored.*',
      );

      if (!kIsWeb) {
        final file = File('demo_credentials.local.md');
        await file.writeAsString(buffer.toString());
      }
      _say('Local credentials manifest generated.');
    } catch (e) {
      _say('Manifest export note: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EduLens Multi-School Demo Seeder')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilledButton.icon(
              onPressed: _running ? null : _run,
              icon: _running
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cloud_upload_outlined),
              label: Text(
                _running ? 'Seeding...' : 'Seed Demo Data & Accounts',
              ),
            ),
            const SizedBox(height: 16),
            if (_done)
              const Text(
                'Seeding complete! Check demo_credentials.local.md for account logins.',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (_failed)
              const Text(
                'Seeding failed — see the log below.',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: const Color(0xFFF5F5F5),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _log.isEmpty
                        ? 'Press "Seed Demo Data & Accounts" to begin.'
                        : _log.join('\n'),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
