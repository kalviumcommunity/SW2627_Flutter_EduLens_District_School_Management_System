# EduLens — Product Requirements Document (PRD)

---

## Document Control

| Property | Value |
| :--- | :--- |
| **Product Name** | EduLens |
| **Product Category** | District & School Management System |
| **Document Title** | Comprehensive Product Requirements Document (PRD) |
| **Document Version** | 2.1 (Post-MVP Acceptance Audit & Hardened Architecture) |
| **Document Status** | Approved for Implementation & Verification (Production Deployment Conditional) |
| **Repository URL** | `https://github.com/kalviumcommunity/SW2627_Flutter_EduLens_District_School_Management_System` |
| **Target Platforms** | Android (Mobile), Web (Responsive Browser), iOS |
| **Backend Infrastructure** | Google Cloud Firestore, Firebase Authentication |
| **Date of Preparation** | November 2026 |
| **Authors & Contributors** | Senior Product Manager, Technical Documentation Engineer, Solutions Architect |
| **Intended Audience** | District Education Officers, School Administrators, Teaching Staff, Engineering Leads, QA Teams, Security & Compliance Auditors |

### Document Revision History

| Version | Date | Primary Author | Description of Changes |
| :--- | :--- | :--- | :--- |
| **1.0** | September 2026 | Product Team | Initial PRD baseline covering core 4-role vision, wireframe definitions, and preliminary domain concepts. |
| **2.0** | October 2026 | Architecture Team | Aligned data models with Firestore schema; introduced formal metric calculations; addressed Day 5 data model gaps. |
| **2.1** | November 2026 | Senior PM & Tech Leads | Comprehensive repository-grounded PRD reconciliation reflecting complete `lib/` implementation, resolved model gaps, Firestore Security Rules hardening, cross-role journey audits, and deployment prerequisites. |

### Document Approvals & Sign-off Placeholders

| Role | Sign-off Name | Title / Organization | Status | Date |
| :--- | :--- | :--- | :--- | :--- |
| **Lead Product Manager** | *[Pending Final Sign-off]* | District Academic Systems Directorate | Under Review | 2026-11-04 |
| **Technical Architect** | *[Pending Final Sign-off]* | Cloud & Mobile Platforms Division | Verified Codebase | 2026-11-04 |
| **Security & Privacy Lead** | *[Pending Final Sign-off]* | Information Security & Compliance Office | Conditional Approval | 2026-11-04 |
| **Quality Assurance Lead** | *[Pending Final Sign-off]* | Software Quality & Testing Practice | Verified Tests | 2026-11-04 |

---

## Table of Contents

- [Cover and Document Control](#document-control)
- [1. Executive Summary](#1-executive-summary)
- [2. Problem Statement](#2-problem-statement)
- [3. Product Vision and Objectives](#3-product-vision-and-objectives)
- [4. Stakeholders and User Personas](#4-stakeholders-and-user-personas)
- [5. Product Scope & Feature Classification Matrix](#5-product-scope--feature-classification-matrix)
- [6. Functional Requirements](#6-functional-requirements)
  - [6.1 Authentication](#61-authentication)
  - [6.2 User Onboarding, Bootstrap & Role Routing](#62-user-onboarding-bootstrap--role-routing)
  - [6.3 District Administration](#63-district-administration)
  - [6.4 School Administration](#64-school-administration)
  - [6.5 Teacher Workflows](#65-teacher-workflows)
  - [6.6 Student Workflows](#66-student-workflows)
  - [6.7 Data Management & Atomic Batch Operations](#67-data-management--atomic-batch-operations)
  - [6.8 Dashboard Metrics & Algorithmic Rules](#68-dashboard-metrics--algorithmic-rules)
  - [6.9 Error Handling & System Recovery](#69-error-handling--system-recovery)
- [7. Role-Permission Matrix](#7-role-permission-matrix)
- [8. User Journeys and Use Cases](#8-user-journeys-and-use-cases)
- [9. Data and Business Requirements](#9-data-and-business-requirements)
- [10. Non-Functional Requirements](#10-non-functional-requirements)
- [11. Validation Rules and Error Handling](#11-validation-rules-and-error-handling)
- [12. Acceptance Criteria](#12-acceptance-criteria)
- [13. Dependencies and Technical Constraints](#13-dependencies-and-technical-constraints)
- [14. Risks, Technical Debt, and Open Questions](#14-risks-technical-debt-and-open-questions)
- [15. Out of Scope and Future Enhancements](#15-out-of-scope-and-future-enhancements)
- [16. Glossary](#16-glossary)

---

## 1. Executive Summary

### 1.1 Product Definition
**EduLens** is an integrated District & School Management System built using Flutter and Dart, backed natively by Google Cloud Firestore and Firebase Authentication. The platform delivers dual-tiered operational capabilities: macro-level administrative intelligence for regional district officers, and micro-level operational execution tools for individual school administrators, teachers, and enrolled students.

### 1.2 The Problem Addressed
Education districts oversee dozens of schools dispersed across wide geographic territories. Traditionally, district authorities depend on fragmented, manual, and asynchronous reporting mechanisms—such as physical registers, periodic telephone briefings, and emailed spreadsheets. This creates a critical lag between school ground reality and executive decision-making. Low student attendance trends go unnoticed until dropouts occur, fee collection bottlenecks stall administrative budgets, and examination scheduling conflicts remain unresolved across regional clusters.

### 1.3 Core Product Value
EduLens unifies district oversight and classroom workflows into a single multi-tenant mobile and web client application without the complexity of an intermediate custom API server. By implementing direct-to-database architectural contracts secured by Cloud Firestore Security Rules, EduLens provides:
1. **Centralized District Oversight**: Real-time aggregation of attendance averages, amount-weighted fee collections, upcoming examination pipelines, and automated attention threshold alerts (<70% attendance).
2. **Decentralized School Autonomy**: School administrators manage institutional contact information, inspect student rosters, and track individual fee settlement statuses.
3. **Classroom Operational Agility**: Teachers rapidly register daily classroom attendance in atomic batches, review timetable schedules, inspect upcoming school exams, and adjudicate student leave requests.
4. **Student Academic Transparency**: Students access a personalized, tamper-proof, read-only dashboard reflecting their exact daily attendance record, financial fee dues, and examination timetables.

### 1.4 Role Summaries and Implemented Workflows
The application recognizes four strictly segregated user roles:

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                                 EduLens                                     │
└──────┬──────────────────────┬───────────────────────┬───────────────────────┘
       │                      │                       │                       │
       ▼                      ▼                       ▼                       ▼
┌──────────────┐      ┌──────────────┐        ┌──────────────┐        ┌──────────────┐
│District Admin│      │ School Admin │        │   Teacher    │        │   Student    │
├──────────────┤      ├──────────────┤        ├──────────────┤        ├──────────────┤
│• District KPI│      │• School KPI  │        │• Teacher KPI │        │• Attendance  │
│• School List │      │• Student List│        │• Daily Attend│        │• Fee Balance │
│• School Info │      │• Fee Records │        │• Timetable   │        │• Exam Dates  │
│• Exam Cal    │      │• School Info │        │• School Exams│        │• Leave Submit│
│• Exam Detail │      │• Exam Manage │        │• Leave Review│        │• Profile/Out │
└──────────────┘      └──────────────┘        └──────────────┘        └──────────────┘
```

- **District Administrator**: Exercises district-wide read/write governance; evaluates aggregated multi-school metrics; inspects granular school details; audits school rosters; tracks district-wide examination schedules and classroom seating allocations.
- **School Administrator**: Governs institutional operations for a single provisioned school; maintains school contact details (address, telephone, email); monitors school-wide student enrollment; audits and updates individual student fee payment balances; schedules academic examinations.
- **Teacher**: Drives daily classroom execution; conducts atomic batch attendance recording for assigned classes; inspects today's scheduled classes and weekly timetable allocations; views scheduled school exams; evaluates, approves, or rejects student leave requests with review remarks.
- **Student**: Accesses a personalized academic dashboard; inspects verified attendance percentages and categorical breakdowns (Present / Absent / Leave); verifies financial fee settlement balances; reviews upcoming school examinations; submits leave requests with structured date ranges and justifications.

---

## 2. Problem Statement

### 2.1 The Multi-School Monitoring Dilemma
Regional school districts face substantial logistical barriers in monitoring institutional health across distributed schools. District administrators lack immediate, authoritative visibility into:
- Whether students are attending school consistently across suburban, urban, and rural clusters.
- Which specific schools are experiencing critical attendance drops requiring immediate intervention.
- The aggregate financial solvency of schools regarding student fee recovery.
- Coordinated scheduling of district-wide midterm and final examinations.

### 2.2 Consequences of Fragmented Reporting
When reporting depends on disparate communication channels, multiple operational failures emerge:
1. **Delayed Intervention**: By the time monthly attendance reports reach the district office, at-risk students have already accumulated severe absenteeism.
2. **Financial Inaccuracy**: Discrepancies between total fees assessed and actual fees collected result in unexpected institutional deficits.
3. **Examination Conflicts**: Unsynchronized exam schedules create resource contention and scheduling clashes within clusters.
4. **Data Tampering & Administrative Overhead**: Manual paper records are prone to alteration, damage, and human calculation error.

### 2.3 District-Level vs. School-Level Needs
| Dimension | District-Level Need | School-Level Need |
| :--- | :--- | :--- |
| **Scope of View** | Macro: All schools, cross-institutional comparisons, regional averages. | Micro: Single school, classroom rosters, student-specific records. |
| **Operational Cadence** | Weekly, monthly, and seasonal performance auditing. | Daily classroom attendance, per-period schedule tracking, real-time fee updates. |
| **Action Triggers** | System-wide attention alerts (e.g. attendance < 70%). | Instant register submission, leave approval, exam scheduling. |
| **Data Interaction** | High read aggregation; authoritative structural writes (e.g., provisioning schools). | High write velocity (daily attendance records, fee status changes). |

### 2.4 Confirmed Requirements vs. Inferred Benefits
To preserve rigorous engineering integrity, this PRD distinguishes between verified project requirements and secondary organizational benefits:

- **Confirmed Repository Requirements**:
  - Direct Firebase Authentication integration with email/password credentials and password reset triggers.
  - Role-based routing derived from authenticated Firestore user profiles (`users/{uid}`).
  - Strict mathematical formula enforcement for attendance rates, amount-weighted fee percentages, and 7-day upcoming exam windows.
  - Server-side access enforcement via Firestore Security Rules prohibiting cross-student and cross-school data leakage.
  - Atomic batch writes for classroom attendance registers to prevent partial record persistence.
- **Inferred Organizational Benefits (Non-Binding)**:
  - Long-term improvement in regional literacy and graduation rates.
  - Reduction in administrative carbon footprint through paperless digitization.
  - Enhanced parent-teacher trust and improved institutional reputation.

---

## 3. Product Vision and Objectives

### 3.1 Product Vision
To establish EduLens as a secure, responsive, and verifiable District & School Management standard that democratizes institutional data—empowering regional leaders with holistic oversight while equipping classroom teachers and students with friction-free operational tools.

### 3.2 Primary Objectives
1. **Unified Multi-School Governance**: Provide district leadership with a real-time, consolidated dashboard summarizing institutional metrics across all regional schools.
2. **Decentralized Operational Precision**: Enable school administrators and educators to record and modify data within their authorized scope without impacting adjacent institutions.
3. **Database-Enforced Multi-Tenancy**: Enforce data boundary isolation directly at the database tier using Firestore Security Rules, ensuring security is guaranteed even if client application controls are bypassed.
4. **Mathematical Consistency**: Guarantee identical metric calculation algorithms across all application screens via centralized metric utilities (`lib/core/utils/metrics.dart`).
5. **Zero-Friction Authentication & Bootstrap**: Ensure transparent user routing based on validated user profile documents with comprehensive error handling for corrupted or unassigned roles.

### 3.3 Expected User Outcomes
- **District Administrators**: Identify schools falling below the 70% attendance threshold within seconds of opening the application.
- **School Administrators**: Maintain updated institutional contact records and accurately manage fee accounts with zero risk of overpayment recording.
- **Teachers**: Mark attendance for an entire classroom roster in under 60 seconds with atomic persistence.
- **Students**: Review verified personal attendance standing, outstanding fee balances, and upcoming exam schedules on a unified personal view.

### 3.4 MVP Scope Baseline
The EduLens MVP encompasses the complete four-role lifecycle:
- Core Firebase email/password authentication and password reset dispatch.
- User profile resolution and dynamic role routing with edge-case handling.
- District dashboard, school directory, school details breakdown, district exam calendar, and exam seating breakdown.
- School administrator dashboard, school contact information editor, and student fee roster management.
- Teacher dashboard, daily timetable view, classroom attendance taking, and student leave request adjudication.
- Student dashboard, read-only examination timetable, and leave request submission dialog.
- Core shared profile and secure sign-out flows.

### 3.5 Explicitly Excluded Capabilities (Non-Goals)
The following capabilities are deliberately excluded from the current EduLens architecture:
1. **Third-Party Payment Gateways**: No direct credit card, UPI, or banking integrations. Fee payments are recorded administratively by School Administrators.
2. **Student & Teacher Self-Registration**: Users cannot create accounts independently within the client app; accounts and Firestore profiles are provisioned administratively or via administrative seeding scripts (`tool/seed_firestore.dart`).
3. **Grading & Report Card Generation**: No numerical mark storage, GPA calculation, or report card PDF rendering in the current schema.
4. **Parent/Guardian Portals**: No distinct parent persona or parent-student account linkage.
5. **Push Notifications & SMS Messaging**: No automated push notifications or SMS alerts for absences or upcoming exams.
6. **Multi-District Federation**: The system operates against a single regional district scope per deployment.

---

## 4. Stakeholders and User Personas

EduLens specifically defines and models **four** canonical user roles. No external auditor, parent, principal, accountant, or government authority role is implemented in the repository.

```
+---------------------------------------------------------------------------------------+
|                                    CANONICAL ROLES                                    |
+--------------------------+--------------------------+---------------------------------+
| Role String (`users.role`)| Canonical Normalized Form| Assigned Scope                  |
+--------------------------+--------------------------+---------------------------------+
| `districtAdmin`          | `districtAdmin`          | District-Wide (All Schools)     |
| `schoolAdmin`            | `schoolAdmin`            | Single School (`users.schoolId`)|
| `teacher`                | `teacher`                | Single School (`users.schoolId`)|
| `student`                | `student`                | Single Student (`studentId==uid`)|
+--------------------------+--------------------------+---------------------------------+
```

---

### 4.1 Persona 1: District Administrator (`districtAdmin`)

| Attribute | Details |
| :--- | :--- |
| **Role Representation** | Regional Superintendent, District Education Officer, Academic Inspector. |
| **User Profile Definition** | Document at `users/{uid}` with `role: 'districtAdmin'` and optional/null `schoolId`. |
| **Core Responsibilities** | - Monitor regional school performance and operational stability.<br>- Track district-wide attendance averages and identify underperforming schools.<br>- Audit regional fee recovery progress.<br>- Inspect scheduled examinations and student seating allocations across all schools.<br>- Provision and manage school organizational records. |
| **Primary Goals** | - Obtain instant visibility into schools requiring immediate supervisory intervention.<br>- Eliminate reporting latency across public and private educational institutions in the district.<br>- Ensure uniform examination schedules and equitable resource distribution. |
| **High-Level Permissions** | - **Read**: Full district-wide access to `users`, `schools`, `students`, `attendance`, `fees`, `exams`, `leaveRequests`, `timetables`, `examAttendance`.<br>- **Create/Update/Delete**: Full administrative privilege across all collections, including school provisioning and structural updates. |
| **Relevant Screens** | - `DistrictShell` (`lib/features/district/screens/district_shell.dart`)<br>- `DistrictDashboardScreen` (`lib/features/district/screens/district_dashboard_screen.dart`)<br>- `SchoolListScreen` (`lib/features/district/screens/school_list_screen.dart`)<br>- `SchoolDetailsScreen` (`lib/features/district/screens/school_details_screen.dart`)<br>- `DistrictExamOverviewScreen` (`lib/features/district/screens/district_exam_overview_screen.dart`)<br>- `ExamDetailsScreen` (`lib/features/district/screens/exam_details_screen.dart`) |
| **Primary Pain Points** | - Stale paper summaries masking sudden drop-offs in attendance.<br>- Lack of standardized formulas across different institutional reporting officers.<br>- Inability to verify if reported student enrollments match classroom realities. |
| **Expected App Outcomes**| Access real-time derived metrics with automated highlight badges for any school with attendance below 70%. |

---

### 4.2 Persona 2: School Administrator (`schoolAdmin`)

| Attribute | Details |
| :--- | :--- |
| **Role Representation** | School Principal, Headmaster, Administrative Operations Director. |
| **User Profile Definition** | Document at `users/{uid}` with `role: 'schoolAdmin'` and mandatory `schoolId`. |
| **Core Responsibilities** | - Supervise day-to-day administrative health of an assigned school.<br>- Maintain accurate school identity and contact records (address, phone, email).<br>- Monitor institutional student rosters and teacher headcount.<br>- Audit student fee payment accounts, record partial/full payments, and append audit remarks.<br>- Schedule institutional examinations. |
| **Primary Goals** | - Keep school public directory details up to date.<br>- Ensure accurate student fee collection accounting and prevent overpayment entry.<br>- Coordinate internal exam scheduling with teaching departments. |
| **High-Level Permissions** | - **Read**: Full read access to records scoped to their assigned `schoolId` across `schools`, `students`, `attendance`, `fees`, `exams`, `timetables`, `examAttendance`, `leaveRequests`.<br>- **Create/Update**: Update school contact info (address, phone, email); create/update fees for assigned school students; create/update/delete exams for assigned school; update leave request status.<br>- **Restricted**: Cannot alter `schoolId`, `schoolName`, or `location` of the school document; cannot access or modify records of other schools. |
| **Relevant Screens** | - `SchoolAdminShell` (`lib/features/school_admin/screens/school_admin_shell.dart`)<br>- `SchoolAdminDashboardScreen` (`lib/features/school_admin/screens/school_admin_dashboard_screen.dart`)<br>- `StudentFeeManagementScreen` (`lib/features/school_admin/screens/student_fee_management_screen.dart`)<br>- `SchoolInfoScreen` (`lib/features/school_admin/screens/school_info_screen.dart`)<br>- `SchoolExamScheduleScreen` (`lib/features/school_admin/screens/school_exam_schedule_screen.dart`) |
| **Primary Pain Points** | - Cumbersome manual spreadsheets leading to ledger mismatches and overpayments.<br>- Difficulty maintaining accurate school contact information across regional registries.<br>- Lack of quick classroom-level fee auditing. |
| **Expected App Outcomes**| Seamless fee status updates with strict client-side and server-side overpayment validation, instant roster search, and institutional KPI visualization. |

---

### 4.3 Persona 3: Teacher (`teacher`)

| Attribute | Details |
| :--- | :--- |
| **Role Representation** | Classroom Educator, Subject Teacher, Class Tutor. |
| **User Profile Definition** | Document at `users/{uid}` with `role: 'teacher'` and mandatory `schoolId`. |
| **Core Responsibilities** | - Mark daily classroom attendance for enrolled students.<br>- Review today's assigned teaching periods and weekly class timetable schedules.<br>- Inspect upcoming school examinations.<br>- Review, adjudicate (approve/reject), and comment on student leave submissions. |
| **Primary Goals** | - Rapidly record classroom attendance without disruption to instructional time.<br>- Avoid double-marking or partial-register persistence failures.<br>- Maintain a clear schedule of teaching assignments and examination responsibilities. |
| **High-Level Permissions** | - **Read**: School-scoped access to `students`, `attendance`, `exams`, `timetables`, `examAttendance`, `leaveRequests`, and peer teacher user profiles.<br>- **Create/Update**: Record classroom attendance in atomic batches; create/update school-scoped exams; update student leave request status (`Approved`/`Rejected`) with teacher comments.<br>- **Restricted**: Prohibited from reading or modifying financial fee records; prohibited from accessing records of outside schools. |
| **Relevant Screens** | - `TeacherShell` (`lib/features/teacher/screens/teacher_shell.dart`)<br>- `TeacherHomeScreen` (`lib/features/teacher/screens/teacher_home_screen.dart`)<br>- `AttendanceManagementScreen` (`lib/features/teacher/screens/attendance_management_screen.dart`)<br>- `TeacherTimetableScreen` (`lib/features/teacher/screens/teacher_timetable_screen.dart`)<br>- `TeacherLeaveReviewScreen` (`lib/features/teacher/screens/teacher_leave_review_screen.dart`)<br>- `SchoolExamScheduleScreen` (`lib/features/school_admin/screens/school_exam_schedule_screen.dart`) |
| **Primary Pain Points** | - Tedious paper attendance rosters leading to lost instructional minutes.<br>- Network drops causing partial register saves.<br>- Unorganized student paper leave notes. |
| **Expected App Outcomes**| Intuitive one-tap attendance toggling with atomic Firestore batch commits, clear visual schedule displays, and formalized leave review workflows. |

---

### 4.4 Persona 4: Student (`student`)

| Attribute | Details |
| :--- | :--- |
| **Role Representation** | Enrolled Pupil, Secondary Student. |
| **User Profile Definition** | Document at `users/{uid}` with `role: 'student'`, optional/provisioned `schoolId`, and matching `students/{uid}` document. |
| **Core Responsibilities** | - Monitor personal academic attendance percentages and compliance standing.<br>- Verify personal fee dues, payments made, and remaining balances.<br>- Inspect upcoming examination timetables for their school.<br>- Submit formal leave requests with dates and rationale. |
| **Primary Goals** | - Keep track of attendance to prevent falling below institutional thresholds (<70%).<br>- Verify fee balances and payments acknowledged by school administration.<br>- Prepare for scheduled school examinations. |
| **High-Level Permissions** | - **Read**: Strictly isolated to own user profile (`users/{uid}`), own student record (`students/{studentId}` where `studentId == uid`), own attendance records (`attendance` where `studentId == uid`), own fee records (`fees` where `studentId == uid`), own leave requests (`leaveRequests` where `studentId == uid`), and school-scoped examinations (`exams` where `schoolId == users.schoolId`).<br>- **Create**: Create new leave requests with `status: 'Pending'`.<br>- **Restricted**: Absolutely read-only for attendance, fees, and exams; strictly prohibited from reading classmate data; cannot delete or modify approved/rejected leave requests. |
| **Relevant Screens** | - `StudentShell` (`lib/features/student/screens/student_shell.dart`)<br>- `StudentDashboardScreen` (`lib/features/student/screens/student_dashboard_screen.dart`)<br>- `SchoolExamScheduleScreen` (Read-only mode, `allowScheduling: false`)<br>- `SubmitLeaveRequestDialog` (`lib/features/student/widgets/submit_leave_request_dialog.dart`) |
| **Primary Pain Points** | - Discrepancies between perceived attendance and official administrative counts.<br>- Confusion regarding outstanding fee balances.<br>- Lack of timely visibility into examination dates. |
| **Expected App Outcomes**| Transparent, tamper-evident personal dashboard displaying exact percentages, fee breakdowns, and verified examination dates. |

---

## 5. Product Scope & Feature Classification Matrix

The following matrix documents the verified status of all functional modules across the EduLens codebase:

| Module / Feature Area | Implementation Status | Codebase Grounding & Evidence | Scope Classification |
| :--- | :--- | :--- | :--- |
| **Authentication Service** | **Implemented** | `lib/services/auth_service.dart`, `FirebaseAuth` wrapper, safe error mapping. | In Current MVP |
| **Login Screen & Form Validation** | **Implemented** | `lib/features/auth/screens/login_screen.dart`, email regex, password visibility toggle. | In Current MVP |
| **Forgot Password Dispatch** | **Implemented** | `lib/features/auth/screens/forgot_password_screen.dart`, `sendPasswordResetEmail()`. | In Current MVP |
| **Reset Password Form (Simulated)** | **Implemented** | `lib/features/auth/screens/reset_password_screen.dart`, client validation (6+ chars). | In Current MVP |
| **User Profile Bootstrap** | **Implemented** | `lib/services/user_bootstrap_service.dart`, Firestore `users/{uid}` resolution. | In Current MVP |
| **Role-Based Dynamic Routing** | **Implemented** | `lib/routes/role_router.dart`, `AppRoutes.getDashboardRouteForRole()`. | In Current MVP |
| **District Executive Dashboard** | **Implemented** | `lib/features/district/screens/district_dashboard_screen.dart`, KPI grid. | In Current MVP |
| **District School Directory** | **Implemented** | `lib/features/district/screens/school_list_screen.dart`, live multi-metric search. | In Current MVP |
| **Granular School Details View** | **Implemented** | `lib/features/district/screens/school_details_screen.dart`, categorical breakdowns. | In Current MVP |
| **District Exam Overview Calendar** | **Implemented** | `lib/features/district/screens/district_exam_overview_screen.dart`, tabs: Upcoming/All. | In Current MVP |
| **Exam Details & Student Roster** | **Implemented** | `lib/features/district/screens/exam_details_screen.dart`, seating allocation roster. | In Current MVP |
| **School Administrator Dashboard** | **Implemented** | `lib/features/school_admin/screens/school_admin_dashboard_screen.dart`. | In Current MVP |
| **School Contact Info Management** | **Implemented** | `lib/features/school_admin/screens/school_info_screen.dart`, address, phone, email edit. | In Current MVP |
| **Student Roster & Search** | **Implemented** | `lib/features/school_admin/screens/student_fee_management_screen.dart`. | In Current MVP |
| **Fee Status & Payment Management** | **Implemented** | `lib/features/school_admin/screens/student_fee_management_screen.dart`, edit modal. | In Current MVP |
| **Teacher Home Dashboard** | **Implemented** | `lib/features/teacher/screens/teacher_home_screen.dart`, KPIs, Today's Classes. | In Current MVP |
| **Today's Classes & Timetable** | **Implemented** | `TimetableModel`, `TimetableRepository`, `TeacherTimetableScreen`. | In Current MVP |
| **Daily Attendance Management** | **Implemented** | `AttendanceManagementScreen`, atomic batch write to `attendance`. | In Current MVP |
| **Exam Scheduling Modal** | **Implemented** | `SchoolExamScheduleScreen`, `_ScheduleExamDialog`, date/time validation. | In Current MVP |
| **Exam Attendance (Data Layer)** | **Partially Implemented** | `ExamAttendanceModel`, `ExamAttendanceRepository`, Firestore rules. UI not wired. | Current MVP Foundation |
| **Student Personal Dashboard** | **Implemented** | `StudentDashboardScreen`, read-only attendance, fees, upcoming exams. | In Current MVP |
| **Student Exam Schedule (Read-Only)**| **Implemented** | `SchoolExamScheduleScreen(allowScheduling: false)` embedded in `StudentShell`. | In Current MVP |
| **Student Leave Request Submission** | **Implemented** | `SubmitLeaveRequestDialog`, `StudentLeaveRequestController`, validation. | In Current MVP |
| **Teacher Leave Request Review** | **Implemented** | `TeacherLeaveReviewScreen`, `TeacherLeaveReviewController`, approval/rejection. | In Current MVP |
| **Profile Display & Shared Logout** | **Implemented** | `ProfileLogoutSection`, embedded across all 4 role shells, stack clearing. | In Current MVP |
| **Automated Demo Seeding Utility** | **Implemented** | `tool/seed_firestore.dart`, seeds 2 schools, 4 user roles, demo records. | Developer Tooling |
| **Payment Gateway Integration** | **Excluded** | No code, no repository contracts. Administrative payment entry only. | Out of Current Scope |
| **Parent/Guardian Portal** | **Excluded** | No model representation, no routes, no rules. | Out of Current Scope |
| **Push Notifications / Alerts** | **Excluded** | No FCM client service or messaging infrastructure implemented. | Out of Current Scope |

---

## 6. Functional Requirements

### 6.1 Authentication

#### FR-001: Email and Password Authentication
- **Requirement ID**: `FR-001`
- **Name**: User Sign-In via Email and Password
- **Description**: Authenticate registered users using Firebase Authentication email and password credentials.
- **Primary Role**: All Roles (`districtAdmin`, `schoolAdmin`, `teacher`, `student`)
- **Preconditions**: User possesses a registered Firebase Auth account and device has internet/emulator connectivity.
- **Main Behavior**:
  1. User inputs email and password into `LoginScreen`.
  2. System invokes `AuthService.signInWithEmailAndPassword()`.
  3. Firebase validates credentials and returns `UserCredential`.
  4. Form triggers user profile lookup via `UserBootstrapService`.
- **Expected Result**: User session is established; user is navigated to their assigned role shell.
- **Constraints**: Password input must be masked by default with an unmask toggle; inputs must be sanitized (`email.trim()`).
- **Acceptance Criteria**:
  - Invalid email format displays `"The email address is formatted incorrectly."`.
  - Invalid password displays `"Incorrect email or password. Please try again."`.
  - Disabled user account displays `"This account has been disabled. Please contact support."`.
- **Implementation Status**: Implemented
- **Traceability**: [login_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/auth/screens/login_screen.dart), [auth_service.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/services/auth_service.dart), [auth_service_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/auth_service_test.dart)

#### FR-002: Password Reset Request Dispatch
- **Requirement ID**: `FR-002`
- **Name**: Send Password Reset Email Link
- **Description**: Allow unauthenticated or locked-out users to request an out-of-band password reset email link from Firebase Authentication.
- **Primary Role**: All Roles
- **Preconditions**: User navigates from `LoginScreen` via `"Forgot Password?"` link.
- **Main Behavior**:
  1. User enters their registered email on `ForgotPasswordScreen`.
  2. System validates email syntax and calls `AuthService.sendPasswordResetEmail()`.
  3. Firebase transmits password reset link to user's mailbox.
  4. System renders success banner: `"Password reset link sent! Please check your email inbox."`.
- **Expected Result**: Reset email dispatched; confirmation displayed; user can navigate back to login.
- **Constraints**: System must not reveal whether an unverified email address exists in the identity database.
- **Acceptance Criteria**: Empty or malformed email triggers instant validation error.
- **Implementation Status**: Implemented
- **Traceability**: [forgot_password_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/auth/screens/forgot_password_screen.dart), [auth_ui_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/auth_ui_test.dart)

#### FR-003: Password Reset Form UI (Client Verification)
- **Requirement ID**: `FR-003`
- **Name**: Password Reset Form Interface
- **Description**: Provide client-side interface for password reset entry with confirmation validation.
- **Primary Role**: All Roles
- **Preconditions**: Accessible via direct route `/reset-password`.
- **Main Behavior**: Accepts new password and confirmation; enforces minimum 6-character length; validates that both fields match.
- **Expected Result**: Displays success state upon valid submission.
- **Constraints**: Uses client-side simulated delay in current implementation; production password updates occur via Firebase Auth out-of-band web handler.
- **Acceptance Criteria**: Passwords shorter than 6 characters or mismatching inputs trigger immediate inline validation warnings.
- **Implementation Status**: Implemented (Client UI)
- **Traceability**: [reset_password_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/auth/screens/reset_password_screen.dart)

#### FR-004: Secure User Session Termination (Logout)
- **Requirement ID**: `FR-004`
- **Name**: Session Termination and Navigation Stack Purge
- **Description**: Terminate the active Firebase Authentication session and purge navigation history to prevent unauthorized backwards navigation.
- **Primary Role**: All Roles
- **Preconditions**: User is authenticated and viewing any role shell.
- **Main Behavior**:
  1. User taps logout icon in `AppScreenBar` or `"Log Out"` button in `ProfileLogoutSection`.
  2. System presents confirmation dialog: `"Are you sure you want to log out of EduLens?"`.
  3. Upon confirmation, system invokes `AuthService.signOut()`.
  4. System executes `Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false)`.
- **Expected Result**: Firebase session invalidated; navigation stack cleared; application returns to `LoginScreen`.
- **Constraints**: Must disable button during inflight logout to prevent duplicate invocations.
- **Acceptance Criteria**: Backwards Android system back navigation from login screen after logout must exit application rather than restore authenticated shell.
- **Implementation Status**: Implemented
- **Traceability**: [profile_logout_section.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/core/widgets/profile_logout_section.dart), [logout_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/logout_test.dart)

---

### 6.2 User Onboarding, Bootstrap & Role Routing

#### FR-005: User Profile Document Resolution
- **Requirement ID**: `FR-005`
- **Name**: Authenticated User Bootstrap
- **Description**: Query Cloud Firestore document `users/{uid}` using the authenticated Firebase Auth UID to resolve role, name, email, and assigned `schoolId`.
- **Primary Role**: System Service
- **Preconditions**: Firebase Auth reports an authenticated `User` (`currentUser != null`).
- **Main Behavior**:
  1. `UserBootstrapService.bootstrapUser()` executes `UserRepository.getUserById(authUser.uid)`.
  2. If document exists, verifies `uid` and `role` fields are non-empty strings.
  3. Returns `UserBootstrapState.profileFound()` with deserialized `UserModel`.
- **Expected Result**: Authenticated identity successfully bridged to application domain profile.
- **Constraints**: Must normalize case differences (`district_admin` -> `districtAdmin`).
- **Acceptance Criteria**: Deserialization gracefully defaults missing string fields to empty strings rather than throwing null cast errors.
- **Implementation Status**: Implemented
- **Traceability**: [user_bootstrap_service.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/services/user_bootstrap_service.dart), [user_model.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/models/user_model.dart), [user_bootstrap_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/user_bootstrap_test.dart)

#### FR-006: Dynamic Role-Based Routing
- **Requirement ID**: `FR-006`
- **Name**: Role Shell Navigation Routing
- **Description**: Route authenticated users to their corresponding role container widget based on normalized profile role.
- **Primary Role**: System Router
- **Preconditions**: Profile resolved with `status == UserBootstrapStatus.profileFound`.
- **Main Behavior**:
  - `districtAdmin` -> Mounts `DistrictShell`
  - `schoolAdmin` -> Mounts `SchoolAdminShell(schoolId, administratorName)`
  - `teacher` -> Mounts `TeacherShell(schoolId, teacherId)`
  - `student` -> Mounts `StudentShell(schoolId)`
- **Expected Result**: User lands on their authorized role dashboard without manual navigation.
- **Constraints**: Router must listen to `AuthService.authStateChanges` stream.
- **Acceptance Criteria**: Unauthenticated state immediately renders `LoginScreen`.
- **Implementation Status**: Implemented
- **Traceability**: [role_router.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/routes/role_router.dart), [app_routes.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/routes/app_routes.dart), [role_routing_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/role_routing_test.dart)

#### FR-007: Missing Profile Handling
- **Requirement ID**: `FR-007`
- **Name**: Missing User Profile Screen
- **Description**: Gracefully handle authenticated accounts lacking a corresponding Firestore profile document.
- **Primary Role**: System Router
- **Preconditions**: Firebase Auth sign-in succeeds, but query to `users/{uid}` yields `null`.
- **Main Behavior**:
  1. `UserBootstrapService` returns `UserBootstrapStatus.profileNotFound`.
  2. `RoleRouter` intercepts state and renders `StateMessage` error screen.
  3. Informs user: `"No user profile document found at users/{uid}. Please check Firestore configuration."`.
  4. Provides action button allowing immediate sign-out.
- **Expected Result**: Prevents application crashes or infinite loading loops on unprovisioned accounts.
- **Acceptance Criteria**: Tapping action signs user out and returns to `LoginScreen`.
- **Implementation Status**: Implemented
- **Traceability**: [role_router.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/routes/role_router.dart)

#### FR-008: Invalid Role Handling
- **Requirement ID**: `FR-008`
- **Name**: Unrecognized Role Profile State
- **Description**: Intercept and handle user profile documents containing unrecognized or unassigned role strings.
- **Primary Role**: System Router
- **Preconditions**: Document at `users/{uid}` contains an empty role or unknown string (e.g. `super_user`, `parent`).
- **Main Behavior**:
  1. `UserBootstrapService` emits `invalidProfile` status.
  2. `RoleRouter` presents unauthorized state view: `"Your user profile has an unassigned or invalid role. Please contact support."`.
- **Expected Result**: Unauthorized roles cannot bypass routing to enter administrative shells.
- **Acceptance Criteria**: System presents retry/sign-out action without crashing.
- **Implementation Status**: Implemented
- **Traceability**: [role_router.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/routes/role_router.dart), [user_bootstrap_service.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/services/user_bootstrap_service.dart)

---

### 6.3 District Administration

#### FR-009: District Executive KPI Dashboard
- **Requirement ID**: `FR-009`
- **Name**: Aggregate District Metrics Display
- **Description**: Calculate and display macro-level KPIs across all schools in the district.
- **Primary Role**: `districtAdmin`
- **Preconditions**: District Admin is signed in.
- **Main Behavior**:
  - `DistrictDataLoader` loads all `schools`, `students`, `attendance`, `fees`, and `exams`.
  - Calculates:
    - **Total Schools**: Integer count of all schools in district.
    - **Total Students**: Sum of all students across all schools.
    - **Average Attendance**: `Metrics.attendancePercentage(allAttendanceRecords)`.
    - **Fee Collection Overview**: `Metrics.feePaidPercentage(allFeeRecords)`.
    - **Upcoming Exams in 7 Days**: `Metrics.examsWithinDays(allExams, from: now, days: 7)`.
    - **Schools Needing Attention**: Schools where derived attendance rate is `< 70.0%`.
- **Expected Result**: Dashboard renders stat cards, attention alerts, and upcoming exam list.
- **Constraints**: Missing data renders em dash (`"—"`), never `0%`.
- **Acceptance Criteria**: Verified against `DistrictDashboardScreen` widget tests.
- **Implementation Status**: Implemented
- **Traceability**: [district_dashboard_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/district/screens/district_dashboard_screen.dart), [district_dashboard_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/district/controllers/district_dashboard_controller.dart), [district_dashboard_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/district_dashboard_test.dart)

#### FR-010: District School Directory & Search
- **Requirement ID**: `FR-010`
- **Name**: Multi-School Directory Browsing
- **Description**: Browse list of all district schools with live search filtering and derived metrics per school.
- **Primary Role**: `districtAdmin`
- **Preconditions**: District Admin navigates to `"Schools"` tab in `DistrictShell`.
- **Main Behavior**:
  1. Displays list of `SchoolSummary` cards containing school name, location, student count, teacher count, attendance %, fee collection %, and total exams.
  2. Search bar filters list in real-time by school name or location.
  3. Tapping a school navigates to `AppRoutes.schoolDetails` passing `schoolId`.
- **Expected Result**: Fast, searchable directory with immediate derived performance indicators.
- **Acceptance Criteria**: Empty search query shows all schools; non-matching query displays empty state view.
- **Implementation Status**: Implemented
- **Traceability**: [school_list_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/district/screens/school_list_screen.dart), [school_browsing_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/school_browsing_test.dart)

#### FR-011: Granular School Details Inspection
- **Requirement ID**: `FR-011`
- **Name**: School Performance Breakdown View
- **Description**: Display complete performance audit of a specific school, including contact information, categorical attendance breakdown, and fee payment distribution.
- **Primary Role**: `districtAdmin`
- **Preconditions**: Navigated with valid `schoolId` argument.
- **Main Behavior**:
  - Re-reads school record directly from repository.
  - Renders School Info Card: address, contact phone, contact email (handling nulls cleanly).
  - Renders Attendance Breakdown: counts of Present, Absent, and Leave records.
  - Renders Fee Breakdown: counts of Paid, Partial, and Outstanding fee records.
  - Displays upcoming scheduled exams for this school.
- **Expected Result**: Deep visibility into school operations for district auditors.
- **Constraints**: Re-fetches fresh record from database rather than relying on stale list state.
- **Acceptance Criteria**: If `schoolId` argument is missing/empty, renders `_PlaceholderScreen(title: 'School Not Specified')`.
- **Implementation Status**: Implemented
- **Traceability**: [school_details_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/district/screens/school_details_screen.dart), [school_details_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/district/controllers/school_details_controller.dart)

#### FR-012: District-Wide Examination Calendar
- **Requirement ID**: `FR-012`
- **Name**: District Exam Calendar Overview
- **Description**: View all scheduled examinations across all schools in the district with tabbed filtering.
- **Primary Role**: `districtAdmin`
- **Preconditions**: District Admin navigates to `"Exams"` tab in `DistrictShell`.
- **Main Behavior**:
  1. Fetches all exams via `ExamRepository.getAllExams()`.
  2. Resolves school names via `SchoolRepository`.
  3. Provides tab toggles:
     - **Upcoming**: Filtered to exams where `date >= today`, sorted soonest first.
     - **All Exams**: Chronologically sorted list of all past and future exams.
  4. Search bar enables filtering by subject or class name.
  5. Tapping an exam navigates to `AppRoutes.examDetails` passing `examId`.
- **Expected Result**: Unified regional examination schedule accessible at a glance.
- **Acceptance Criteria**: Status chip renders exam lifecycle status (`Scheduled`).
- **Implementation Status**: Implemented
- **Traceability**: [district_exam_overview_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/district/screens/district_exam_overview_screen.dart), [district_exams_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/district_exams_test.dart)

#### FR-013: Examination Seating & Student Roster Inspection
- **Requirement ID**: `FR-013`
- **Name**: Exam Details & Student Allocation View
- **Description**: Inspect metadata and candidate student roster for a specific examination.
- **Primary Role**: `districtAdmin`
- **Preconditions**: Navigated with valid `examId` argument.
- **Main Behavior**:
  1. Fetches `ExamModel` by `examId`.
  2. Queries `StudentRepository.getStudentsBySchoolAndClass(exam.schoolId, exam.className)`.
  3. Displays exam subject, status badge, school name, target class, date, and 12-hour formatted time (`formatTime`).
  4. Renders student roster showing candidate names, class, section, and roll numbers.
- **Expected Result**: Clear confirmation of student seating and scheduling logistics.
- **Constraints**: Candidate roster must be filtered strictly by both `schoolId` AND `className`.
- **Acceptance Criteria**: Shows total enrolled candidate count.
- **Implementation Status**: Implemented
- **Traceability**: [exam_details_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/district/screens/exam_details_screen.dart), [exam_details_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/district/controllers/exam_details_controller.dart)

---

### 6.4 School Administration

#### FR-014: School Administrator Institutional Dashboard
- **Requirement ID**: `FR-014`
- **Name**: School-Scoped Operational Dashboard
- **Description**: Display key operational metrics isolated to the administrator's assigned school.
- **Primary Role**: `schoolAdmin`
- **Preconditions**: School Admin is signed in with assigned `schoolId`.
- **Main Behavior**:
  - Fetches school document, students, teachers, attendance, fees, and exams for assigned `schoolId`.
  - Renders greeting: `"Welcome back, {AdminName}"`.
  - Displays School Info Card: name, location, address, contact phone, contact email.
  - Displays Stat Cards: Total Students, Total Teachers, Attendance Rate %, Fee Collection %.
  - Low Attendance Warning Banner if attendance rate `< 70.0%`.
  - Upcoming Exams Card (exams within next 7 days).
- **Expected Result**: Complete snapshot of institutional health upon login.
- **Acceptance Criteria**: Administrator assigned to School A cannot view School B's dashboard metrics.
- **Implementation Status**: Implemented
- **Traceability**: [school_admin_dashboard_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/school_admin/screens/school_admin_dashboard_screen.dart), [school_admin_dashboard_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/school_admin/controllers/school_admin_dashboard_controller.dart)

#### FR-015: School Contact Information Management
- **Requirement ID**: `FR-015`
- **Name**: School Directory Profile Editor
- **Description**: Allow School Administrators to edit and update institutional contact details.
- **Primary Role**: `schoolAdmin`
- **Preconditions**: Navigated to `"School"` tab in `SchoolAdminShell`.
- **Main Behavior**:
  1. Displays current `address`, `contactNumber`, and `email`.
  2. Tapping `"Edit Information"` activates editable text fields.
  3. Validates contact number (minimum 7 digits) and email format (`^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$`).
  4. Calls `SchoolRepository.saveSchool()` preserving immutable `schoolId`, `schoolName`, and `location`.
  5. Re-reads and re-renders updated record.
- **Expected Result**: School contact details persisted to Cloud Firestore.
- **Constraints**: School Admin is strictly prohibited from altering `schoolName` or `location`.
- **Acceptance Criteria**: Malformed email or phone rejects submission with inline error message.
- **Implementation Status**: Implemented
- **Traceability**: [school_info_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/school_admin/screens/school_info_screen.dart), [school_info_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/school_admin/controllers/school_info_controller.dart), [school_info_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/school_info_test.dart)

#### FR-016: Student Roster Browsing and Search
- **Requirement ID**: `FR-016`
- **Name**: School Student Directory
- **Description**: Browse and search student roster for the assigned school.
- **Primary Role**: `schoolAdmin`
- **Preconditions**: Navigated to `"Students"` tab in `SchoolAdminShell`.
- **Main Behavior**:
  1. Loads all students belonging to `schoolId`.
  2. Search input filters roster in real-time by student name, roll number, or class.
  3. Class dropdown allows filtering by specific class name.
  4. Renders filtered stat counter: e.g. `"Showing 1 of 2 students"`.
- **Expected Result**: Fast navigation of student records.
- **Acceptance Criteria**: Displays student roll number when present; cleanly omits when absent.
- **Implementation Status**: Implemented
- **Traceability**: [student_fee_management_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/school_admin/screens/student_fee_management_screen.dart), [student_fee_management_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/school_admin/controllers/student_fee_management_controller.dart)

#### FR-017: Student Fee Status & Overpayment Adjudication
- **Requirement ID**: `FR-017`
- **Name**: Edit Student Fee Record
- **Description**: Update fee payment status, paid amount, and audit remarks for a student.
- **Primary Role**: `schoolAdmin`
- **Preconditions**: Administrator taps `"Edit Fee"` on a student tile in `StudentFeeManagementScreen`.
- **Main Behavior**:
  1. Opens modal dialog pre-filled with `totalDue`, current `paidAmount`, `status` dropdown (`Paid`, `Partial`, `Outstanding`), and `remarks`.
  2. Validates that `paidAmount <= totalDue` (strictly prevents overpayments).
  3. Validates that `paidAmount >= 0` and `totalDue >= 0`.
  4. Persists update via `FeeRepository.updateFeeStatus()`.
  5. Refreshes roster list and displays success SnackBar.
- **Expected Result**: Accurate ledger update stored in `fees` collection.
- **Constraints**: Entering `paidAmount > totalDue` displays inline error: `"Paid amount cannot exceed total due ($totalDue)"`.
- **Acceptance Criteria**: Verified by Journey B automated integration test.
- **Implementation Status**: Implemented
- **Traceability**: [student_fee_management_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/school_admin/screens/student_fee_management_screen.dart), [student_fee_management_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/student_fee_management_test.dart)

---

### 6.5 Teacher Workflows

#### FR-018: Teacher Home Dashboard & Today's Classes
- **Requirement ID**: `FR-018`
- **Name**: Teacher Daily Dashboard
- **Description**: Display teacher summary KPIs, shortcuts, and scheduled periods for the current calendar day.
- **Primary Role**: `teacher`
- **Preconditions**: Teacher signed in with assigned `schoolId` and `uid`.
- **Main Behavior**:
  - Loads school profile, total school students, attendance rate, and today's classes from `timetables` collection matching `teacherId` and current weekday name (e.g. `'Wednesday'`).
  - Displays greeting: `"Welcome back, {TeacherName}"`.
  - Lists today's periods: subject, class, section, start time, end time, and room number.
  - Provides quick action shortcuts: `"Mark Attendance"`, `"View Schedule"`.
  - Lists top 3 upcoming exams for the school.
- **Expected Result**: Teacher is immediately prepared for daily instructional duties.
- **Acceptance Criteria**: If no classes scheduled for current day, renders `"No classes scheduled for today."`.
- **Implementation Status**: Implemented
- **Traceability**: [teacher_home_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/teacher/screens/teacher_home_screen.dart), [teacher_dashboard_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/teacher/controllers/teacher_dashboard_controller.dart)

#### FR-019: Daily Classroom Attendance Registration
- **Requirement ID**: `FR-019`
- **Name**: Daily Attendance Register Management
- **Description**: Record daily attendance for students in an assigned school with atomic batch persistence.
- **Primary Role**: `teacher`
- **Preconditions**: Navigated to `"Attendance"` tab in `TeacherShell`.
- **Main Behavior**:
  1. Queries existing attendance records for `schoolId` and selected date (`yyyy-MM-dd`).
  2. For students with no record, defaults status to `Present`.
  3. Teacher toggles status chips between `Present`, `Absent`, and `Leave`.
  4. Teacher taps `"Save Attendance Register"`.
  5. Controller commits all student records in a single atomic batch via `AttendanceRepository.saveAttendanceBatch()`.
  6. Displays confirmation: `"Attendance register saved successfully."`.
- **Expected Result**: Atomically persistent attendance records in `attendance` collection.
- **Constraints**: Batch either commits in its entirety or rolls back completely to prevent corrupt/partial registers.
- **Acceptance Criteria**: Verified by `AttendanceManagementScreen` widget tests and atomic batch repository tests.
- **Implementation Status**: Implemented
- **Traceability**: [attendance_management_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/teacher/screens/attendance_management_screen.dart), [attendance_management_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/teacher/controllers/attendance_management_controller.dart), [attendance_management_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/attendance_management_test.dart)

#### FR-020: Teacher Weekly Timetable Schedule
- **Requirement ID**: `FR-020`
- **Name**: Weekly Teaching Timetable
- **Description**: Browse weekly timetable allocations filtered by weekday tabs.
- **Primary Role**: `teacher`
- **Preconditions**: Accessible via `TeacherTimetableScreen`.
- **Main Behavior**:
  1. Loads all entries from `timetables` collection matching `schoolId` and `teacherId`.
  2. Tab bar allows switching weekdays (`Monday` through `Sunday`).
  3. Displays periods with formatted start/end times (`formatTime`), class, section, subject, and room number.
- **Expected Result**: Clear visualization of weekly schedule.
- **Acceptance Criteria**: Empty days render empty state message.
- **Implementation Status**: Implemented (Dedicated Screen & Controller)
- **Traceability**: [teacher_timetable_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/teacher/screens/teacher_timetable_screen.dart), [teacher_timetable_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/teacher/controllers/teacher_timetable_controller.dart), [teacher_timetable_ui_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/teacher_timetable_ui_test.dart)

#### FR-021: Institutional Examination Scheduling
- **Requirement ID**: `FR-021`
- **Name**: Schedule School Examination
- **Description**: Create and schedule a new academic examination for a specific class in the school.
- **Primary Role**: `teacher`, `schoolAdmin`
- **Preconditions**: Navigated to `"Exams"` tab in `TeacherShell` or `SchoolExamScheduleScreen` with `allowScheduling: true`.
- **Main Behavior**:
  1. User taps `"+ Schedule New Exam"`.
  2. Enters: Subject, Class Name, Date (`yyyy-MM-dd`), Start Time (`HH:mm`), End Time (`HH:mm`).
  3. Validates required fields and time interval (`startTime <= endTime`).
  4. Creates `ExamModel` with default `status: 'Scheduled'` and `createdBy: currentUser.uid`.
  5. Commits to `exams` collection via `ExamRepository.saveExam()`.
- **Expected Result**: Exam scheduled and immediately visible on school calendars.
- **Acceptance Criteria**: Form validation prevents blank fields or malformed date strings.
- **Implementation Status**: Implemented
- **Traceability**: [school_exam_schedule_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/school_admin/screens/school_exam_schedule_screen.dart), [school_exam_schedule_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/school_admin/controllers/school_exam_schedule_controller.dart), [school_exam_schedule_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/school_exam_schedule_test.dart)

#### FR-022: Student Leave Request Review & Adjudication
- **Requirement ID**: `FR-022`
- **Name**: Review and Adjudicate Leave Requests
- **Description**: Review pending student leave requests for the school and record approval or rejection with remarks.
- **Primary Role**: `teacher`, `schoolAdmin`
- **Preconditions**: Accessible via `TeacherLeaveReviewScreen`.
- **Main Behavior**:
  1. Queries `leaveRequests` collection for assigned `schoolId`.
  2. Renders request cards with student name, class, start date, end date, submitted reason, and current status.
  3. User taps `"Approve"` or `"Reject"`.
  4. System prompts for optional review comment.
  5. Updates document via `LeaveRequestRepository.updateLeaveRequestStatus()` recording `status`, `reviewedBy: teacherId`, `reviewedAt`, and `reviewComment`.
- **Expected Result**: Leave request status updated and locked against student alteration.
- **Constraints**: Firestore rules require `reviewedBy == request.auth.uid` and current status must be `'Pending'`.
- **Acceptance Criteria**: Verified by Journey C automated integration test.
- **Implementation Status**: Implemented (Dedicated Screen & Controller)
- **Traceability**: [teacher_leave_review_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/teacher/screens/teacher_leave_review_screen.dart), [teacher_leave_review_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/teacher/controllers/teacher_leave_review_controller.dart)

---

### 6.6 Student Workflows

#### FR-023: Student Personal Academic & Financial Dashboard
- **Requirement ID**: `FR-023`
- **Name**: Student Personal View
- **Description**: Provide enrolled students with a personalized, tamper-evident view of their attendance, fee balances, and upcoming exams.
- **Primary Role**: `student`
- **Preconditions**: Student signed in; `users/{uid}` resolves with `role: 'student'`; matching `students/{uid}` document exists.
- **Main Behavior**:
  - Resolves identity mapping `students.studentId == authUser.uid`.
  - Queries `attendance` where `studentId == authUser.uid`.
  - Calculates personal attendance rate and renders breakdown (Present / Absent / Leave).
  - Highlights attendance in red with badge if `< 70.0%`.
  - Queries `fees` where `studentId == authUser.uid`; displays total due, paid amount, outstanding balance, and status badge.
  - Queries `exams` for school; displays upcoming exams.
- **Expected Result**: Unified transparent personal summary.
- **Constraints**: Screen is 100% read-only.
- **Acceptance Criteria**: Verified by `StudentDashboardScreen` tests and Journey D E2E test.
- **Implementation Status**: Implemented
- **Traceability**: [student_dashboard_screen.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/student/screens/student_dashboard_screen.dart), [student_dashboard_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/student/controllers/student_dashboard_controller.dart), [student_dashboard_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/student_dashboard_test.dart)

#### FR-024: Student Examination Schedule View (Read-Only)
- **Requirement ID**: `FR-024`
- **Name**: Student Read-Only Exam Timetable
- **Description**: Allow students to inspect their school's examination schedule without scheduling permissions.
- **Primary Role**: `student`
- **Preconditions**: Navigated to `"Exams"` tab in `StudentShell`.
- **Main Behavior**:
  - Embeds `SchoolExamScheduleScreen` with parameter `allowScheduling: false`.
  - Displays all school exams sorted chronologically.
  - Omits `"+ Schedule New Exam"` action button completely from UI.
- **Expected Result**: Clean examination schedule without write controls.
- **Constraints**: Backed by Firestore Rules rejecting any student write to `exams`.
- **Acceptance Criteria**: Widget tests assert `find.text('Schedule Exam')` returns `findsNothing`.
- **Implementation Status**: Implemented
- **Traceability**: [student_shell.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/student/screens/student_shell.dart), [student_exam_consistency_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/student_exam_consistency_test.dart)

#### FR-025: Student Leave Request Submission
- **Requirement ID**: `FR-025`
- **Name**: Submit Student Leave Request
- **Description**: Allow enrolled students to formally request academic leave by submitting date ranges and justifications.
- **Primary Role**: `student`
- **Preconditions**: Accessible via `SubmitLeaveRequestDialog`.
- **Main Behavior**:
  1. Student enters Start Date (`yyyy-MM-dd`), End Date (`yyyy-MM-dd`), and Reason text.
  2. Client validates that Start Date is not after End Date (`startDate <= endDate`).
  3. Client validates that Reason is non-empty.
  4. Submits `LeaveRequestModel` with `status: 'Pending'`, `studentId: authUser.uid`, `schoolId: userProfile.schoolId`.
  5. Firestore rules enforce that client does not inject `reviewedBy` or `reviewedAt`.
- **Expected Result**: Leave request created in `leaveRequests` collection.
- **Constraints**: Start date after end date displays `"Start date cannot be after end date."`.
- **Acceptance Criteria**: Verified by Journey D E2E test and rules security assertions.
- **Implementation Status**: Implemented
- **Traceability**: [submit_leave_request_dialog.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/student/widgets/submit_leave_request_dialog.dart), [student_leave_request_controller.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/features/student/controllers/student_leave_request_controller.dart), [student_leave_request_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/student_leave_request_test.dart)

---

### 6.7 Data Management & Atomic Batch Operations

#### FR-026: Deterministic Document ID Alignment (`dataWithId`)
- **Requirement ID**: `FR-026`
- **Name**: Document Identity Fallback Mapping
- **Description**: Ensure every Firestore document maintains consistency between its document path key and internal payload ID field.
- **Primary Role**: Data Repositories
- **Preconditions**: Firestore returns a `DocumentSnapshot`.
- **Main Behavior**: `dataWithId(doc, idField)` checks if the payload map contains a non-empty `idField`. If missing or empty, injects `doc.id`.
- **Expected Result**: Prevents silent deserialization failures where models instantiate with empty IDs.
- **Acceptance Criteria**: Unit tested across all model mappers.
- **Implementation Status**: Implemented
- **Traceability**: [firestore_document_mapper.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/repositories/firestore_document_mapper.dart)

#### FR-027: Atomic Attendance Register Writes
- **Requirement ID**: `FR-027`
- **Name**: Atomic Attendance Batch Commits
- **Description**: Persist classroom attendance records using Firestore `WriteBatch` to guarantee all-or-nothing execution.
- **Primary Role**: `AttendanceRepository`
- **Preconditions**: Teacher submits attendance for a roster of students.
- **Main Behavior**: System stages all individual student `AttendanceModel` writes into a Firestore `batch` instance and executes `batch.commit()`.
- **Expected Result**: All records land simultaneously; network failure causes zero records to land.
- **Acceptance Criteria**: Verified by `FirestoreAttendanceRepository` unit tests.
- **Implementation Status**: Implemented
- **Traceability**: [firestore_attendance_repository.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/repositories/firestore_attendance_repository.dart)

---

### 6.8 Dashboard Metrics & Algorithmic Rules

#### FR-028: Attendance Percentage Calculation
- **Requirement ID**: `FR-028`
- **Name**: Standard Attendance Formula
- **Description**: Enforce the approved mathematical algorithm for calculating attendance rates across all screens.
- **Primary Role**: System Utility (`Metrics`)
- **Preconditions**: List of `AttendanceModel` records provided.
- **Formula**:
  $$\text{Attendance Rate} = \left( \frac{\text{Count of records where } \text{status.toLowerCase()} == \text{'present'}}{\text{Total count of all records in scope}} \right) \times 100$$
- **Rules**:
  - Denominator includes ALL records (`Present`, `Absent`, and `Leave`). An approved leave lowers percentage without being treated as an absence.
  - If records list is empty, returns `null` (renders as em dash `"—"`), NEVER `0%`.
- **Acceptance Criteria**: Verified in `district_metrics_test.dart`.
- **Implementation Status**: Implemented
- **Traceability**: [metrics.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/core/utils/metrics.dart), [district_metrics_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/district_metrics_test.dart)

#### FR-029: Amount-Weighted Fee Collection Percentage
- **Requirement ID**: `FR-029`
- **Name**: Amount-Weighted Fee Formula
- **Description**: Calculate fee recovery percentage weighted by monetary value rather than count of records.
- **Primary Role**: System Utility (`Metrics`)
- **Preconditions**: List of `FeeModel` records provided.
- **Formula**:
  $$\text{Fee Collection Rate} = \left( \frac{\sum \text{paidAmount}}{\sum \text{totalDue}} \right) \times 100$$
- **Rules**:
  - Clamped between `0.0` and `100.0`.
  - If $\sum \text{totalDue} \le 0$ or fees list is empty, returns `null` (renders as `"—"`).
  - Distinct from categorical Fee Breakdown (counting records into Paid, Partial, Outstanding).
- **Acceptance Criteria**: Verified in `district_metrics_test.dart`.
- **Implementation Status**: Implemented
- **Traceability**: [metrics.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/core/utils/metrics.dart)

#### FR-030: Attention Threshold Trigger (<70%)
- **Requirement ID**: `FR-030`
- **Name**: Low Attendance Alert Rule
- **Description**: Trigger visual warning alerts whenever a school's derived attendance drops below the approved threshold.
- **Primary Role**: System Utility (`Metrics`)
- **Threshold**: Strictly `< 70.0%` (`Metrics.attentionThreshold = 70.0`).
- **Main Behavior**: Renders red highlight chip, warning cards, and red statistical numerals.
- **Acceptance Criteria**: Value of exactly `70.0%` does not trigger alert; `69.9%` triggers alert.
- **Implementation Status**: Implemented
- **Traceability**: [metrics.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/core/utils/metrics.dart)

---

### 6.9 Error Handling & System Recovery

#### FR-031: Safe Repository Error Translation
- **Requirement ID**: `FR-031`
- **Name**: Repository Exception Shielding
- **Description**: Intercept raw low-level `FirebaseException` objects and map them into user-safe `RepositoryException` instances.
- **Primary Role**: Repositories
- **Preconditions**: Firestore query or write fails.
- **Mapping**:
  - `permission-denied` -> `RepositoryErrorKind.permissionDenied` (`"You do not have permission to {action}."`)
  - `not-found` -> `RepositoryErrorKind.notFound` (`"We could not find what you asked for."`)
  - `unavailable` / `deadline-exceeded` -> `RepositoryErrorKind.unavailable` (`"We could not reach the server. Check your connection and try again."`)
  - Other -> `RepositoryErrorKind.unknown`
- **Expected Result**: Prevents stack traces or raw database paths from reaching the UI.
- **Acceptance Criteria**: Verified in `repository_errors_test.dart`.
- **Implementation Status**: Implemented
- **Traceability**: [repository_exception.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/repositories/repository_exception.dart), [repository_errors_test.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/test/repository_errors_test.dart)

#### FR-032: Safe State Management Lifecycle (`SafeNotifier`)
- **Requirement ID**: `FR-032`
- **Name**: Disposed Controller State Shield
- **Description**: Protect controllers against Flutter framework lifecycle crashes when asynchronous Firestore callbacks fire after controller disposal.
- **Primary Role**: Core Architecture
- **Preconditions**: User rapidly navigates away from a screen while a query is inflight.
- **Main Behavior**: `SafeNotifier` mixin overrides `notifyListeners()`, suppressing notification if `!hasListeners` or `_disposed == true`.
- **Expected Result**: Zero `"ChangeNotifier used after being disposed"` runtime exceptions.
- **Acceptance Criteria**: Verified by automated reliability tests.
- **Implementation Status**: Implemented
- **Traceability**: [safe_notifier.dart](file:///c:/Users/harsh/Desktop/SW2627_Flutter_EduLens_District_School_Management_System/lib/core/state/safe_notifier.dart)

---

## 7. Role-Permission Matrix

The following matrix represents the **exact server-side access control policy** enforced by `firestore.rules`. It is not merely a UI routing guideline; unauthorized operations are rejected at the database engine level.

| Collection / Resource | Operation | District Admin (`districtAdmin`) | School Admin (`schoolAdmin`) | Teacher (`teacher`) | Student (`student`) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`users/{uid}`** | **Read** | **Allowed** (District-Wide) | **Allowed** (Same School) | **Allowed** (Same School) | **Allowed** (Own UID only) |
| | **Create** | **Allowed** | **Allowed** (Own UID only) | **Allowed** (Own UID only) | **Allowed** (Own UID, no `schoolId`) |
| | **Update** | **Allowed** | **Allowed** (Own UID only) | **Allowed** (Own UID only) | **Allowed** (Own UID, no `schoolId`) |
| | **Delete** | **Allowed** | Denied | Denied | Denied |
| **`schools/{schoolId}`** | **Read** | **Allowed** (District-Wide) | **Allowed** (District-Wide) | **Allowed** (District-Wide) | **Allowed** (District-Wide) |
| | **Create** | **Allowed** (Valid data) | Denied | Denied | Denied |
| | **Update** | **Allowed** | **Allowed** (Assigned School; phone, address, email only) | Denied | Denied |
| | **Delete** | **Allowed** | Denied | Denied | Denied |
| **`students/{studentId}`**| **Read** | **Allowed** (District-Wide) | **Allowed** (Assigned School) | **Allowed** (Assigned School) | **Allowed** (Own Student ID / UID only) |
| | **Create** | **Allowed** | **Allowed** (Assigned School) | Denied | Denied |
| | **Update** | **Allowed** | **Allowed** (Assigned School) | Denied | Denied |
| | **Delete** | **Allowed** | Denied | Denied | Denied |
| **`attendance/{attendanceId}`**| **Read** | **Allowed** (District-Wide) | **Allowed** (Assigned School) | **Allowed** (Assigned School) | **Allowed** (Own Student ID only) |
| | **Create** | **Allowed** | Denied | **Allowed** (Assigned School, recorded by self) | Denied |
| | **Update** | **Allowed** | Denied | **Allowed** (Assigned School, immutable keys) | Denied |
| | **Delete** | **Allowed** | Denied | Denied | Denied |
| **`fees/{feeId}`** | **Read** | **Allowed** (District-Wide) | **Allowed** (Assigned School) | Denied | **Allowed** (Own Student ID only) |
| | **Create** | **Allowed** | **Allowed** (Assigned School) | Denied | Denied |
| | **Update** | **Allowed** | **Allowed** (Assigned School, immutable keys) | Denied | Denied |
| | **Delete** | **Allowed** | Denied | Denied | Denied |
| **`exams/{examId}`** | **Read** | **Allowed** (District-Wide) | **Allowed** (Assigned School) | **Allowed** (Assigned School) | **Allowed** (Assigned School) |
| | **Create** | **Allowed** | **Allowed** (Assigned School) | **Allowed** (Assigned School) | Denied |
| | **Update** | **Allowed** | **Allowed** (Assigned School) | **Allowed** (Assigned School) | Denied |
| | **Delete** | **Allowed** | **Allowed** (Assigned School) | Denied | Denied |
| **`leaveRequests/{requestId}`**| **Read** | **Allowed** (District-Wide) | **Allowed** (Assigned School) | **Allowed** (Assigned School) | **Allowed** (Own Student ID only) |
| | **Create** | Denied | Denied | Denied | **Allowed** (Own Student ID, `status: 'Pending'`) |
| | **Update** | Denied | **Allowed** (Review: `Approved`/`Rejected`) | **Allowed** (Review: `Approved`/`Rejected`) | Denied (Immutable once submitted) |
| | **Delete** | Denied (Audit lock) | Denied (Audit lock) | Denied (Audit lock) | Denied (Audit lock) |
| **`timetables/{timetableId}`**| **Read** | **Allowed** (District-Wide) | **Allowed** (Assigned School) | **Allowed** (Assigned School) | Denied |
| | **Create** | **Allowed** | **Allowed** (Assigned School) | **Allowed** (Assigned School) | Denied |
| | **Update** | **Allowed** | **Allowed** (Assigned School) | **Allowed** (Assigned School) | Denied |
| | **Delete** | **Allowed** | **Allowed** (Assigned School) | Denied | Denied |
| **`examAttendance/{id}`**| **Read** | **Allowed** (District-Wide) | **Allowed** (Assigned School) | **Allowed** (Assigned School) | **Allowed** (Own Student ID only) |
| | **Create** | **Allowed** | **Allowed** (Assigned School) | **Allowed** (Assigned School) | Denied |
| | **Update** | **Allowed** | **Allowed** (Assigned School) | **Allowed** (Assigned School) | Denied |
| | **Delete** | **Allowed** | Denied | Denied | Denied |

*Note: In `firestore.rules`, all client deletion of `leaveRequests` is explicitly prohibited (`allow delete: if false;`) to preserve permanent audit trails.*

---

## 8. User Journeys and Use Cases

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                          Core User Journeys                                 │
├─────────────────────────────────────────────────────────────────────────────┤
│ Journey 1: Authentication & Dynamic Role Routing (All Roles)                │
│ Journey 2: District Admin School Supervision & Underperformance Audit       │
│ Journey 3: School Admin Institutional Info & Fee Status Adjudication        │
│ Journey 4: Teacher Daily Timetable Review & Classroom Attendance Taking     │
│ Journey 5: Teacher/Admin Examination Scheduling                             │
│ Journey 6: Student Academic Attendance & Financial Ledger Inspection        │
│ Journey 7: Student Examination Schedule Review (Read-Only)                  │
│ Journey 8: Student Formal Leave Request Submission                          │
│ Journey 9: Teacher/Admin Student Leave Adjudication                         │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### Use Case 1: Login and Dashboard Routing
- **Actor**: Any registered EduLens user.
- **Preconditions**: User has launched app; network connection active.
- **Main Flow**:
  1. User opens app and lands on `LoginScreen`.
  2. Enters registered email address and password; taps `"Log In"`.
  3. System validates input formats; calls `AuthService.signInWithEmailAndPassword()`.
  4. Firebase Auth authenticates user; returns session credential.
  5. `RoleRouter` intercepts auth change; triggers `UserBootstrapService.bootstrapUser()`.
  6. Bootstrap service queries `users/{uid}` in Firestore and normalizes `role`.
  7. Router transitions user to their corresponding role container (`DistrictShell`, `SchoolAdminShell`, `TeacherShell`, or `StudentShell`).
- **Alternative Flow (Missing/Invalid Profile)**:
  - If profile document does not exist, router displays `"Profile Not Found"`.
  - If role string is unrecognized, router displays `"Invalid Role Profile"`.
  - In either case, user is offered a `"Sign Out"` action button.
- **Failure Conditions**: Invalid credentials display `"Incorrect email or password. Please try again."`; network timeout prompts user to retry.
- **Postconditions**: User session established and appropriate role shell mounted.

---

### Use Case 2: District Admin Monitoring Schools & Performance Audit
- **Actor**: District Administrator (`districtAdmin`).
- **Preconditions**: Authenticated as `districtAdmin`.
- **Main Flow**:
  1. Lands on `DistrictDashboardScreen`; inspects Total Schools, Total Students, Average Attendance, and Fee Collection KPIs.
  2. Observes a red alert card indicating a school has dropped below the 70% attendance threshold.
  3. Taps `"View Schools"` button or selects `"Schools"` bottom navigation tab.
  4. System presents `SchoolListScreen`; user types school name into search bar.
  5. Taps target school summary card.
  6. Application pushes `SchoolDetailsScreen` (`AppRoutes.schoolDetails`) with `schoolId`.
  7. Controller fetches fresh school record, student count, attendance breakdown, and fee breakdown.
  8. Admin evaluates detailed counts of Present vs. Absent vs. Leave.
- **Alternative Flow**: Admin navigates to `"Exams"` tab to audit upcoming district-wide examinations and inspect seating rosters for conflict management.
- **Failure Conditions**: Firestore connection drops; screen displays `StateMessage` error view with `"Try Again"` retry button.
- **Postconditions**: District Administrator successfully diagnoses institutional compliance gap.

---

### Use Case 3: School Admin Managing School Info and Editing Fees
- **Actor**: School Administrator (`schoolAdmin`).
- **Preconditions**: Authenticated as `schoolAdmin` with valid `users.schoolId`.
- **Main Flow**:
  1. Lands on `SchoolAdminDashboardScreen`; reviews institutional student roster count and fee collection rate.
  2. Selects `"School"` tab; taps `"Edit Information"`.
  3. Updates school phone number and email address; taps `"Save Changes"`.
  4. Controller validates phone and email format; commits to `schools/{schoolId}`.
  5. Selects `"Students"` tab; enters student name `"Asha"` in search bar.
  6. Roster filters in real-time; taps `"Edit Fee"` on student card.
  7. Enters new paid amount; system verifies `paidAmount <= totalDue`.
  8. Enters audit note into remarks field; taps `"Update Fee Status"`.
  9. System persists changes to `fees/{feeId}`; updates roster card and shows success SnackBar.
- **Alternative Flow (Overpayment Attempt)**: Admin enters paid amount exceeding total due; form halts submission and highlights field in red: `"Paid amount cannot exceed total due ($totalDue)"`.
- **Failure Conditions**: Permission denied if admin attempts to update another school's fees.
- **Postconditions**: School contact details and student ledger accurately updated.

---

### Use Case 4: Teacher Timetable Review & Daily Attendance Registration
- **Actor**: Teacher (`teacher`).
- **Preconditions**: Authenticated as `teacher` with valid `schoolId` and `teacherId`.
- **Main Flow**:
  1. Lands on `TeacherHomeScreen`; reviews Today's Classes section for scheduled teaching periods.
  2. Taps `"Mark Attendance"` quick action button (or selects `"Attendance"` tab).
  3. Screen loads class roster for today's calendar date (`yyyy-MM-dd`).
  4. Unrecorded students default to `Present`.
  5. Teacher identifies an absent student; taps `"Absent"` status chip.
  6. Teacher identifies a student with pre-approved leave; taps `"Leave"` status chip.
  7. Taps `"Save Attendance Register"`.
  8. Controller executes atomic Firestore batch commit writing all records to `attendance` collection.
  9. Success banner confirms register persistence.
- **Alternative Flow (Date Switch)**: Teacher taps date picker to inspect or backfill attendance for a previous school day.
- **Failure Conditions**: Network failure aborts batch commit; no partial attendance is saved; error banner prompts retry.
- **Postconditions**: Attendance records persisted atomically with server timestamps.

---

### Use Case 5: Institutional Examination Scheduling
- **Actor**: Teacher (`teacher`) or School Administrator (`schoolAdmin`).
- **Preconditions**: Authenticated user assigned to target school.
- **Main Flow**:
  1. Navigates to `"Exams"` tab in role shell.
  2. Taps `"+ Schedule New Exam"`.
  3. Modal dialog prompts for: Subject, Class Name, Date, Start Time, and End Time.
  4. User enters `"Mathematics"`, `"Class 10"`, `"2026-11-15"`, `"09:30"`, `"12:30"`.
  5. Form verifies all fields are filled and start time precedes end time.
  6. Taps `"Schedule Exam"`.
  7. Record saved to `exams` collection with `status: 'Scheduled'` and `createdBy: authUser.uid`.
  8. Dialog closes; exam appears on school schedule list.
- **Alternative Flow**: Invalid time format or empty field displays validation error.
- **Failure Conditions**: User belonging to School A attempts to create exam with `schoolId: 'School B'`; Firestore rules reject operation with permission denial.
- **Postconditions**: Examination scheduled and visible to school teachers, admins, and enrolled students.

---

### Use Case 6: Student Academic Standing & Fee Inspection
- **Actor**: Student (`student`).
- **Preconditions**: Authenticated student; Firestore profile provisioned with matching `students` record.
- **Main Flow**:
  1. Lands on `StudentDashboardScreen`.
  2. Inspects `"My Attendance"` card displaying derived attendance percentage.
  3. Observes total days recorded and breakdown counts (Present, Absent, Leave).
  4. Scrolls down to `"My Fees"` card; reviews Total Due, Paid So Far, and Outstanding balance.
  5. Reads administrative remarks appended to fee record.
  6. Scrolls down to Upcoming Exams; checks scheduled subjects and dates.
- **Alternative Flow (Missing Fee Record)**: If no fee record exists, displays `"No fee record has been raised for you yet."`.
- **Failure Conditions**: If user profile lacks school assignment, upcoming exams section displays unauthorized state message.
- **Postconditions**: Student informed of personal academic standing; no data modified.

---

### Use Case 7: Student Leave Request Submission
- **Actor**: Student (`student`).
- **Preconditions**: Authenticated student viewing `StudentDashboardScreen` or leave dialog.
- **Main Flow**:
  1. Student triggers `SubmitLeaveRequestDialog`.
  2. Enters Start Date (`2026-11-10`), End Date (`2026-11-12`), and Reason (`"Family medical emergency"`).
  3. Form verifies Start Date is not after End Date.
  4. Taps `"Submit Request"`.
  5. System creates record in `leaveRequests` with `status: 'Pending'`, `studentId: authUser.uid`, and current timestamp.
  6. Success confirmation displayed; dialog dismisses.
- **Alternative Flow (Invalid Date Range)**: Student enters Start Date after End Date; system rejects submission: `"Start date cannot be after end date."`.
- **Failure Conditions**: Client injection of `reviewedBy` or non-pending status rejected by server rules.
- **Postconditions**: Leave request queued for teacher review in `leaveRequests` collection.

---

### Use Case 8: Teacher Review of Student Leave Requests
- **Actor**: Teacher (`teacher`) or School Admin (`schoolAdmin`).
- **Preconditions**: Authenticated staff member in `TeacherLeaveReviewScreen`.
- **Main Flow**:
  1. Screen displays pending leave requests for the school.
  2. Teacher reviews student name, class, requested date range, and reason.
  3. Taps `"Approve"` (or `"Reject"`).
  4. Dialog prompts for review remarks (e.g. `"Approved. Please collect homework assignments upon return."`).
  5. Teacher taps `"Confirm Approved"`.
  6. Controller updates Firestore document: `status: 'Approved'`, `reviewedBy: teacherId`, `reviewedAt: now`.
  7. Success confirmation displayed; request status chip updates to green `Approved`.
- **Alternative Flow**: Request rejected; chip updates to red `Rejected`.
- **Failure Conditions**: Teacher attempts to review a request belonging to another school; server rules deny update.
- **Postconditions**: Leave request adjudicated; record locked against further student modification.

---

## 9. Data and Business Requirements

### 9.1 Data Architecture Overview
EduLens employs a serverless document model in Cloud Firestore. No intermediate API transformation layer exists; Flutter repositories directly interact with collections through the `cloud_firestore` SDK. All collections are named in lower-case snake/camel equivalents.

```text
Cloud Firestore (Root)
├── users/             [User profile, Auth UID mapping, role, schoolId]
├── schools/           [School identity, location, contact address, phone, email]
├── students/          [Student identity, roll number, schoolId, className, section]
├── attendance/        [Daily classroom attendance: studentId, schoolId, date, status]
├── fees/              [Financial records: studentId, schoolId, totalDue, paidAmount, status]
├── exams/             [Exam timetable: schoolId, className, subject, date, times, status]
├── examAttendance/    [Per-exam attendance: examId, studentId, schoolId, status]
├── leaveRequests/     [Student leave requests: studentId, dates, reason, status, review]
└── timetables/        [Teaching timetable: schoolId, teacherId, dayOfWeek, times, class]
```

---

### 9.2 Entity Specifications

#### Entity 1: `users` Collection (`UserModel`)
- **Document ID**: Firebase Authentication UID (`request.auth.uid`).
- **Purpose**: Application-level identity and authorization attributes.

| Field | Type | Nullable | Description / Constraints |
| :--- | :--- | :--- | :--- |
| `uid` | `String` | No | Firebase Auth UID. Must match document ID. |
| `name` | `String` | No | Full display name of the user. |
| `email` | `String` | No | Registered email address. |
| `role` | `String` | No | Normalized: `'districtAdmin'`, `'schoolAdmin'`, `'teacher'`, `'student'`. |
| `schoolId` | `String` | Yes | Required for `schoolAdmin`, `teacher`, `student`. Optional for `districtAdmin`. |

---

#### Entity 2: `schools` Collection (`SchoolModel`)
- **Document ID**: Unique `schoolId` (e.g. `'sch1'`).
- **Purpose**: Institutional entity identity and directory contact details.

| Field | Type | Nullable | Description / Constraints |
| :--- | :--- | :--- | :--- |
| `schoolId` | `String` | No | Unique school identifier. Immutable by School Admins. |
| `schoolName`| `String` | No | Institutional name. Immutable by School Admins. |
| `location` | `String` | No | Geographical zone or district sector. Immutable by School Admins. |
| `address` | `String` | Yes | Optional physical campus address string. Editable by School Admin. |
| `contactNumber`| `String`| Yes | Optional telephone contact string (min 7 digits). Editable by School Admin. |
| `email` | `String` | Yes | Optional institutional contact email address. Editable by School Admin. |

---

#### Entity 3: `students` Collection (`StudentModel`)
- **Document ID**: Unique `studentId` (For enrolled students, matches Auth UID).
- **Purpose**: Official institutional student enrollment record.

| Field | Type | Nullable | Description / Constraints |
| :--- | :--- | :--- | :--- |
| `studentId`| `String` | No | Unique student identifier. For self-identifying students, equals `uid`. |
| `name` | `String` | No | Official student legal name. |
| `schoolId` | `String` | No | Foreign key linking student to assigned school. |
| `className`| `String` | No | Academic grade level (e.g. `'Class 10'`). |
| `section` | `String` | No | Section identifier (e.g. `'A'`). |
| `rollNumber`| `String`| Yes | Optional institutional roll number string (preserves distinct `studentId`). |

---

#### Entity 4: `attendance` Collection (`AttendanceModel`)
- **Document ID**: Unique `attendanceId` (e.g. `'att_sch1_stu1_2026-10-25'`).
- **Purpose**: Daily classroom attendance records. Distinct from exam attendance.

| Field | Type | Nullable | Description / Constraints |
| :--- | :--- | :--- | :--- |
| `attendanceId`| `String`| No | Unique record identifier. |
| `studentId`| `String` | No | Foreign key referencing enrolled student. |
| `schoolId` | `String` | No | Foreign key referencing school campus. |
| `teacherId`| `String` | No | Foreign key referencing educator who marked attendance. |
| `date` | `String` | No | Date string formatted strictly as `yyyy-MM-dd`. |
| `status` | `String` | No | Value: `'Present'`, `'Absent'`, or `'Leave'`. Case-insensitive matching. |

---

#### Entity 5: `fees` Collection (`FeeModel`)
- **Document ID**: Unique `feeId` (e.g. `'fee_stu1'`).
- **Purpose**: Student financial ledger account balance and settlement status.

| Field | Type | Nullable | Description / Constraints |
| :--- | :--- | :--- | :--- |
| `feeId` | `String` | No | Unique fee ledger record identifier. |
| `studentId`| `String` | No | Foreign key referencing student account. |
| `schoolId` | `String` | No | Foreign key referencing billing school. |
| `totalDue` | `double` | No | Total assessment amount due. Must be $\ge 0.0$. |
| `paidAmount`| `double`| No | Monetary amount paid to date. Must be $\ge 0.0$ and $\le \text{totalDue}$. |
| `status` | `String` | No | Nominal settlement status: `'Paid'`, `'Partial'`, `'Outstanding'`. |
| `updatedAt`| `String` | No | ISO timestamp string of latest payment entry. |
| `remarks` | `String` | Yes | Optional administrative audit note on payment status. |

---

#### Entity 6: `exams` Collection (`ExamModel`)
- **Document ID**: Unique `examId` (e.g. `'ex1'`).
- **Purpose**: Institutional and district-wide examination timetable schedule.

| Field | Type | Nullable | Description / Constraints |
| :--- | :--- | :--- | :--- |
| `examId` | `String` | No | Unique examination identifier. |
| `schoolId` | `String` | No | Foreign key referencing school hosting exam. |
| `className`| `String` | No | Target grade cohort sitting examination (e.g. `'Class 10'`). |
| `subject` | `String` | No | Academic discipline (e.g. `'Mathematics'`). |
| `date` | `String` | No | Date string formatted strictly as `yyyy-MM-dd`. |
| `startTime`| `String` | No | 24-hour time string `HH:mm` (e.g. `'09:30'`). |
| `endTime` | `String` | No | 24-hour time string `HH:mm` (e.g. `'12:30'`). Must be $\ge \text{startTime}$. |
| `createdBy`| `String` | No | Auth UID of teacher or administrator who created schedule. |
| `status` | `String` | No | Lifecycle status: defaults to `'Scheduled'`. |

---

#### Entity 7: `examAttendance` Collection (`ExamAttendanceModel`)
- **Document ID**: Unique `examAttendanceId` (e.g. `'eatt_ex1_stu1'`).
- **Purpose**: Specific candidate attendance for an examination event. Distinct from daily attendance.

| Field | Type | Nullable | Description / Constraints |
| :--- | :--- | :--- | :--- |
| `examAttendanceId`| `String`| No | Unique record identifier. |
| `examId` | `String` | No | Foreign key referencing examination. |
| `studentId`| `String` | No | Foreign key referencing student candidate. |
| `schoolId` | `String` | No | Foreign key referencing school campus. |
| `className`| `String` | No | Candidate class grade. |
| `subject` | `String` | No | Exam subject. |
| `status` | `String` | No | Attendance status: strictly `'Present'` or `'Absent'`. |
| `recordedBy`| `String`| No | Auth UID of invigilator/teacher who took attendance. |
| `recordedAt`| `String`| No | Timestamp string of attendance submission. |
| `remarks` | `String` | Yes | Optional invigilator note (e.g. `'Punctual'`, `'Late arrival'`). |

---

#### Entity 8: `leaveRequests` Collection (`LeaveRequestModel`)
- **Document ID**: Unique `requestId` (e.g. `'lr1'`).
- **Purpose**: Student academic leave application and administrative adjudication.

| Field | Type | Nullable | Description / Constraints |
| :--- | :--- | :--- | :--- |
| `requestId`| `String` | No | Unique leave request identifier. |
| `studentId`| `String` | No | Auth UID of applying student. Must equal `request.auth.uid`. |
| `studentName`| `String`| No | Name of student at time of submission. |
| `schoolId` | `String` | No | School campus foreign key. Must match student profile. |
| `className`| `String` | No | Candidate class grade. |
| `startDate`| `String` | No | Start date string `yyyy-MM-dd`. |
| `endDate` | `String` | No | End date string `yyyy-MM-dd`. Must satisfy `startDate <= endDate`. |
| `reason` | `String` | No | Substantive reason for leave. Must not be empty. |
| `status` | `String` | No | Status string: `'Pending'`, `'Approved'`, or `'Rejected'`. |
| `submittedAt`| `String`| No | Timestamp string of student submission. |
| `reviewedBy`| `String`| Yes | Auth UID of reviewing teacher or admin. Immutable by student. |
| `reviewedAt`| `String`| Yes | Timestamp string of adjudication. |
| `reviewComment`| `String`| Yes | Optional adjudication feedback note from reviewer. |

---

#### Entity 9: `timetables` Collection (`TimetableModel`)
- **Document ID**: Unique `timetableId` (e.g. `'tt1'`).
- **Purpose**: Teacher classroom schedule period assignment.

| Field | Type | Nullable | Description / Constraints |
| :--- | :--- | :--- | :--- |
| `timetableId`| `String`| No | Unique period schedule identifier. |
| `schoolId` | `String` | No | Foreign key referencing school campus. |
| `teacherId`| `String` | No | Foreign key referencing assigned educator. |
| `teacherName`| `String`| No | Display name of assigned educator. |
| `className`| `String` | No | Grade level taught (e.g. `'Class 10'`). |
| `section` | `String` | No | Section taught (e.g. `'A'`). |
| `subject` | `String` | No | Subject taught (e.g. `'Physics'`). |
| `dayOfWeek`| `String` | No | Day name: `'Monday'`, `'Tuesday'`, `'Wednesday'`, `'Thursday'`, `'Friday'`, `'Saturday'`, `'Sunday'`. |
| `startTime`| `String` | No | 24-hour time string `HH:mm` (e.g. `'09:00'`). |
| `endTime` | `String` | No | 24-hour time string `HH:mm` (e.g. `'10:00'`). Must be $\ge \text{startTime}$. |
| `roomNumber`| `String`| Yes | Optional physical classroom location (e.g. `'Room 101'`). |

---

### 9.3 Date, Time, and Formatting Standards
- **Calendar Dates**: All stored date attributes (`date`, `startDate`, `endDate`) are stored strictly as ISO `yyyy-MM-dd` strings.
  - *Rationale*: Allows direct `DateTime.tryParse()` without custom formatters; enables lexical sort ordering equal to chronological ordering.
- **Clock Times**: All stored time attributes (`startTime`, `endTime`) are stored strictly as 24-hour `HH:mm` strings.
  - *Display*: The application layer converts 24-hour times into user-friendly 12-hour AM/PM formats (e.g., `'14:30'` -> `'2:30 PM'`) via `AppDate.formatTime()`.
- **Derived Metrics**: All percentages return `null` instead of `0.0` when no records exist. The UI renders `null` as an em dash (`"—"`), maintaining semantic truth between "no data" and "zero performance".

---

## 10. Non-Functional Requirements (NFRs)

### 10.1 Security & Privacy
- **NFR-SEC-01: Zero-Trust Database Authorization**: Security is guaranteed at the database engine tier via `firestore.rules`. Compromised or modified client code cannot access or modify records outside authorized scopes.
- **NFR-SEC-02: Student Isolation**: Students are restricted strictly to records matching their own Firebase Auth UID across `students`, `attendance`, `fees`, `examAttendance`, and `leaveRequests`. Cross-student reading is rejected.
- **NFR-SEC-03: School-Scoped Isolation**: School Administrators and Teachers are restricted strictly to records matching their assigned `users.schoolId`. Cross-school operations are rejected.
- **NFR-SEC-04: Audit Immutability**: Critical audit records (such as `leaveRequests`) cannot be deleted by any role, preserving permanent institutional audit logs.

### 10.2 Data Integrity & Atomicity
- **NFR-INT-01: All-or-Nothing Register Commits**: Classroom attendance registers must commit via atomic Firestore batches (`saveAttendanceBatch()`). Partial register persistence is strictly prevented.
- **NFR-INT-02: Overpayment Prevention**: Client validation and repository logic enforce that `paidAmount <= totalDue` on fee updates, preventing negative balances.
- **NFR-INT-03: ID Duplication Integrity**: Every written document must duplicate its document ID within the payload map to satisfy `dataWithId()` fallback requirements.

### 10.3 Usability & Design System
- **NFR-USE-01: Unified Design System**: The application strictly adheres to the `AppTheme` palette (`AppColors.primary`, `AppColors.secondary`, `AppSpacing`, `AppTextStyles`).
- **NFR-USE-02: Predictable View States**: Every data-driven screen uses `ViewStateBuilder` or `StateMessage` to uniformly present Loading, Ready, Empty, and Error states.
- **NFR-USE-03: Responsive Form Factors**: Interfaces must resize seamlessly between mobile viewports (minimum 360dp width) and desktop/web browser viewports.

### 10.4 Maintainability & Architecture
- **NFR-MNT-01: Clean Decoupled Architecture**: High-level screens interact with feature controllers, which interact with repository interfaces, which interact with Firestore implementations. No UI screen directly imports Firestore SDK.
- **NFR-MNT-02: Safe Async Lifecycles**: All controllers must mix in `SafeNotifier` to guarantee that asynchronous network responses never trigger `notifyListeners()` on disposed widgets.
- **NFR-MNT-03: Centralized Constants**: Firestore collection names and field strings are centralized in `FirestoreCollections` and `FirestoreFields`, preventing string typos.

### 10.5 Reliability & Fault Tolerance
- **NFR-REL-01: Exception Masking**: Network or permission exceptions must be translated into user-readable messages via `RepositoryException.fromFirebase()`.
- **NFR-REL-02: Offline & Reconnection Tolerance**: The application must handle connectivity drops gracefully, providing manual retry buttons (`onRetry`) on all error states.

### 10.6 Testability & Verification
- **NFR-TST-01: Complete Faking Infrastructure**: All repository contracts must be accompanied by in-memory fake implementations (`test/support/fake_repositories.dart`) supporting simulated latency and deterministic failure injection.
- **NFR-TST-02: Multi-Tiered Verification**: Codebase must pass static linting (`flutter analyze`), formatting verification (`dart format`), Flutter unit/widget/integration tests (`flutter test`), and Firestore Rules emulator assertions (`npm test`).

### 10.7 Performance Targets
- **NFR-PRF-01: Target Freshness Objective**: Target data propagation from write acknowledgment to authorized read on external dashboard is $\le 5$ seconds under standard WAN network conditions. *(Note: Verified at sub-150ms in local emulator; unverified in live production WAN).*
- **NFR-PRF-02: Roster Search Responsiveness**: In-memory student roster filtering must execute in under 16ms (60 FPS) for rosters up to 500 students.

---

## 11. Validation Rules and Error Handling

The following validation specifications are verified by automated tests across the codebase:

```text
Validation Rules
├── User Profiles: Role must be one of 4 canonical roles; UID must be non-empty.
├── School Info: Contact phone min 7 digits; Email must match standard regex.
├── Fee Management: paidAmount >= 0; totalDue >= 0; paidAmount <= totalDue.
├── Exam Scheduling: Date format yyyy-MM-dd; 24-hr times HH:mm; startTime <= endTime.
├── Leave Requests: startDate <= endDate; reason non-empty; status must be 'Pending'.
├── Classroom Attendance: Atomic batch; valid studentId, schoolId, teacherId; status in [Present, Absent, Leave].
└── Permissions: Unauthenticated requests rejected; unauthorized access routes to permissionDenied.
```

### Detailed Validation Matrix

| Context | Field / Entity | Rule / Constraint | Failure Response |
| :--- | :--- | :--- | :--- |
| **Authentication** | `email` | Must be non-empty and valid email format. | Inline error: `"The email address is formatted incorrectly."` |
| **Authentication** | `password` | Must be non-empty; reset requires min 6 chars. | Inline error: `"Password must be at least 6 characters long."` |
| **School Admin** | `contactNumber`| If non-empty, must contain $\ge 7$ digits. | Inline error: `"Please enter a valid contact number (at least 7 digits)"` |
| **School Admin** | `email` | If non-empty, must match `^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$`. | Inline error: `"Please enter a valid email address"` |
| **Fee Management** | `paidAmount` | Must be numeric, $\ge 0$, and $\le \text{totalDue}$. | Inline error: `"Paid amount cannot exceed total due ($totalDue)"` |
| **Exam Schedule** | `startTime`, `endTime`| 24-hour `HH:mm`; `startTime <= endTime`. | Form rejection / dialog validation warning. |
| **Leave Request** | `startDate`, `endDate`| Format `yyyy-MM-dd`; `startDate <= endDate`. | Error banner: `"Start date cannot be after end date."` |
| **Leave Request** | `reason` | Trimmed string must not be empty. | Error banner: `"Please provide a valid reason for your leave request."` |
| **Leave Review** | `status` | Must transition from `'Pending'` to `'Approved'` or `'Rejected'`. | Firestore Rules reject any other status mutation. |
| **Bootstrap** | `users.role` | Must be non-empty and recognizable role. | StateMessage: `"Your user profile has an unassigned or invalid role."` |
| **Security** | Cross-tenant read | Caller schoolId must match document schoolId. | `RepositoryException`: `"You do not have permission to {action}."` |

---

## 12. Acceptance Criteria

### 12.1 Functional Acceptance Criteria
- [x] **FAC-01**: Authenticating as a `districtAdmin` mounts `DistrictShell` showing macro-level KPIs across all schools.
- [x] **FAC-02**: Schools with derived attendance $< 70.0\%$ render attention alert warnings on District and School Admin dashboards.
- [x] **FAC-03**: Authenticating as a `schoolAdmin` mounts `SchoolAdminShell` scoped strictly to assigned `schoolId`.
- [x] **FAC-04**: School Admins can update school address, contact number, and email; changes persist and re-render.
- [x] **FAC-05**: Fee editing enforces `paidAmount <= totalDue`; attempts to exceed total due fail validation.
- [x] **FAC-06**: Authenticating as a `teacher` mounts `TeacherShell` displaying today's classes from `timetables`.
- [x] **FAC-07**: Daily attendance register saves atomically; non-present records count towards attendance percentage denominator.
- [x] **FAC-08**: Authenticating as a `student` mounts `StudentShell` displaying personal attendance %, fee ledger, and upcoming exams.
- [x] **FAC-09**: Student exam schedule is read-only; no scheduling controls are displayed.
- [x] **FAC-10**: Students can submit leave requests with `startDate <= endDate`; teachers can approve or reject with comments.

### 12.2 Security Acceptance Criteria
- [x] **SAC-01**: Unauthenticated requests to any Firestore collection are rejected with permission denial.
- [x] **SAC-02**: Students querying other students' attendance, fee, or profile documents receive permission denial.
- [x] **SAC-03**: Teachers or School Admins querying documents belonging to outside schools receive permission denial.
- [x] **SAC-04**: Students attempting to create or modify examinations or attendance receive permission denial.
- [x] **SAC-05**: Deleting `leaveRequests` is prohibited across all user roles.

### 12.3 UX & Accessibility Acceptance Criteria
- [x] **UAC-01**: All data-driven screens display `StateMessage(type: loading)` during query fetch.
- [x] **UAC-02**: Empty query results display descriptive empty-state illustrations and messages via `ViewStateBuilder`.
- [x] **UAC-03**: Network failures display user-safe error messages with an interactive `"Try Again"` retry button.
- [x] **UAC-04**: Logout confirmation modal prevents accidental session termination.

### 12.4 Verification & Testing Acceptance Criteria
- [x] **TAC-01**: `git diff --check` passes with zero whitespace or formatting errors.
- [x] **TAC-02**: `dart format --output=none --set-exit-if-changed lib test` passes cleanly.
- [x] **TAC-03**: `flutter analyze` reports zero warnings, hints, or static errors.
- [x] **TAC-04**: All 313 Flutter unit, widget, and E2E integration tests in `test/` pass without failure.

### 12.5 Production Deployment Prerequisites (Pending Verification)
- [ ] **DEP-01**: CI/CD environment runner configured with Node.js 20+ and Java JDK 17+.
- [ ] **DEP-02**: Execute `cd test/rules && npm test` and verify 100% pass rate for Firestore Rules tests against the Firebase Emulator Suite.
- [ ] **DEP-03**: Deploy hardened `firestore.rules` to production: `firebase deploy --only firestore:rules`.
- [ ] **DEP-04**: Enable Email/Password authentication provider in target Firebase Console project.
- [ ] **DEP-05**: Provision production initial accounts with valid `users/{uid}` documents.

---

## 13. Dependencies and Technical Constraints

### 13.1 Runtime Platform & SDK Constraints
- **Flutter SDK**: Compatible with Dart SDK `^3.13.4` (defined in `pubspec.yaml`).
- **Target OS Support**: Android (API level 21+), Web (Wasm/CanvasKit and HTML renderers), iOS (iOS 13+).
- **Material Design**: `uses-material-design: true` with Material 3 typography and design system.

### 13.2 Core Package Dependencies
- `firebase_core: ^4.15.0`: Core Firebase platform initialization.
- `firebase_auth: ^6.7.0`: Client authentication SDK for email/password and session state.
- `cloud_firestore: ^6.10.0`: Document database SDK with client caching and offline support.
- `cupertino_icons: ^1.0.8`: Supporting icon set.
- `flutter_lints: ^6.0.0` (dev): Official Flutter static analysis lint rules.

### 13.3 Test & Tooling Infrastructure
- **Flutter Test**: In-memory fake repositories in `test/support/fake_repositories.dart`.
- **Firebase Emulator Suite**: Node.js test harness under `test/rules/` utilizing `@firebase/rules-unit-testing: 4.0.1` and `firebase-tools: ^13.35.1`. Requires Java Runtime Environment (JRE/JDK 17+).

---

## 14. Risks, Technical Debt, and Open Questions

### 14.1 Discrepancy in Historical Rules Emulator Reports
- **Context**: A historical discrepancy exists between committed engineering reports:
  - `docs/DAY12_INTEGRATION_REPORT.md` reports that the JavaScript rules emulator suite ran successfully with 23 passing tests on an environment with Java 17.
  - `docs/MVP_ACCEPTANCE_AUDIT.md` notes that rules tests were marked not executed during Day 19 due to a local Java runner configuration error (`Could not spawn java -version`).
- **Current Technical Reality**: The tests in `test/rules/rules.test.mjs` are completely written and verified syntactically. The suite requires execution on a Java-enabled CI/CD agent before live deployment.
- **Risk Mitigation**: Mandate `cd test/rules && npm test` as a blocking gate in the automated CI/CD pipeline prior to running `firebase deploy`.

### 14.2 Deployed vs. Committed Rules State
- **Context**: The Day 12 integration report explicitly noted that the corrected `firestore.rules` file had not been deployed to the live Firebase project.
- **Risk**: If the live Firebase project still runs legacy rules, the security hardening (preventing students from reading classmates' records) remains open in production.
- **Mitigation**: Authorized project maintainers must run `firebase deploy --only firestore:rules` to synchronize production with the repository source.

### 14.3 Data Model Report Drift vs. Current Source
- **Context**: `docs/DATA_MODEL_GAP_REPORT.md` (authored on Day 5) marks Timetables, Exam Attendance, Leave Requests, and Exam Status as unresolved gaps.
- **Resolution in Code**: The current codebase has completely resolved all four gaps:
  - Timetable model, repository, and screens implemented.
  - Exam attendance model, repository, and security rules implemented.
  - Leave request model, student dialog, teacher review screen, and security rules implemented.
  - Exam status defaults to `'Scheduled'` across models and UI badges.
- **Action**: This PRD stands as the authoritative source of truth reconciling all historical documents.

### 14.4 Examination Attendance UI Surface
- **Context**: The data foundation for per-exam student attendance (`ExamAttendanceModel`, `ExamAttendanceRepository`, and Firestore security rules) is fully implemented and tested. However, a dedicated UI screen for marking exam-specific attendance is not yet linked in the teacher navigation shell.
- **Status**: Documented as **Partially Implemented** (backend ready; frontend UI scheduled for Phase 2).

### 14.5 Shell Integration for Timetable and Leave Review
- **Context**: `TeacherTimetableScreen` and `TeacherLeaveReviewScreen` exist as fully functional widgets with controllers, verified by E2E journey tests. However, the four primary bottom navigation tabs of `TeacherShell` are currently mapped to Home, Attendance, Exams, and Profile.
- **Status**: These features are accessed via dashboard quick actions and dedicated journey routes. Future shell refactoring can introduce drawer or expanded navigation.

---

## 15. Out of Scope and Future Enhancements

The following enhancements are proposed for future roadmap consideration and are explicitly **not** part of the current MVP:

1. **Digital Payment Gateway Integration (Phase 2)**:
   - Integration with Stripe / Razorpay / UPI for real-time online fee settlement by students or parents.
   - Automated digital receipt generation and PDF download.
2. **Dedicated Exam Attendance Marking UI (Phase 2)**:
   - UI screen allowing invigilators to pull candidate lists for an exam and mark exam-specific presence/absence.
3. **Automated Notification System (Phase 3)**:
   - Firebase Cloud Messaging (FCM) integration for push notifications on student absences, fee due dates, and exam announcements.
   - SMS dispatch for critical low-attendance alerts to parent guardians.
4. **Academic Gradebook & Marks Management (Phase 3)**:
   - Schema expansion to record marks obtained per exam.
   - Automated grade calculations (GPA), class rankings, and report card exports.
5. **Parent / Guardian Portal (Phase 4)**:
   - Dedicated persona enabling parents to track academic progress and communicate with teachers.
6. **Biometric & QR Code Attendance Verification (Phase 4)**:
   - Student QR code identity card scanning for automated gate and classroom check-ins.

---

## 16. Glossary

- **Atomic Batch Write**: A Firestore database transaction pattern where multiple document writes are submitted together; either all succeed, or all fail with zero partial data persistence.
- **Attention Threshold**: The district-mandated minimum attendance percentage (strictly 70.0%). Any school or student below this number triggers visual warning alerts.
- **Cloud Firestore**: Google's serverless NoSQL document database utilized as the primary persistence layer for EduLens.
- **Data Freshness**: The latency between a write acknowledgment in Firestore and its visibility on an authorized observer's dashboard.
- **dataWithId**: An internal repository mapper helper that ensures every deserialized document carries its own document ID, falling back to `doc.id` if the payload field is absent.
- **District Administrator (`districtAdmin`)**: The top-level administrative user role possessing district-wide read/write permissions across all schools.
- **Exam Attendance**: Attendance recorded specifically for an examination event; stored in `examAttendance` and strictly isolated from daily classroom attendance.
- **Fake Repositories**: In-memory Dart mock classes implementing repository interfaces used to test screens and controllers without live Firebase network calls.
- **Fee Collection Rate**: The amount-weighted financial metric computed as $\frac{\sum \text{paidAmount}}{\sum \text{totalDue}} \times 100$.
- **Firebase Authentication**: The identity service managing user email and password authentication, password reset links, and JWT token claims.
- **Role Router**: The centralized Flutter routing widget (`RoleRouter`) that checks Firebase auth state and queries `users/{uid}` to route users to their assigned role shell.
- **SafeNotifier**: A custom Flutter `ChangeNotifier` mixin that suppresses notification calls if a controller has been disposed, eliminating asynchronous memory leaks.
- **School Administrator (`schoolAdmin`)**: The institutional administrative role governing operations, fees, and contact details for a single assigned school.
- **Seeder Tool (`tool/seed_firestore.dart`)**: A Flutter development utility used to populate an authorized development Firebase project with realistic multi-role demonstration data.
- **Student (`student`)**: The enrolled pupil role possessing strictly isolated read-only access to their own attendance, fees, and school exams, plus leave submission rights.
- **Teacher (`teacher`)**: The instructional user role responsible for daily classroom attendance taking, timetable tracking, exam scheduling, and leave request review.
- **User Bootstrap**: The startup sequence that reads `users/{uid}` in Cloud Firestore to resolve a user's canonical role and institutional `schoolId`.
- **ViewState**: A sealed class / pattern representing the visual state of a screen: `loading`, `ready`, `empty`, `error`, or `unauthorized`.
