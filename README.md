Name: Reina G. Tamiao
C&Y: BSINTE 2A

# Field Notes

A standalone Flutter app (no FlutterFlow needed) for recording outdoor observations.

Features: create, edit and delete notes, attach a photo (gallery or camera),
search, and local storage that survives app restarts.

## Setup

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. In this folder, generate the platform folders (android, ios, web...):

       flutter create . --project-name field_notes

   This keeps `lib/` and `pubspec.yaml` as they are.
3. Install packages and run:

       flutter pub get
       flutter run

## Permissions for photos

- **Android:** no extra setup for the gallery. For the camera, `image_picker`
  works without edits on recent versions.
- **iOS:** add to `ios/Runner/Info.plist`:

      <key>NSPhotoLibraryUsageDescription</key>
      <string>Attach photos to your notes.</string>
      <key>NSCameraUsageDescription</key>
      <string>Take photos for your notes.</string>

## Build for free

    flutter build apk --release      # Android APK
    flutter build web                # Web, output in build/web
    flutter build windows            # Windows desktop (on Windows)

Output APK: `build/app/outputs/flutter-apk/app-release.apk`
