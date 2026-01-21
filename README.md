# PenguinRead

PenguinRead is an open-source, offline-first speed reading application designed to eliminate subvocalization and eye movement using the Rapid Serial Visual Presentation (RSVP) method. Built with Flutter and Supabase, it is optimized for high-refresh-rate displays to ensure blur-free text rendering at speeds exceeding 500 WPM.

## Project Overview

Current market solutions for speed reading often suffer from feature bloat, subscription fatigue, or privacy concerns. PenguinRead addresses these issues by providing a lightweight, high-performance utility that prioritizes user privacy and rendering stability.

**Core Philosophy:**
- **Performance:** Native 120Hz+ support for fluid text updates.
- **Privacy:** Complete offline functionality with zero data tracking.
- **Accessibility:** Bionic reading modes and high-contrast themes.

## Key Features

- **RSVP Engine:** Customizable words-per-minute (WPM) settings with variable chunk sizes.
- **High Refresh Rate Support:** Forces 120Hz/144Hz modes on supported Android devices for superior motion clarity.
- **Bionic Reading (Anchor Mode):** Highlights initial characters of words to guide visual fixation points.
- **Offline Architecture:** All processing occurs locally; internet connection is optional.
- **Cross-Platform:** Available for Android and Web.
- **Supabase Integration:** Optional cloud sync for user preferences and library management.

## Technology Stack

- **Frontend:** Flutter (Dart)
- **Backend/Auth:** Supabase
- **State Management:** Flutter Bloc
- **Local Storage:** Hive / SharedPreferences

## Installation

### Prerequisites
- Flutter SDK (v3.0 or higher)
- Dart SDK
- Android Studio or VS Code

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/TeamInnerCircle/penguinread.git
   cd penguinread
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Environment**
   Create a launch configuration or pass flags directly for Supabase keys.
   *Note: This project relies on `--dart-define` for API keys security.*

4. **Run the Application**
   ```bash
   flutter run --release
   ```

## Contributing

We welcome contributions from the community. Whether it is a UI improvement, bug fix, or documentation update, your input is valuable.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

---

**Developed by TeamInnerCircle**