#!/bin/sh
set -e

# Version Flutter ÉPINGLÉE (reproductibilité). « stable » suivait la dernière
# release et une régression amont cassait l'intégration iOS des plugins sans
# aucun changement de code. On fige la version du plancher pubspec (3.27),
# celle avec laquelle le projet a été développé. Bump manuel volontaire.
FLUTTER_VERSION="3.27.4"

echo "=== Install Flutter SDK ($FLUTTER_VERSION) ==="
git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$HOME/flutter"
export PATH="$HOME/flutter/bin:$PATH"

echo "=== Precache iOS artifacts ==="
flutter precache --ios

echo "=== flutter pub get ==="
cd "$CI_PRIMARY_REPOSITORY_PATH"
flutter pub get

echo "=== Generate launcher icons ==="
dart run flutter_launcher_icons

echo "=== pod install ==="
cd "$CI_PRIMARY_REPOSITORY_PATH/ios"
pod install --repo-update
