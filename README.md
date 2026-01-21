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
- **Anchor Mode (Bionic Style):** Algorithmic highlighting of initial characters to guide visual fixation points and reduce eye strain.
- **Local PDF Import:** Extract and read text directly from PDF documents without server-side processing.
- **Offline Architecture:** All processing occurs locally; internet connection is optional.
- **Cross-Platform:** Available for Android and Web.
- **Supabase Integration:** Optional cloud sync for user preferences and library management.

## Technology Stack

- **Frontend:** Flutter (Dart)
- **Backend/Auth:** Supabase
- **State Management:** Flutter Bloc
- **Local Storage:** Hive / SharedPreferences
- **PDF Engine:** Syncfusion Flutter PDF

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

## Call for Contributors

TeamInnerCircle is dedicated to building high-quality, open-source software. As we approach our v1.0 launch, we are inviting designers and developers to collaborate on the next phase of PenguinRead.

**Current Open Roles (Volunteer):**

* **Visual Identity Lead:** We are seeking a contributor to design a professional logo and brand assets to replace existing placeholders.
* **UI/UX Specialist:** We are looking for input on improving accessibility and reading ergonomics for neurodivergent users (ADHD/Dyslexia).

**Why Contribute?**

* **Attribution:** All contributors receive full credit in the repository and the application's "About" page.
* **Portfolio Impact:** Your designs will be featured in our upcoming public launch on Product Hunt.
* **Open Source Growth:** Gain experience shipping a production-grade Flutter application with a real user base.

**How to Join:**
If you are interested in contributing, please open a GitHub Issue titled **"Design Proposal"** or start a discussion in this repository.

## License

Distributed under the MIT License. See `LICENSE` for more information.

---

**Developed by TeamInnerCircle**