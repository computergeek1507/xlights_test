# xLights Remote

A mobile/desktop interface to view and edit xLights **Model** and **Controller** information over the network, using the HTTP API built into the xLights desktop app.

Built with [Flutter](https://flutter.dev/), so it runs on Android, Windows, and the web from a single codebase.

## Features

- **Controllers tab** — browse all controllers in your show, view details (address, vendor, model, active state), and upload controller config.
- **Models tab** — browse all models and model groups, view and edit their controller assignment, port, protocol, smart remote, and model chain.
- Bottom tab bar to switch between Controllers and Models.
- Configurable connection (IP address + port) to your xLights instance.
- Shows the connected show folder and xLights version.

## Requirements

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK `^3.5.3`).
- A running copy of the **xLights desktop app** (2023.06 or newer) with its **HTTP API enabled**.
  - In xLights, enable the API under `Preferences → Output` via the **xFade/xSchedule** dropdown. **Port A** is `49913` by default.
- The device running this app must be able to reach the xLights machine over the network.

## Getting Started

1. Install dependencies:

   ```sh
   flutter pub get
   ```

2. Run the app on a connected device, emulator, or the desktop:

   ```sh
   flutter run
   ```

   To target a specific platform:

   ```sh
   flutter run -d windows   # Windows desktop
   flutter run -d chrome    # Web
   flutter run -d <device>  # Android device/emulator
   ```

## Configuration

Tap the **settings** (gear) icon in the top-right of the app to set the connection to your xLights instance:

| Setting | Default       | Description                              |
| ------- | ------------- | ---------------------------------------- |
| IP      | `127.0.0.1`   | IP address of the machine running xLights |
| Port    | `49913`       | Port of the xLights HTTP API             |

Settings are persisted on-device via `shared_preferences`.

## Project Structure

```
lib/
  main.dart            App entry point and routes
  startscreen.dart     Home screen with Controllers/Models bottom tabs
  settings.dart        IP/port configuration screen
  xlightsserver.dart   HTTP client for the xLights API (all server calls)
  controller*.dart     Controller list/info/wiring views and models
  model*.dart          Model list/info/group views and models
```

## Building

```sh
flutter build apk        # Android
flutter build windows    # Windows
flutter build web        # Web
```

## License

See [LICENSE](LICENSE).
