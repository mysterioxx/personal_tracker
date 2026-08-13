# personal_tracker ✨

A simple, beautiful, and intuitive personal productivity tracker built with Flutter. The app helps you stay on top of daily goals, review task history, track progress, and find daily motivation through a modern, responsive interface.

---

## 🚀 Features

- **Personalized Dashboard:** A minimalist dashboard featuring a daily motivational quote and a to-do list. Tapping the quote opens it in a focused pop-up with a blurred backdrop effect.
- **Advanced To-Do List:** Create, complete, and manage tasks in a clean vertical list. Tasks are automatically saved, with a dedicated completion history.
- **Interactive Analytics:** Visualize task completion progress using dynamic `fl_chart` graphs, numerical breakdowns, and selectable timeframes.
- **Customizable Themes:** Choose from multiple custom color palettes and a dynamic system theme from the Settings page.
- **Reorderable Favorites:** Save favorite quotes and reorder them using an intuitive drag-and-drop interface.
- **Local Data Persistence:** Tasks, favorite quotes, preferences, and settings are stored locally on the device.

---

## 🛠️ Technology Stack

- **[Flutter](https://flutter.dev/) & [Dart](https://dart.dev/):** Cross-platform mobile application development.
- **[`provider`](https://pub.dev/packages/provider):** State management for themes and preferences.
- **[`shared_preferences`](https://pub.dev/packages/shared_preferences):** Local key-value storage and persistence.
- **[`fl_chart`](https://pub.dev/packages/fl_chart):** Responsive charts and data visualization.
- **[`http`](https://pub.dev/packages/http):** Fetching motivational quotes from remote APIs.
- **[`url_launcher`](https://pub.dev/packages/url_launcher):** Opening external links from the application.
- **[`flutter_launcher_icons`](https://pub.dev/packages/flutter_launcher_icons):** Generating native application icons.

---

## 💻 Getting Started

Follow the steps below to run the project locally.

### Prerequisites

Before getting started, make sure you have:

- **Flutter SDK:** The latest stable Flutter SDK.
- **IDE:** Android Studio or VS Code with Flutter and Dart extensions.
- **Android:** Android SDK and an emulator or physical Android device.
- **iOS:** Xcode and CocoaPods on macOS.

---

## ⚙️ Flutter Setup

### macOS

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

### Windows

1. Install Git.
2. Install Android Studio.
3. Configure the required Android SDK packages.
4. Create an Android Virtual Device (AVD) through Android Studio's Device Manager.
5. Verify your Flutter installation:

```powershell
flutter doctor
```

---

## 📥 Installation

### 1. Clone the repository

```bash
git clone https://github.com/bwnbits/personal_tracker.git
```

### 2. Navigate to the project

```bash
cd personal_tracker
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the application

```bash
flutter run
```

> **Note:** If Flutter cannot locate the Dart SDK, check your Flutter SDK path and IDE configuration.

---

## 📦 Releases & Downloads

Stable builds and release tags are available on the project's GitHub Releases page.

**Latest release:** [v2.3.2](https://github.com/bwnbits/personal_tracker/releases)

Pre-built APK files can be downloaded from the assets section of the corresponding GitHub release.

---

## 📱 Supported Platforms

The project is designed for cross-platform Flutter development and can be configured for:

- Android
- iOS
- Other Flutter-supported platforms, depending on project configuration

---

## 📚 Further Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter Cookbook](https://docs.flutter.dev/cookbook)
- [Dart Documentation](https://dart.dev/guides)

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
