# 🐧 PenguinRead

**A minimalist, distraction-free speed reading application built with Flutter & Supabase.**

PenguinRead uses the **RSVP (Rapid Serial Visual Presentation)** method to help users read text up to 3x faster than normal. By flashing words sequentially at a user-defined speed (WPM) and highlighting the **Optimal Recognition Point (ORP)**, it eliminates the time wasted on eye movement (saccades).

![PenguinRead Banner](assets/logo.png) **

## 🚀 Key Features

### 📖 The Engine (RSVP)
* **Precision Timer:** Custom ticker logic handling speeds from **100 to 1000 WPM**.
* **Smart Delays:** Algorithmically pauses on punctuation and long words to mimic natural speech rhythm.
* **Red Focus Point:** Highlights the middle letter of every word to anchor the user's gaze.

### ⚡ Technical Highlights
* **Clean Architecture:** Strict separation of concerns (Domain, Data, Presentation).
* **Supabase Integration:** Fetches dynamic public domain stories from a PostgreSQL backend.
* **Offline-First:** Global **Connectivity Listener** overlays a warning when the internet is lost, preventing crashes.
* **High Performance:** Forces **120Hz refresh rates** on supported Android devices for blur-free high-speed reading.

### 🎨 UI/UX Polish
* **Animations:** Powered by `flutter_animate` for smooth entry transitions and `particle_field` for celebration effects.
* **Theming:** Custom `FlexColorScheme` with Dark/Light mode support.
* **Guest Mode:** Frictionless onboarding allowing users to read immediately without signing up.

## 🛠 Tech Stack

| Category | Technology |
| :--- | :--- |
| **Framework** | Flutter (Web & Mobile) |
| **Language** | Dart |
| **Backend** | Supabase (PostgreSQL + Auth) |
| **State Management** | flutter_bloc (Cubit) |
| **Navigation** | GoRouter |
| **DI** | GetIt + Injectable |
| **UI Libs** | FlexColorScheme, Flutter Form Builder, Animate |

## 🏗 Installation & Run

1.  **Clone the repo:**
    ```bash
    git clone [https://github.com/shiks2/penguin-read.git](https://github.com/shiks2/penguin-read.git)
    ```
2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run:**
    ```bash
    flutter run -d chrome
    ```

## 🤝 Contributing

Contributions are welcome! Please check the [Issues](https://github.com/shiks2/penguin-read/issues) tab to find bugs or feature requests.

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---
*Developed with 💙 by [Shiks2](https://github.com/shiks2)*