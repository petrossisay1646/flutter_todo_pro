# 📱 Flutter Todo Pro — Mobile Application

A modern, full-featured cross-platform mobile application built with **Flutter** & **Material 3**, connected to the **MERN Todo Pro REST API** backend and MongoDB database.

---

## 🌐 Full Stack Architecture

```text
┌──────────────────────────────────────────────────────────┐
│                MERN TODO PRO ECOSYSTEM                   │
├────────────────────────────┬─────────────────────────────┤
│   React Web Frontend       │   Flutter Mobile App        │
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

- 🔐 **Cross-Platform Authentication**: Log in or register using the same credentials as the web application. Persistent JWT session storage.
- 📋 **Task Catalog (List View)**: Smart sorting (pinned tasks and due dates first), hashtag filtering, inline subtask checklist previews, and swipe-to-delete.
- 📊 **Kanban Board**: Mobile-friendly board with swipeable columns for *To Do*, *In Progress*, and *Completed* stages.
- 🍅 **Focus Mode (Pomodoro Timer)**: 25-minute focus intervals, short/long breaks, session counter, and direct task linking with one-tap completion.
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
# Run on connected Android or iOS device
flutter run
```

---

## ⚙️ Backend API Configuration

By default, the mobile app connects to the live production Render API:
`https://mern-todo-pro-api.onrender.com/api`

To test against your local development server:
1. Open the app → Go to **Profile** → **Backend API Endpoint**.
2. Select **Android (10.0.2.2)** for Android Emulator or **Localhost** for iOS Simulator.

---

## 📄 License
MIT License. Built by Petros Sisay.
