# Name: Reina G. Tamiao

# C&Y: BSINTE 2A

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

# Field Notes: How to Get It Running on Your Phone

Hi! This guide takes you all the way from a computer with nothing installed to the app running on your Android phone. Everything here is free. It's fine if it takes a while, because most of the time is just waiting for downloads.

If something goes wrong, don't worry. Almost every error has a simple fix, and the Troubleshooting section at the bottom covers the ones you're most likely to run into.

**What is Field Notes?**
It's a little app for jotting down things you spot outdoors. You can add a note with a photo, edit it later, delete it, and search through your notes. Everything stays saved on your phone.

---

## What you'll need

- A Windows PC with about 15 GB of free space on the C: drive (the build needs at least 5 GB, and a bit extra saves headaches)
- A decent internet connection, since the setup downloads a few gigabytes
- An Android phone to put the app on
- About an hour for the first time

---

## Step 1: Install everything

Do all the installing first, then the setup is much smoother. There are three things to get.

### 1a. Git (check first, you may already have it)

Open PowerShell (press the Windows key, type **PowerShell**, press Enter) and type:

    git --version

If it prints a version number, you already have it, so skip ahead. If it says the command isn't recognized, download **Git for Windows** from https://git-scm.com/download/win, run the installer, and click Next through the defaults.

### 1b. Flutter

Flutter is the tool that turns this code into a real app.

1. Download the Flutter SDK for Windows (a zip file) from https://docs.flutter.dev/get-started/install/windows
2. Make a new folder called `C:\src`. In File Explorer, open **This PC**, then **Local Disk (C:)**, right-click an empty spot, and choose **New**, then **Folder**.
3. Extract the zip into `C:\src`. When you're done, this file should exist:

       C:\src\flutter\bin\flutter.bat

   If you see `flutter\flutter\bin` instead, move the inner folder up one level. And please don't use `C:\Program Files`, because Flutter doesn't get along with it.

### 1c. Android Studio

This brings the Android tools that build the phone app.

1. Download **Android Studio** from https://developer.android.com/studio and run the installer.
2. Open it. When the setup wizard appears, pick the **Standard** setup and let it download everything. This can take a while, so it's a good moment for a snack.
3. When it's finished, you can leave Android Studio open or close it.

### 1d. Your project files

1. Create a folder called `C:\projects`.
2. Extract `field_notes.zip` into it. You should end up with:

       C:\projects\field_notes\pubspec.yaml
       C:\projects\field_notes\lib\

Keeping it somewhere simple like this saves you from typing quotes around every path. (Documents works too, you just need quotes whenever a path has a space in it, like `"C:\Users\your name\Documents\field_notes"`.)

---

## Step 2: Let Windows find Flutter

1. Press the Windows key and type **Edit environment variables for your account**.
2. Under **User variables**, pick **Path** and click **Edit**, then **New**.
3. Type `C:\src\flutter\bin` and click OK on every window.
4. Close every PowerShell window and open a fresh one.
5. Check that it worked:

       flutter --version

   The first run takes a few minutes while Flutter sets itself up. That's normal.

If you'd rather not change your settings, you can type this at the start of every new PowerShell window instead:

    $env:Path += ";C:\src\flutter\bin"

---

## Step 3: Add the missing Android pieces

The standard Android Studio setup leaves out a couple of things this build needs.

1. In Android Studio, open the **SDK Manager**. On the welcome screen, click **More Actions**, then **SDK Manager**. If a project is already open, go to **Tools**, then **SDK Manager**.
2. Click the **SDK Tools** tab and tick **Show Package Details** at the bottom right.
3. Install these two:
   - **Android SDK Command-line Tools (latest)**
   - **NDK (Side by side)**, version **28.2.13676358**. If your build later asks for a different version, install whichever one the error message names.
4. Click **Apply**, then **OK**, and let the downloads finish.
5. Back in PowerShell, tell Flutter where the Android SDK is:

       flutter config --android-sdk "$env:LOCALAPPDATA\Android\Sdk"

6. Accept the licenses:

       flutter doctor --android-licenses

   Newer tools may tell you this step isn't needed anymore. That's fine, just carry on.

7. Run a health check:

       flutter doctor

   What you want is a checkmark next to **Android toolchain**. Red marks next to Visual Studio or iOS can be ignored, since you're only building for Android.

---

## Step 4: Turn on Developer Mode

Windows needs this switched on so Flutter can set up its plugins.

1. Run:

       start ms-settings:developers

2. Turn **Developer Mode** on and confirm.
3. Close PowerShell and open a new window.

If your PC won't let you turn it on, open PowerShell with **Run as administrator** for the steps below. That works too.

---

## Step 5: Get the project ready

Open PowerShell and go into your project folder:

    cd C:\projects\field_notes
    dir

Take a second to look at what `dir` shows. You should see `pubspec.yaml` and a `lib` folder. If you get an error that the path doesn't exist, stop here and double-check where you extracted the zip. This matters because the next command creates a lot of files in whatever folder you're in, and you really don't want those landing in your user folder by accident.

Once it looks right:

    flutter create . --project-name field_notes
    flutter pub get

Want to see the app before building it? You can try it in your browser:

    flutter run -d chrome

When you're done looking, press `q` in the terminal to stop it.

---

## Step 6: Build the app

1. Check you have at least 5 GB free on C:. If you're low, empty the Recycle Bin or run Disk Cleanup.

2. Start the build:

       flutter build apk --release

   The first time takes around 5 to 15 minutes. Go make a drink, it's fine.

3. When it says it's done, your app file is here:

       build\app\outputs\flutter-apk\app-release.apk

   To open that folder quickly:

       explorer build\app\outputs\flutter-apk

---

## Step 7: Put it on your phone

1. Copy `app-release.apk` to your phone. A USB cable works, or you can upload it to Google Drive or send it to yourself on Telegram.
2. Open the file on your phone.
3. If Android says it's blocked, tap **Settings** and allow installs from that app (like Files or Chrome). Then go back and tap **Install**.
4. If Play Protect gives you a warning, tap **Install anyway**. That's normal for apps you built yourself.
5. Open **Field Notes** and start writing. When you add a photo, Android will ask for permission to use your camera or gallery, so say yes.

One thing to know: your notes live only on the phone. If you uninstall the app, they go with it.

---

## Troubleshooting

**"flutter is not recognized"**
Windows can't find Flutter in this window. Either type `$env:Path += ";C:\src\flutter\bin"`, or go back to Step 2 and open a new window afterwards.

**"Cannot find path" when you run `cd`**
You're not in the folder you think you are. Check where you extracted the project, and use quotes if the path has spaces. Don't run `flutter create .` until `dir` shows `pubspec.yaml`.

**"No Android SDK found"**
Open Android Studio once so it finishes its setup, then run the `flutter config --android-sdk` command from Step 3.

**"Android sdkmanager not found"**
You're missing the command-line tools. Install **Android SDK Command-line Tools (latest)** in the SDK Manager (Step 3).

**"NDK not found" or "did not install NDK"**
In the SDK Manager, go to **SDK Tools**, tick **Show Package Details**, and install the exact NDK version the error names. A small mix-up to watch for: something like 35.0.1 is Build-Tools, not the NDK.

**"There is not enough space on the disk"**
Free up at least 5 GB on C:, then run `flutter clean` and try the build again.

**"Cannot lock file hash cache" or "Gradle could not start"**
The Gradle cache got damaged, usually because the disk filled up mid-build. This fixes it:

    cd android
    .\gradlew.bat --stop
    cd ..
    Remove-Item -Recurse -Force android\.gradle, build -ErrorAction SilentlyContinue
    flutter clean
    flutter pub get
    flutter build apk --release

If it still won't budge, restart your computer and try once more.

**"Building with plugins requires symlink support"**
Turn on Developer Mode (Step 4), open a new PowerShell window, and build again. Sometimes this message shows up and the build finishes fine anyway, so check the last line before you worry.

**Random Flutter files showing up in your user folder**
That happens when `flutter create .` runs in the wrong place. It's harmless, just tidy it up by deleting only what Flutter made there: android, ios, lib, linux, macos, test, web, windows, build, .dart_tool, .idea, pubspec.yaml, pubspec.lock, analysis_options.yaml, field_notes.iml, .metadata, .gitignore, and README.md.

---

## The short version

Once everything is installed, this is all you need next time:

    $env:Path += ";C:\src\flutter\bin"
    cd C:\projects\field_notes
    flutter pub get
    flutter build apk --release

## Other ways to build

    flutter build web        # a web version, in build\web
    flutter build windows    # a Windows desktop app (needs Visual Studio with C++ tools)

iPhones are the odd one out. You can't build an iPhone app on Windows. You'd need a Mac with Xcode, or a cloud build service.

Good luck, and enjoy your notes!


