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

# CFBundleVersion = numéro de build Xcode Cloud (toujours croissant, jamais
# en conflit avec un upload TestFlight précédent). `flutter pub get` écrit
# FLUTTER_BUILD_NUMBER depuis pubspec ; on le remplace par $CI_BUILD_NUMBER.
if [ -n "$CI_BUILD_NUMBER" ]; then
  echo "=== CFBundleVersion = $CI_BUILD_NUMBER (build Xcode Cloud) ==="
  /usr/bin/sed -i '' "s/^FLUTTER_BUILD_NUMBER=.*/FLUTTER_BUILD_NUMBER=$CI_BUILD_NUMBER/" "$CI_PRIMARY_REPOSITORY_PATH/ios/Flutter/Generated.xcconfig"
fi

echo "=== Generate launcher icons ==="
dart run flutter_launcher_icons

echo "=== pod install ==="
cd "$CI_PRIMARY_REPOSITORY_PATH/ios"
pod install --repo-update
