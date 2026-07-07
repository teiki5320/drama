#!/bin/bash
# SessionStart hook : exécute l'audit Drama au démarrage et expose un résumé.
# Non bloquant : sort 0 même si l'audit échoue, le message est seulement
# affiché à l'agent comme contexte de session.
set -uo pipefail

cd "${CLAUDE_PROJECT_DIR:-$(pwd)}"

if ! command -v python3 >/dev/null 2>&1; then
  echo "[session-start] python3 introuvable, audit ignoré." >&2
  exit 0
fi

if [ ! -f tools/audit.py ]; then
  echo "[session-start] tools/audit.py introuvable, audit ignoré." >&2
  exit 0
fi

OUT=$(python3 tools/audit.py 2>&1) || true
# Compteurs depuis la dernière ligne « RÉSULTAT : ... »
SUMMARY=$(printf '%s\n' "$OUT" | grep -E '^(RÉSULTAT|FAIL|WARN|EDITORIAL) ' | tail -5)

cat <<EOF
[session-start] audit Drama (tools/audit.py) :
$SUMMARY

Pour le détail : python3 tools/audit.py
Pour l'historique des décisions d'auteur en attente : tools/AUDIT_FINDINGS.md
EOF

exit 0
