<div align="center">
<img width="1536" height="1024" alt="Codex Image Aug 23, 2026, 01_30_31 AM" src="https://github.com/user-attachments/assets/6225d7db-e148-47cd-9002-3beefd073bd0" />

# Personal Tracker ✨

**A modern, lightweight, and intuitive personal productivity app built with Flutter.**

Organize daily tasks, monitor productivity, review completion history, and stay motivated — all through a clean, customizable interface.

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-3DDC84?style=for-the-badge&logo=android&logoColor=white)](#-supported-platforms)

[![GitHub release](https://img.shields.io/github/v/release/bwnbits/personal_tracker?style=flat-square&color=blue)](https://github.com/bwnbits/personal_tracker/releases)
[![GitHub stars](https://img.shields.io/github/stars/bwnbits/personal_tracker?style=flat-square)](https://github.com/bwnbits/personal_tracker/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/bwnbits/personal_tracker?style=flat-square)](https://github.com/bwnbits/personal_tracker/issues)
[![GitHub last commit](https://img.shields.io/github/last-commit/bwnbits/personal_tracker?style=flat-square)](https://github.com/bwnbits/personal_tracker/commits)

[Features](#-features) •
[Getting Started](#-getting-started) •
[Installation](#-installation) •
[Contributing](#-contributing)

</div>

---

## 📑 Table of Contents

- [Features](#-features)
- [Technology Stack](#️-technology-stack)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Installation](#-installation)
- [Releases & Downloads](#-releases--downloads)
- [Supported Platforms](#-supported-platforms)
- [Roadmap](#️-roadmap)
- [FAQ](#-faq)
- [Further Resources](#-further-resources)
- [Contributing](#-contributing)
- [License](#-license)

---

## 🚀 Features

### 📋 Task Management
- **Personalized Dashboard** — View your daily motivation and active tasks at a glance.
- **Task Management** — Create, complete, and manage tasks through a clean, intuitive interface.
- **Task Persistence** — Tasks are automatically saved locally and remain available between sessions.
- **Completion History** — Review previously completed tasks and monitor your productivity over time.

### 📊 Analytics
- **Interactive Charts** — Visualize task completion and productivity trends with dynamic charts.
- **Multiple Chart Types** — Switch between different visualization styles to analyze your data.
- **Flexible Timeframes** — Review productivity across selectable time periods.
- **Detailed Statistics** — Combine visual analytics with numerical task breakdowns.

### 💡 Motivation
- **Daily Motivational Quotes** — Start your day with a fresh source of motivation.
- **Focused Quote View** — Open quotes in a dedicated view with a subtle blurred backdrop effect.
- **Favorite Quotes** — Save quotes you want to revisit later.
- **Reorderable Favorites** — Organize saved quotes using drag-and-drop.

### 🎨 Personalization
- **Custom Themes** — Choose from multiple color palettes.
- **System Theme Support** — Automatically adapt to your device's light or dark appearance.
- **Responsive UI** — Designed to provide a consistent experience across supported screen sizes.

### 💾 Local Data Storage
Your productivity data is stored locally on your device, including:
- Tasks
- Task completion history
- Favorite quotes
- Theme preferences
- Application settings

No account or separate backend is required.

---

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| **[Flutter](https://flutter.dev/) & [Dart](https://dart.dev/)** | Cross-platform application development |
| **[Provider](https://pub.dev/packages/provider)** | State management for themes and preferences |
| **[Shared Preferences](https://pub.dev/packages/shared_preferences)** | Local key-value storage and persistence |
| **[FL Chart](https://pub.dev/packages/fl_chart)** | Charts and data visualization |
| **[HTTP](https://pub.dev/packages/http)** | Fetching motivational quotes from remote APIs |
| **[URL Launcher](https://pub.dev/packages/url_launcher)** | Opening external links from the application |
| **[Flutter Launcher Icons](https://pub.dev/packages/flutter_launcher_icons)** | Generating native application icons |

---

## 📂 Project Structure

```
personal_tracker/
├── android/                 # Android platform files
├── ios/                     # iOS platform files
├── lib/
│   ├── main.dart            # App entry point
│   ├── models/               # Data models
│   ├── providers/            # State management (Provider)
│   ├── screens/               # App screens (Dashboard, Analytics, Settings)
│   ├── widgets/               # Reusable UI components
│   └── utils/                # Helpers & constants
├── assets/                   # Images, fonts, and icons
├── test/                     # Unit & widget tests
├── pubspec.yaml               # Project dependencies
└── README.md
```

---

## 🏁 Getting Started

### Prerequisites

Before running the project, ensure you have the following installed:

- **Flutter SDK** — latest stable release
- **Dart SDK** — included with Flutter
- **IDE** — Android Studio or VS Code with the Flutter and Dart extensions
- **Android** — Android SDK and an emulator or physical Android device
- **iOS** — Xcode and CocoaPods (macOS only)

Verify your Flutter environment with:

```bash
flutter doctor
```

Resolve any issues reported before proceeding.

### Platform Setup

<details>
<summary><strong>macOS</strong></summary>

1. Install the latest version of Xcode from the Mac App Store.
2. Install CocoaPods if required:

   ```bash
   sudo gem install cocoapods
   ```

3. Install Android Studio and configure the Android SDK.
4. Verify your Flutter installation:

   ```bash
   flutter doctor
   ```

5. Resolve any issues reported by `flutter doctor` before running the application.

</details>

<details>
<summary><strong>Windows</strong></summary>

1. Install Git.
2. Install Android Studio.
3. Configure the required Android SDK packages.
4. Create an Android Virtual Device (AVD) through Android Studio's Device Manager.
5. Verify your Flutter installation:

   ```powershell
   flutter doctor
   ```

</details>

---

## 📥 Installation

**1. Clone the repository**

```bash
git clone https://github.com/bwnbits/personal_tracker.git
```

**2. Navigate to the project**

```bash
cd personal_tracker
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Run the application**

```bash
flutter run
```

> **Note:** If Flutter cannot locate the Dart SDK, check your Flutter SDK path and IDE configuration.

---

## 📦 Releases & Downloads

Stable builds and release tags are available on the project's [GitHub Releases](https://github.com/bwnbits/personal_tracker/releases) page.

**Latest release:** [v2.3.2](https://github.com/bwnbits/personal_tracker/releases)

Pre-built APK files can be downloaded from the assets section of the corresponding GitHub release.

---

## 📱 Supported Platforms

The project is designed for cross-platform Flutter development and can be configured for:

- ✅ Android
- ✅ iOS
- ➕ Other Flutter-supported platforms, depending on project configuration

---

## 🗺️ Roadmap

- [x] Task creation, completion & history
- [x] Interactive analytics with `fl_chart`
- [x] Custom themes & system theme support
- [x] Favorite quotes with drag-and-drop reordering
- [ ] Cloud sync across devices
- [ ] Widget/home-screen support
- [ ] Push notifications & reminders
- [ ] Desktop & web support

Have an idea? [Open an issue](https://github.com/bwnbits/personal_tracker/issues) or start a discussion!

---

## ❓ FAQ

<details>
<summary><strong>Does Personal Tracker require an internet connection?</strong></summary>
<br>
No — all core features (tasks, history, themes, favorites) work fully offline. An internet connection is only used to fetch new motivational quotes.
</details>

<details>
<summary><strong>Is my data stored anywhere online?</strong></summary>
<br>
No. All data is stored locally on your device using <code>shared_preferences</code>. No account or backend is required.
</details>

<details>
<summary><strong>Which platforms are officially supported?</strong></summary>
<br>
Android and iOS are officially supported. Other Flutter-supported platforms may work depending on configuration.
</details>

<details>
<summary><strong>How do I report a bug or request a feature?</strong></summary>
<br>
Please open an issue on the <a href="https://github.com/bwnbits/personal_tracker/issues">GitHub Issues</a> page with as much detail as possible.
</details>

---

## 📚 Further Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Write Your First Flutter App](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart Documentation](https://dart.dev/guides)

---

## 🤝 Contributing

Contributions are welcome! If you'd like to help improve Personal Tracker:

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m 'Add your feature'`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a Pull Request.

Please open an issue first to discuss significant changes.

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

If you find this project useful, consider giving it a ⭐ on GitHub!

**[⬆ Back to Top](#personal-tracker-)**

Made with ❤️ using Flutter

</div>
