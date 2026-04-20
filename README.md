🌎 [English](README.md) | 🇧🇷 [Português](README.pt-br.md)

# RFID Reader App (Smart Stock Project)

<p>
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
</p>

Mobile application developed in Flutter for connecting with an RFID reader 🏷️<br>
Designed to connect to an RFID reader via Bluetooth Low Energy (BLE) to optimize product counting and inventory.

## 💻 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing.

### Prerequisites

  - [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.x or higher)
  - A code editor, such as [VS Code](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
  - An Android device or emulator

### Installation

1.  **Clone the repository:**

    ```bash
    git clone {repository-url-for-smartstock-mobile}
    cd smartstock-mobile
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Configure environment variables:**

    ```bash
    cp .env.example .env
    ```

Edit the `.env` file with the necessary settings.

4.  **Run the application:**

    ```bash
    flutter run
    ```

5.  **Generate routing files:**
    The project uses `auto_route` for navigation. During development, run the following command to generate the required files:

    ```bash
    dart run build_runner build
    ```

## 🛠️ Technologies Used

  - **Framework:** [Flutter](https://flutter.dev/)
  - **State Management:** [Riverpod](https://riverpod.dev/)
  - **Navigation:** [AutoRoute](https://pub.dev/packages/auto_route)
  - **Bluetooth Communication:** [flutter\_blue\_plus](https://pub.dev/packages/flutter_blue_plus)
  - **HTTP Requests:** [http](https://pub.dev/packages/http)
  - **UI Components:** [forui](https://pub.dev/packages/forui)
  - **Dependency Injection:** [get\_it](https://pub.dev/packages/get_it)
  - **Environment Variables:** [flutter\_dotenv](https://pub.dev/packages/flutter_dotenv)
  - **Logging:** [logger](https://pub.dev/packages/logger)

## 🏗️ Project Structure

The project follows a clean architecture, separating responsibilities into different layers:

```
lib/
├── app/
│   ├── bluetooth/      # Bluetooth connection logic and state machine
│   ├── config/         # API settings, dependencies, and environment variables
│   ├── data/           # Repositories and Data Transfer Objects (DTOs)
│   ├── domain/         # Entities and repository abstractions
│   ├── routing/        # Route configuration (AutoRoute)
│   ├── ui/             # Widgets, pages, providers (Riverpod), and themes
│   └── utils/          # Utility classes (e.g., logger)
└── main.dart           # Application entry point
```

## 👀 NOTES

  - To maintain a smoother transition between screens with the same `AppBar` style, I opted to use `AutoTabs` instead of `Navigator.push()`, avoiding the default effect that replaces the entire screen. However, as `AutoTabs` simulates navigation, the native back button ends up closing the app when in internal routes. I solved this using `PopScope` and `SystemNavigator.pop()` on Android. On iOS, this behavior will differ as the method is not supported. Edit: I believe that customizing the screen transition animation would make this unnecessary. However, as these screens currently share behaviors, it worked out perfectly.
  - Credits for the home screen background `stock.png`: [https://www.pexels.com/photo/red-and-white-plastic-containers-on-shelf-3992851/](https://www.pexels.com/photo/red-and-white-plastic-containers-on-shelf-3992851/) + [https://pinetools.com/blur-image](https://pinetools.com/blur-image) with the `Stack Blur` filter and radius 100 + [https://imgonline.tools/pt/darken](https://imgonline.tools/pt/darken) with a darkening factor of 15.
  - Changing the application icon on iOS needs adjustments to become functional. Also, due to the lack of compatible hardware, the iOS version of the application has not been tested.
  - Useful command: `flutter build apk --obfuscate --split-debug-info=/output`

## 📄 License

This project is licensed under the MIT License.
See the [LICENSE](https://www.google.com/search?q=LICENSE) file for more details.

## 👨‍💻 About

This repository contains the implementation of the project's mobile application, developed by **[Ruan Macedo Santos](https://github.com/msruan)**.

Developed for the **Smart Stock** project within the **EmbarcaTech Program**.
