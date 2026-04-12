# 🍽️ Recipe App

A modern and clean Recipe Application built using Flutter.  
The app allows users to create, browse, and manage recipes with a smooth and intuitive UI experience.

---
![App Preview] (https://github.com/khadooja/recipe_app/blob/main/Group%201.png?raw=true)
## ✨ Features

- 📋 Add new recipes with details (title, ingredients, steps, etc.)
- ❤️ Mark/unmark recipes as favorites
- 🔍 Real-time search functionality
- 🕒 Display cooking time, servings, and difficulty level
- 💾 Local database storage using Hive (offline support)
- ⚡ State management using Riverpod
- 🎨 Clean and responsive UI design

---

## 📱 Screens

- Home Screen (Recipe list + search bar)
- Recipe Details Screen (Full recipe view)
- Add Recipe Screen (Form to create recipes)
- Favorites Screen (Saved recipes)

---

## 🧠 Architecture

This project follows a structured and scalable architecture:

- **Data Layer**
  - Models (Recipe model)
  - Local DataSource (Hive)
  - Repository pattern

- **Presentation Layer**
  - Screens (UI pages)
  - Widgets (Reusable components)

- **State Management**
  - Riverpod (StateNotifier)

---

## 🛠️ Tech Stack

- Flutter
- Dart
- Riverpod
- Hive (Local Storage)

---

## 🚀 Getting Started

To run this project locally:

```bash
flutter pub get
flutter run
