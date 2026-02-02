# Actify - Modern Todo List App

A feature-rich todo list application built with Flutter and Firebase, showcasing modern mobile development practices and cloud integration.

## 🚀 Project Overview

Actify is a powerful task management application designed for seamless productivity. This project demonstrates expertise in:
- Full-stack mobile application development
- Firebase integration (Authentication & Firestore)
- Modern Flutter development patterns
- Real-time data synchronization
- Cross-platform mobile development

## ✨ Features

- **Task Management**: Create, organize, and track multiple task lists
- **Real-time Sync**: All tasks sync instantly across devices using Firebase Firestore
- **Anonymous Authentication**: Secure user sessions with Firebase Auth
- **Task Completion Tracking**: Mark tasks as done and view them in a dedicated "Done" section
- **Color-coded Lists**: Visually organize tasks with custom colors
- **Smooth Animations**: Polished UI transitions and interactions
- **Offline Support**: Works seamlessly even without internet connection

## 🛠️ Technical Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **Backend**: Firebase
  - Firebase Authentication (Anonymous sign-in)
  - Cloud Firestore (Real-time database)
- **State Management**: StatefulWidget with StreamBuilder
- **UI Components**: Material Design with custom styling

## 📱 Screenshots / Video
<img width="500" height="1200" alt="Screenshot_20260202_022402" src="https://github.com/user-attachments/assets/d131e507-6ca3-4862-982d-bab857416890" />
<img width="500" height="1200" alt="Screenshot_20260202_022506" src="https://github.com/user-attachments/assets/7ca07324-8960-484d-a68d-5a714d2fddaa" />
<img width="500" height="1200" alt="Screenshot_20260202_022321" src="https://github.com/user-attachments/assets/582b4ba0-bac4-4bc6-89c8-965fb5b44e80" />


## 🔧 Installation & Setup

### Prerequisites
- Flutter SDK (3.0 or higher)
- Android Studio / VS Code
- Firebase account

### Steps

1. Clone the repository
```bash
git clone https://github.com/TJseyon/actify-todo-app.git
cd actify-todo-app
```

2. Install dependencies
```bash
flutter pub get
```

3. Firebase Setup
   - Create a Firebase project at https://console.firebase.google.com
   - Add an Android/iOS app to your Firebase project
   - Download `google-services.json` (Android) and place it in `android/app/`
   - Enable Anonymous Authentication in Firebase Console
   - Enable Cloud Firestore and set up security rules

4. Run the app
```bash
flutter run
```

## 📂 Project Structure

```
lib/
├── main.dart              # App entry point with Firebase initialization
├── model/
│   └── element.dart       # Task data model
└── ui/
    ├── page_task.dart     # Active tasks view
    ├── page_done.dart     # Completed tasks view
    ├── page_detail.dart   # Task detail and editing
    ├── page_addlist.dart  # New list creation
    └── page_settings.dart # App settings
```

## 🎯 Key Features & Implementation

- **Real-time Synchronization**: Implemented live data sync using Firebase StreamBuilder for instant updates across devices
- **Secure Authentication**: Built anonymous authentication flow with Firebase Auth for user privacy
- **Efficient Database Design**: Architected NoSQL schema in Firestore for optimal task storage and retrieval
- **Responsive UI**: Crafted smooth animations and transitions using Flutter's animation framework
- **State Management**: Utilized StreamBuilder pattern for reactive UI updates
- **Error Handling**: Implemented comprehensive error handling and offline support

## 📄 Firebase Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 🚦 Future Enhancements

- [ ] Email/Password authentication
- [ ] Task sharing and collaboration
- [ ] Push notifications for reminders
- [ ] Task categories and tags
- [ ] Search and filter functionality
- [ ] Data export/import
- [ ] Dark mode support
- [ ] iOS version

## 👨‍💻 Author

**Seyon TJ**
- GitHub: [@TJseyon](https://github.com/TJseyon)

