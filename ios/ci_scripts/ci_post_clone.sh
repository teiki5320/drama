#!/bin/sh
set -e

echo "=== Install Flutter SDK ==="
git clone --depth 1 --branch stable https://github.com/flutter/flutter.git $HOME/flutter
export PATH="$HOME/flutter/bin:$PATH"

echo "=== Precache iOS artifacts ==="
flutter precache --ios

echo "=== flutter pub get ==="
cd $CI_PRIMARY_REPOSITORY_PATH
flutter pub get

echo "=== Generate launcher icons ==="
dart run flutter_launcher_icons

echo "=== pod install ==="
cd $CI_PRIMARY_REPOSITORY_PATH/ios
pod install
