# EduLens — District & School Management System

EduLens is a Flutter-based multi-role District and School Management System integrated with Firebase Authentication and Cloud Firestore.

---

## 🚀 Multi-School Demo Environment & Credentials

EduLens includes an automated, idempotent seeding tool (`tool/seed_firestore.dart`) that populates a realistic 4-school demonstration environment complete with real Firebase Auth accounts and matching Firestore user profiles.

### Demo Account Credentials Overview

Default Demo Password for all accounts: **`EduLensDemo2026!`**

| Role | Name | Assigned School / Scope | Login Email |
|---|---|---|---|
| **District Admin** | Dr. Aditya Mehta | District-wide (All Schools) | `district.admin@edulens.demo` |
| **School Admin** | Sarah Connor | Greenwood High | `admin.school01@edulens.demo` |
| **School Admin** | David Miller | Riverside Public School | `admin.school02@edulens.demo` |
| **School Admin** | Elena Rostova | Hilltop Academy | `admin.school03@edulens.demo` |
| **School Admin** | Marcus Vance | Oakridge International | `admin.school04@edulens.demo` |
| **Teacher** | Rahul Verma | Greenwood High | `teacher1.school01@edulens.demo` |
| **Teacher** | Arjun Nair | Riverside Public School | `teacher1.school02@edulens.demo` |
| **Student** | Asha Rao | Greenwood High (Class 10-A) | `student1.school01@edulens.demo` |
| **Student** | Charlie Brown | Riverside Public School (Class 9-A) | `student1.school02@edulens.demo` |

> *Full credentials list containing all 105 seeded accounts (20 Teachers and 80 Students) is automatically generated at `demo_credentials.local.md` upon running the seeder.*

---

## 🛠️ Running the Demo Seeder

To seed or refresh the demo dataset in your connected Firebase environment:

```bash
flutter run -t tool/seed_firestore.dart -d chrome
```

Click **"Seed Demo Data & Accounts"** in the web interface. The script:
1. Creates 4 schools (`school01` to `school04`).
2. Creates 105 Firebase Auth users + Firestore profile documents (`/users/{uid}`).
3. Creates 80 student records, attendance histories, fee payment records, exam schedules, teacher timetables, exam attendance records, and leave requests.
4. Generates local manifest `demo_credentials.local.md` (gitignored).

---

## 🧪 Quality Checks & Testing

Run all quality checks from project root:

```bash
git diff --check
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test --reporter expanded
```
