# Android Testing & Emulator Quickstart

This project includes a basic **integration_test** to verify the app launches on an Android emulator.

## Prereqs
- Android Studio + Android SDK + an emulator (API 30+ recommended).
- Flutter 3.24+ / Dart 3.5+.

## 1) Install deps
```
flutter clean
flutter pub get
```

## 2) Start an emulator
Open Android Studio > Device Manager > create a Pixel device (API 30+), then click **Run** to boot it.

Alternatively via CLI:
```
# List emulators
$ANDROID_HOME/emulator/emulator -list-avds

# Start one (replace Pixel_5_API_34 with your avd name)
$ANDROID_HOME/emulator/emulator -avd Pixel_5_API_34
```

## 3) Run the integration test on Android
```
flutter test integration_test/app_test.dart -d android
```

If you prefer a full instrumentation run (recommended for CI):
```
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d android
```

> Note: location permissions are declared in `android/app/src/main/AndroidManifest.xml` (and a debug manifest is added if missing) so the app can access geolocation during tests.
