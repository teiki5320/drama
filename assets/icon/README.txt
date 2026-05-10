Place a 1024x1024 PNG (no alpha channel) here named `icon.png`.

It will be picked up by `flutter_launcher_icons` (config in pubspec.yaml)
to generate every iOS + Android icon size.

Workflow:
1. Drop your `icon.png` here (overwrite this file too if you want).
2. Run: flutter pub run flutter_launcher_icons
3. Commit the generated files in ios/Runner/Assets.xcassets and
   android/app/src/main/res, then push.
