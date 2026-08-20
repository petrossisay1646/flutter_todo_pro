# 📱 PetroFlow — Mobile Productivity Suite

**PetroFlow** is a modern, production-grade cross-platform mobile task management application for **Android** (phones & tablets) and **Apple iOS** (iPhone & iPad), powered by Flutter & Material 3, and connected to the **MERN Todo Pro REST API** backend and MongoDB Atlas database.

---

## 🎨 Brand & Identity

- **Application Name**: PetroFlow
- **Package / Application ID (Android)**: `com.petrosisay.petroflow`
- **Bundle Identifier (iOS)**: `com.petrosisay.petroflow`
- **Design Philosophy**: Minimalist, high-contrast Material 3 interface with dynamic check-and-flow iconography, dark and light mode themes, and responsive phone/tablet support.

---

## 🌐 Full Stack Architecture

```text
┌──────────────────────────────────────────────────────────┐
│                 PETROFLOW / MERN ECOSYSTEM               │
├────────────────────────────┬─────────────────────────────┤
│   React Web Frontend       │   PetroFlow Mobile App      │
│   (mern-todo-pro)          │   (flutter_todo_pro)        │
│   https://...vercel.app    │   Android / iOS Mobile      │
└─────────────┬──────────────┴──────────────┬──────────────┘
              │                             │
              └──────────────┬──────────────┘
                             │ HTTPS / REST API (JWT)
                             ▼
              ┌─────────────────────────────┐
              │   Node.js / Express Backend │
              │   https://...onrender.com   │
              └──────────────┬──────────────┘
                             │
                             ▼
              ┌─────────────────────────────┐
              │    MongoDB Atlas Database   │
              │    Shared Users & Todos     │
              └─────────────────────────────┘
```

---

## ✨ Features

- 📱 **Cross-Platform**: Tailored layouts and native behavior for Android phones/tablets and iPhone/iPad.
- 🎨 **Custom App Icon**: High-resolution, vector-drawn launcher icons across all Android mipmaps and iOS AppIcon sets.
- 🔐 **Cross-Platform Authentication**: Shared user database with web application via JWT tokens.
- 📋 **Task Catalog (List View)**: Smart sorting (pinned tasks & due dates first), hashtag filtering, subtask checklists, and swipe-to-delete.
- 📊 **Kanban Board**: Mobile-friendly board with swipeable columns for *To Do*, *In Progress*, and *Completed* stages.
- 🍅 **Focus Mode (Pomodoro Timer)**: 25-minute focus intervals, short/long breaks, session counter, and direct task binding with one-tap completion.
- 📈 **Analytics & Streaks**: 7-day completion trend bar chart, daily target goal circular progress ring, and consecutive day streak tracker (🔥).
- 📦 **Bulk Action Mode**: Select multiple tasks for batch complete, batch delete, or mass priority updates.
- 🎨 **Settings & Customization**: Avatar color palette, daily goal target, theme selector (Light, Dark, System), password management, and custom API URL switcher.
- 💾 **Offline Caching**: Automatically saves tasks and stats locally for offline viewing.

---

## 🛠️ Mobile Tech Stack

- **Framework**: Flutter 3.10+ / Dart 3.0+
- **Design System**: Material 3 (Light & Dark mode)
- **State Management**: Flutter Riverpod
- **Networking**: Dio (with JWT Bearer interceptor & timeout handling)
- **Local Storage**: SharedPreferences / Flutter Secure Storage
- **Typography**: Google Fonts (Inter)

---

## 🚀 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed.
- Android Studio / Xcode / VS Code.

### 2. Clone the repository
```bash
git clone https://github.com/petrossisay1646/flutter_todo_pro.git
cd flutter_todo_pro
```

### 3. Install dependencies
```bash
flutter pub get
```

### 4. Run on Device / Emulator
```bash
# Android Device / Emulator
flutter run -d android

# iOS Simulator / Device
flutter run -d ios
```

---

## 📄 License
MIT License. Built by Petros Sisay.
