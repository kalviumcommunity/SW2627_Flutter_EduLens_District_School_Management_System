# EduLens — District & School Management System

EduLens is a Flutter application for district-wide school monitoring and school-level workflows, backed by Firebase Authentication and Cloud Firestore.

> **Project status:** Academic software project with role-based workflows and automated tests. Production readiness is conditional: Firestore Rules deployment is not evidenced in the repository, and the committed reports disagree about whether the Rules Emulator suite was run. See [Security and verification status](#security-and-verification-status).

## Overview

EduLens brings district-level visibility and school-level operations into one application. Authenticated users are routed to a dashboard based on the role stored in their Firestore user profile.

The codebase includes workflows for four roles:

| Role | Implemented workflows represented in the source |
|---|---|
| **District Admin** | District dashboard and metrics, school list and details, district exam overview, and exam details. |
| **School Admin** | School dashboard, school information, exam schedule management, and student fee-record management. |
| **Teacher** | Teacher dashboard, timetable, daily attendance management, and leave-request review. |
| **Student** | Personal attendance and fee dashboard, read-only upcoming exam information, and leave-request submission/history support. |

The table describes functionality present in the repository; it does not imply that the app is deployed or connected to a production environment.

## Technology stack

| Technology | Purpose in EduLens |
|---|---|
| Flutter | Cross-platform UI and application framework |
| Dart | Application language |
| Firebase Authentication | Email/password sign-in, authentication state, password-reset flow |
| Cloud Firestore | User profiles, school data, student records, attendance, fees, exams, timetables, and leave workflows |
| Firestore Security Rules | Server-side authorization rules stored in `firestore.rules` |
| Firebase Emulator Suite and JavaScript test tooling | Runtime testing of Firestore Rules |
| Git | Source control and collaboration |

The Flutter dependencies for Firebase are declared in `pubspec.yaml`. The repository also includes Android and web platform configuration.

## Architecture

EduLens uses feature-oriented Flutter folders, screen/controller pairs, repository interfaces, and Firestore-backed repository implementations. It does not contain a separate application API server in the inspected repository.

```text
Flutter UI (role-specific screens)
            |
            v
Feature controllers and view-state helpers
            |
            v
Repository interfaces
            |
            v
Firestore repository implementations
            |
            v
Firebase SDKs
       |          |
       v          v
Firebase Auth   Cloud Firestore
```

- **Entry point:** `lib/main.dart` initializes Flutter bindings and Firebase using `DefaultFirebaseOptions`, then launches `EduLensApp`.
- **Authentication and role routing:** `lib/services/auth_service.dart`, `lib/services/user_bootstrap_service.dart`, and `lib/routes/role_router.dart` handle authentication state, load the signed-in user's profile from `users/{uid}`, and route recognized roles to their shells.
- **Feature code:** `lib/features/` groups screens and controllers by role and feature.
- **Data models:** `lib/models/` defines Firestore record models and their map serialization.
- **Data access:** `lib/repositories/` contains repository contracts and Firestore implementations.
- **Shared UI/state:** `lib/core/` contains reusable widgets, theme, constants, metrics, date utilities, and view-state helpers.

The router includes loading, missing-profile, invalid-profile, and error states. The exact data a user can access must still be enforced by Firestore Rules, not only by UI routing.

## Repository structure

```text
.
├── android/                  # Android platform project and Firebase config
├── docs/                     # Data-model, integration, and acceptance reports
├── ios/                      # iOS platform project
├── lib/
│   ├── core/                 # Shared UI, state, metrics, theme, utilities
│   ├── features/
│   │   ├── auth/
│   │   ├── district/
│   │   ├── school_admin/
│   │   ├── teacher/
│   │   └── student/
│   ├── models/               # Data models and serialization
│   ├── repositories/         # Repository contracts and Firestore adapters
│   ├── routes/               # App routes and role router
│   ├── services/             # Authentication and user bootstrap
│   ├── app.dart
│   ├── firebase_options.dart
│   └── main.dart
├── test/                     # Flutter tests and Firestore Rules tests
│   └── rules/                # JavaScript tests for the Firestore Emulator
├── tool/
│   └── seed_firestore.dart   # Demo data/account seeder
├── web/                      # Web platform files
├── firebase.json             # Firebase emulator and rules configuration
├── firestore.rules           # Firestore authorization rules
├── pubspec.yaml              # Flutter dependencies and SDK constraints
└── README.md
```

Additional committed engineering reports are available in [`docs/DATA_MODEL_GAP_REPORT.md`](docs/DATA_MODEL_GAP_REPORT.md), [`docs/DAY12_INTEGRATION_REPORT.md`](docs/DAY12_INTEGRATION_REPORT.md), and [`docs/MVP_ACCEPTANCE_AUDIT.md`](docs/MVP_ACCEPTANCE_AUDIT.md).

## Data model

The source defines models for users, schools, students, daily attendance, fees, exams, exam-specific attendance, leave requests, and timetables. The Firestore Rules file contains matching collection rules for the following collection names:

| Collection | Purpose |
|---|---|
| `users` | User profile and role; the document ID is the Firebase Authentication UID |
| `schools` | School identity and contact information |
| `students` | Student identity, school, class, section, and optional roll number |
| `attendance` | Daily attendance records |
| `fees` | Student fee due/paid amounts and status |
| `exams` | School- and class-scoped exam schedule |
| `examAttendance` | Attendance associated with a specific exam; distinct from daily attendance |
| `leaveRequests` | Student leave submissions and review metadata |
| `timetables` | Teacher/class timetable entries |

The code stores record identifiers in document fields as well as in Firestore document paths. Date fields used by attendance and exams are represented as strings; the data-model report specifies `yyyy-MM-dd` for dates and `HH:mm` for times.

### Dashboard metrics

The implementation in `lib/core/utils/metrics.dart` computes dashboard metrics from source records rather than storing derived totals on school documents:

- **Attendance percentage:** number of `Present` records divided by all attendance records in scope, multiplied by 100. If there are no records, the value is unavailable and displays as an em dash.
- **Fee-paid percentage:** sum of `paidAmount` divided by sum of `totalDue`, multiplied by 100. If no amount is due, the value is unavailable.
- **Attendance attention threshold:** below 70%.
- **Upcoming exams:** filtered and sorted by date; the district dashboard's upcoming window is seven days.

The fee percentage is amount-weighted, while the school details fee breakdown separately counts paid, partial, and outstanding records.

## Getting started

### Prerequisites

Install and configure:

- Flutter SDK with a Dart version compatible with the constraint in `pubspec.yaml`.
- Android Studio and Android SDK tools for Android development, or a supported target device/browser.
- Git.
- Access to an authorized Firebase project with the required Authentication and Cloud Firestore services enabled.

Check the local Flutter/Android setup:

```bash
flutter doctor
flutter devices
```

### Clone and install dependencies

```bash
git clone https://github.com/kalviumcommunity/SW2627_Flutter_EduLens_District_School_Management_System.git
cd SW2627_Flutter_EduLens_District_School_Management_System
flutter pub get
```

### Firebase configuration

The repository contains `lib/firebase_options.dart`, `android/app/google-services.json`, `.firebaserc`, and `firebase.json`. These files configure the existing Firebase project; verify with the project maintainer that you are authorized to use that project before running the app or seeder.

If you need to connect a different Firebase project:

1. Sign in to Firebase using the Firebase CLI and ensure you have permission to use the target project.
2. Configure the Flutter platforms using the [FlutterFire setup guide](https://firebase.google.com/docs/flutter/setup).
3. Ensure the generated `lib/firebase_options.dart` and platform-specific Firebase configuration correspond to the same authorized project.
4. In the Firebase Console, enable the Authentication provider required by the app and configure Cloud Firestore.
5. Review `firestore.rules` and test the rules before any authorized deployment.

Do not commit service-account credentials, private keys, passwords, or local demo credential manifests. Do not deploy Firestore Rules as part of routine local setup.

### Run the app

Start an Android emulator from Android Studio Device Manager, connect a supported device, or use Chrome for web development. Then run:

```bash
flutter devices
flutter run
```

To target a specific device, pass its identifier:

```bash
flutter run -d <device-id>
```

Replace `<device-id>` with an identifier shown by `flutter devices`.

### Optional: seed demonstration data

The repository includes `tool/seed_firestore.dart`, which creates demo authentication accounts and Firestore records. It is a **write operation against the Firebase project configured for the app**. Use it only with a dedicated, authorized development/demo Firebase project—not a production or shared project containing real data.

The repository's existing command is:

```bash
flutter run -t tool/seed_firestore.dart -d chrome
```

Follow the seeder UI instructions in the browser. The tool generates a local `demo_credentials.local.md` manifest, which is gitignored. Treat that file as sensitive and do not share or commit it. The README intentionally does not publish demo passwords or account credentials.

## Testing and quality checks

Run the Flutter checks from the repository root:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test --reporter expanded
git diff --check
```

The Dart/Flutter suite includes model and repository-contract tests, controller and screen/widget tests, role-routing tests, and multi-role journey tests built with fake/in-memory repositories. These tests do **not** execute Firestore Security Rules in the Firebase rules engine.

### Firestore Rules Emulator tests

The JavaScript rules suite is under `test/rules/` and uses the Firebase Emulator Suite. It requires Node.js/npm and a compatible Java runtime. From the repository root:

```bash
cd test/rules
npm install
npm test
```

The package also defines a freshness check:

```bash
npm run freshness
```

These commands run against an emulator configuration, not automatically against deployed production rules. A successful local rules test is not evidence that the same rules have been deployed to Firebase.

## Security and verification status

`firestore.rules` defines role- and school-scoped access conditions for the collections listed above. Static inspection of the rules is not a substitute for testing authorization behavior at runtime, and passing Flutter tests alone does not establish security readiness.

The committed reports contain **conflicting historical statements** about the Firestore Rules Emulator suite:

- `docs/DAY12_INTEGRATION_REPORT.md` records a successful emulator run with 23 passing tests.
- `docs/MVP_ACCEPTANCE_AUDIT.md` records the Rules Emulator suite as not executed due to a Java environment blocker.

Because these reports disagree, rerun `cd test/rules && npm install && npm test` in a suitable environment and record the actual result before relying on the rules verification claim. The Day 12 report explicitly states that the corrected rules were **not deployed**. This repository does not provide evidence of a later deployment, so deployment status must be confirmed by an authorized project maintainer.

The reports also identify manual/production verification as incomplete. Do not describe the application or its data as production-secure based solely on the presence of rules or passing Flutter tests.

## Known limitations and documentation follow-up

- **Rules deployment:** The committed Day 12 report says the corrected `firestore.rules` file was not deployed. Confirm the deployed state and deploy only through an authorized, reviewed process.
- **Rules test evidence:** The Day 12 integration report and MVP acceptance audit disagree on whether emulator tests ran. Re-run the suite and update the evidence.
- **Data-model report drift:** `docs/DATA_MODEL_GAP_REPORT.md` still labels timetable, exam-specific attendance, leave status, and scheduled exam status as unresolved, while `docs/MVP_ACCEPTANCE_AUDIT.md` describes those areas as resolved and the current source contains related models/workflows. Reconcile the reports against the current implementation.
- **Manual integration checks:** The Day 12 report marks several live-Firebase propagation and manual QA checks as not run because provisioned test accounts/data were unavailable.
- **Deployment and production readiness:** No deployment or production-readiness claim is made here.

## Contributing and development workflow

For a focused change:

1. Update your local `main` branch.
2. Create a branch for the change.
3. Keep the change scoped and review the diff.
4. Run formatting, static analysis, and the relevant tests.
5. Review `git status` and `git diff --check`.
6. Open a pull request for review according to your team's workflow.

For a README-only change, verify that only the root `README.md` is modified.

## License and acknowledgements

No license is identified in the inspected repository root. Check with the project maintainers before redistributing the project or assuming permissions beyond those granted by the repository host.
