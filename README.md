<p align="center">
  <img src="assets/icon/app_icon.png" width="120" height="120" alt="PetroFlow Logo" style="border-radius: 24px;" />
</p>

<h1 align="center">PetroFlow — Mobile Productivity Suite</h1>

<p align="center">
  <strong>A modern, production-grade cross-platform task management & focus application for Android and iOS.</strong>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.41.9-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Version" /></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.11.5-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Version" /></a>
  <a href="https://riverpod.dev"><img src="https://img.shields.io/badge/State-Riverpod_2.6-blue?style=for-the-badge" alt="Riverpod" /></a>
  <a href="https://material.io/design"><img src="https://img.shields.io/badge/Design-Material_3-7C4DFF?style=for-the-badge" alt="Material 3" /></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License: MIT" /></a>
</p>

---

## 📖 Overview

**PetroFlow** is built with **Flutter 3.41** and structured around **Clean Architecture principles**. It delivers a high-performance, native mobile experience that seamlessly synchronizes with the **MERN Todo Pro** ecosystem across web and cloud.

Whether organizing high-priority engineering tasks, running focused 25-minute Pomodoro sessions, tracking weekly completion trends, or orchestrating tasks across interactive Kanban stages, PetroFlow empowers individuals and teams to achieve peak flow.

---

## 🌟 Key Highlights & Features

### 📋 Intelligent Task Engine
- **Multi-Level Priority Matrix**: `Urgent` (🔴), `High` (🟠), `Medium` (🟡), and `Low` (🟢) with dynamic visual hierarchy.
- **Smart Top-Pinning**: Pin mission-critical tasks to the top of your catalog.
- **Subtask Checklists & Live Progress**: Nested subtasks with real-time percentage completion rings.
- **Tagging & Instant Filtering**: Multi-select tags, live search, and due-date status indicators (*Today*, *Upcoming*, *Overdue*).
- **Bulk Action Operations**: Batch complete, delete, or re-prioritize multiple items simultaneously.

### 📊 3-Column Kanban Board
- Mobile-optimized kanban view with quick-switch stage columns:
  - 📋 **To Do**
  - ⚡ **In Progress**
  - ✅ **Completed**
- One-tap status progressions and fluid horizontal transitions.

### 🍅 Focus Mode (Pomodoro Timer)
- Built-in Pomodoro workflow with **25-min Work**, **5-min Short Break**, and **15-min Long Break** intervals.
- **Task Linking**: Directly associate a pending task to your active focus session and auto-complete upon session conclusion.
- Daily session counter with persistent streak tracking (🔥).

### 📈 Visual Analytics & Goal Tracking
- **7-Day Velocity Chart**: Interactive bar charts powered by `fl_chart`.
- **Daily Target Ring**: Visual representation of daily task goals (e.g., 5 tasks/day).
- **Metric Breakdown**: Instant counts of active, overdue, high-priority, and completed items.

### 🌓 Material 3 Theming & Offline Cache
- **Adaptive Dark & Light Themes**: Carefully tuned contrast palettes designed for OLED screens and daytime clarity.
- **Offline Resilience**: Instant access to cached tasks, profile settings, and statistics via local storage.

---

## 🏗️ Ecosystem Architecture

PetroFlow operates as the mobile client within the unified **PetroFlow / MERN Todo Pro** cross-platform ecosystem:

```text
┌────────────────────────────────────────────────────────────────────────┐
│                        PETROFLOW UNIFIED ECOSYSTEM                     │
├───────────────────────────────────┬────────────────────────────────────┤
│   🌐 React Web Frontend           │   📱 PetroFlow Mobile App          │
│   (mern-todo-pro)                 │   (flutter_todo_pro)               │
│   https://mern-todo-pro.vercel.app│   Android & Apple iOS Application  │
└─────────────────┬─────────────────┴─────────────────┬──────────────────┘
                  │                                   │
                  └─────────────────┬─────────────────┘
                                    │ HTTPS / REST (JWT Bearer)
                                    ▼
                  ┌───────────────────────────────────┐
                  │   🚀 Node.js / Express Backend   │
                  │   https://mern-todo-pro.onrender  │
                  └─────────────────┬─────────────────┘
                                    │ Mongoose ORM
                                    ▼
                  ┌───────────────────────────────────┐
                  │   🍃 MongoDB Atlas Database       │
                  │   Unified Users & Task Collections│
                  └───────────────────────────────────┘
```

---

## 📁 Codebase Structure

PetroFlow adheres to a feature-driven, layered architecture:

```text
lib/
├── core/
│   ├── constants/        # API URLs, color palettes, and global constants
│   ├── network/          # Dio client, JWT interceptor, error wrappers
│   ├── storage/          # SharedPreferences persistence layer
│   ├── theme/            # Material 3 light and dark theme definitions
│   └── utils/            # Date formatting and helper utilities
├── data/
│   ├── models/           # UserModel, TodoModel, SubtaskModel, TodoStatsModel
│   └── repositories/     # AuthRepository, TodoRepository
├── features/
│   ├── analytics/        # Analytics screen & weekly bar chart widgets
│   ├── auth/             # Login & Registration screens with validation
│   ├── focus/            # Focus/Pomodoro timer & linked task runner
│   ├── kanban/           # 3-Column Kanban board & stage shift widgets
│   ├── profile/          # User profile, goal configuration & API switcher
│   ├── shell/            # Main bottom navigation shell
│   ├── splash/           # PetroFlow branded launch splash
│   └── tasks/            # Task list, search, filter chips, task editor sheet
├── providers/            # Riverpod state management notifiers & providers
├── shared/
│   └── widgets/          # Buttons, inputs, empty states, loading indicators
└── main.dart             # Application entry point with ProviderScope
```

---

## 🛠️ Technology Stack

| Domain | Technology / Package | Purpose |
| :--- | :--- | :--- |
| **Framework** | [Flutter 3.41](https://flutter.dev) / [Dart 3.11](https://dart.dev) | High-performance cross-platform engine |
| **Architecture** | Feature-First / Clean Layering | Modularity, testability, and separation of concerns |
| **State Management** | [Flutter Riverpod 2.6](https://pub.dev/packages/flutter_riverpod) | Reactive, compile-safe dependency injection |
| **Networking** | [Dio 5.11](https://pub.dev/packages/dio) | REST API client, interceptors & error mapping |
| **Charts** | [fl_chart 0.68](https://pub.dev/packages/fl_chart) | Smooth, interactive analytics visualization |
| **Typography** | [Google Fonts (Inter)](https://pub.dev/packages/google_fonts) | Clean modern typography |
| **Persistence** | [SharedPreferences](https://pub.dev/packages/shared_preferences) | Local session & offline caching |
| **Icons** | [Lucide Icons](https://pub.dev/packages/lucide_icons) & Material Icons | Sharp, consistent vector iconography |

---

## 🚀 Getting Started

### 1. Prerequisites
Ensure you have the following installed on your development workstation:
- **Flutter SDK**: `v3.10.0` or higher ([Installation Guide](https://docs.flutter.dev/get-started/install))
- **Android Studio / Android SDK**: API 34+ (for Android builds)
- **Xcode**: 15+ (for macOS / iOS builds)
- **JDK**: Java 17 (recommended for Gradle 8 compatibility)

### 2. Clone the Repository
```bash
git clone https://github.com/petrossisay1646/flutter_todo_pro.git
cd flutter_todo_pro
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Code Quality & Test Verification
Verify static analysis and run the unit test suite:
```bash
# Verify static code analysis (0 warnings)
flutter analyze

# Execute unit and widget test suite
flutter test
```

### 5. Launch Application
```bash
# Run on connected Android Device / Emulator
flutter run -d android

# Run on iOS Simulator / iPhone
flutter run -d ios

# Run in Chrome (Web Preview)
flutter run -d chrome
```

---

## 📦 Production Release Builds

### Android (Release APK)
To compile a standalone, optimized release APK:
```bash
flutter build apk --release
```
* **Output Path**: `build/app/outputs/flutter-apk/app-release.apk`
* **Application ID**: `com.petrosisay.petroflow`
* **App Label**: `PetroFlow`

### Apple iOS (Release Archive)
To build the iOS archive on a Mac:
```bash
flutter build ipa --release
```
Or open in Xcode for code signing and App Store / TestFlight distribution:
```bash
open ios/Runner.xcworkspace
```

---

## 📡 API Contract Overview

| Method | Endpoint | Description | Auth Required |
| :--- | :--- | :--- | :---: |
| `POST` | `/auth/register` | Create a new user account | No |
| `POST` | `/auth/login` | Authenticate user & retrieve JWT token | No |
| `GET` | `/auth/me` | Fetch authenticated user profile | Yes |
| `PUT` | `/auth/profile` | Update profile details (daily goal, avatar, name) | Yes |
| `PUT` | `/auth/change-password` | Update account password | Yes |
| `GET` | `/todos` | Fetch all user todos with query filters | Yes |
| `POST` | `/todos` | Create a new task | Yes |
| `PUT` | `/todos/:id` | Update an existing task | Yes |
| `PATCH`| `/todos/:id/toggle` | Toggle task completion status | Yes |
| `DELETE`| `/todos/:id` | Delete task by ID | Yes |
| `GET` | `/todos/stats/summary` | Retrieve 7-day completion and category stats | Yes |
| `POST` | `/todos/bulk-delete` | Batch delete selected tasks | Yes |
| `POST` | `/todos/bulk-update` | Batch update status or priority | Yes |

---

## 👨‍💻 Author & Acknowledgements

- **Created by**: [Petros Sisay](https://github.com/petrossisay1646)
- **Web App Counterpart**: [MERN Todo Pro on GitHub](https://github.com/petrossisay1646/mern-todo-pro.git) | [Live Web App](https://mern-todo-pro.vercel.app)

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.
