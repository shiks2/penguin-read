# 🐧 PenguinRead

**A minimalist, distraction-free speed reading application built with Flutter & Supabase.**

PenguinRead uses the **RSVP (Rapid Serial Visual Presentation)** method to help users read text up to 3x faster than normal. By flashing words sequentially at a user-defined speed (WPM), it eliminates the time spent on eye movement (saccades).

## 🚀 Features

* **RSVP Engine:** Precise WPM control (100-1000 WPM) with "Red Focus Point" (ORP) highlighting.
* **Natural Rhythm:** Smart delays for punctuation and long words to mimic natural speech patterns.
* **Dynamic Library:** Fetches public domain stories dynamically from **Supabase**.
* **Guest Mode:** Frictionless onboarding allowing users to read without an account.
* **Customizable:** Adjustable font sizes, themes (Dark/Light), and speeds.

## 🛠 Tech Stack

* **Framework:** Flutter (Web)
* **Language:** Dart
* **Backend:** Supabase (PostgreSQL + Auth)
* **State Management:** flutter_bloc (Cubit)
* **Architecture:** Clean Architecture (Domain-Driven Design)
* **Routing:** GoRouter
* **UI:** FlexColorScheme, Flutter Form Builder

## 📸 Screenshots

*(Add a screenshot here later)*

## 🔧 Installation & Run

1.  **Clone the repo:**
    ```bash
    git clone [https://github.com/YOUR_USERNAME/PenguinRead.git](https://github.com/YOUR_USERNAME/PenguinRead.git)
    ```
2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run:**
    ```bash
    flutter run -d chrome
    ```