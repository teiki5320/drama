#!/bin/sh
# Harnais de test VISUEL : compile l'app en web, la sert en local, la pilote
# dans Chromium headless (Playwright) et capture des écrans que l'on peut
# relire pour repérer les incohérences d'affichage/UX (le fil qui se déverse,
# une bannière qui spoile, un écran cassé…) — que ni l'audit de données ni
# les tests logiques ne voient.
#
# Prérequis (installés à la volée dans une session Claude Code) :
#   - Flutter 3.27.4 sur le PATH (git clone --branch 3.27.4 …/flutter)
#   - Chromium via Playwright (PLAYWRIGHT_BROWSERS_PATH=/opt/pw-browsers)
#   - node avec le module playwright (NODE_PATH vers les node_modules globaux)
#
# IMPORTANT : renderer HTML obligatoire — le renderer CanvasKit tente de
# télécharger un wasm depuis gstatic.com, bloqué par le proxy → écran blanc.
#
# Le projet n'ayant pas de dossier web/ à l'origine (app iOS), on le génère
# une fois : flutter create --platforms=web .
#
# Usage : sh tools/webshoot/run.sh [outdir]
set -e
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
OUT="${1:-$ROOT/.webshoot}"
PORT=8099
mkdir -p "$OUT"

cd "$ROOT"
[ -f web/index.html ] || flutter create --platforms=web .
flutter build web --release --web-renderer html

# serveur local
( cd build/web && exec python3 -m http.server "$PORT" ) >/dev/null 2>&1 &
SRV=$!
trap 'kill $SRV 2>/dev/null' EXIT
sleep 2

# pilote : boot + 6 clics (5 Continuer + Entrer) → écran verrouillé
STEPS='[{"x":547,"y":1241,"wait":1400},{"x":547,"y":1241,"wait":1400},{"x":547,"y":1241,"wait":1400},{"x":547,"y":1241,"wait":1400},{"x":547,"y":1241,"wait":1600},{"x":547,"y":1241,"wait":2200,"shot":"'"$OUT"'/lock.png"}]'
NODE_PATH="$(npm root -g)" node "$ROOT/tools/webshoot/drive.js" \
  "http://localhost:$PORT/" "$OUT/boot.png" "$STEPS"

echo "Captures dans $OUT/"
