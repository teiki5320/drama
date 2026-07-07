#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Tests de non-régression pour tools/audit.py.

Aucune dépendance (pas de pytest) — cohérent avec l'audit lui-même.
Exécution :  python3 tools/test_audit.py   (code de sortie 0 = tout passe).

Couvre :
  1. Les motifs de conventions (`BANNED`) — dont le piège « 312ème lettre »
     canonique qui ne doit PAS être flaggé, contrairement à « 8ème » (arrond.).
  2. `_scan_line_strings` — extraction des littéraux de chaîne Dart.
  3. Un run d'intégration sur le vrai repo : l'audit doit rester vert (0 FAIL),
     surfacer les choix Ep2+ à écrire en EDITORIAL, et 0 violation de convention.
"""
import io
import os
import sys
from contextlib import redirect_stdout

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import audit  # noqa: E402

CASES = []


def case(name, ok):
    CASES.append((name, bool(ok)))


def flagged(s):
    """True si au moins un motif interdit matche la chaîne (comme le fait
    check_conventions sur chaque littéral affiché)."""
    return any(rx.search(s) for rx, _ in audit.BANNED)


def matched_msg(s):
    for rx, msg in audit.BANNED:
        if rx.search(s):
            return msg
    return None


# ── 1. Conventions (BANNED) ────────────────────────────────────────────────

# Arrondissements / étages : « Nème » interdit (1-2 chiffres)
case("8ème flaggé (arrondissement)", flagged("dans le 8ème encore"))
case("47ème étage flaggé", flagged("au 47ème étage de la tour"))
case("13ème flaggé (Chinatown)", flagged("les restaurants du 13ème"))
case("8e correct NON flaggé", not flagged("dans le 8e, près du parc"))

# Le piège canonique : « 312ème/313ème/314ème lettre » ne doit PAS être flaggé
# (scènes non-négociables, décompte de lettres, pas un arrondissement).
case("312ème lettre NON flaggé (canon)", not flagged("la 312ème lettre du père"))
case("313ème lettre NON flaggé (canon)", not flagged("elle ouvre la 313ème lettre"))
case("314ème lettre NON flaggé (canon)", not flagged("puis la 314ème lettre, la dernière"))

# Personnages
case("Mme Heng flaggé", flagged("La cliente, Mme Heng, choisit"))
case("Madame Heng correct NON flaggé", not flagged("Madame Heng entre"))
case("Madame HENG flaggé", flagged("Madame HENG a tranché"))

# Bourse
case("PnL flaggé", flagged("affiche le PnL du jour"))
case("PRU correct NON flaggé", not flagged("le PRU moyen ressort à 12"))
case("Plus-value latente NON flaggé", not flagged("Plus-value latente : +8 %"))

# Montants
case("montant collé au € flaggé", flagged("il sort 200€ de sa poche"))
case("montant avec espace insécable NON flaggé", not flagged("2 000 € exactement"))

# Apostrophes
case("apostrophe typographique flaggée", flagged("j’ai froid ce matin"))
case("apostrophe droite NON flaggée", not flagged("j'ai froid ce matin"))

# Le bon message est renvoyé pour l'ordinal
case("message ordinal correct", "Xe" in (matched_msg("le 8ème") or ""))


# ── 2. _scan_line_strings ──────────────────────────────────────────────────

case("extrait un littéral simple quote",
     audit._scan_line_strings("sender: 'maman',") == ["maman"])
case("extrait un littéral double quote",
     audit._scan_line_strings('title: "Bonjour",') == ["Bonjour"])
case("extrait deux littéraux sur la ligne",
     audit._scan_line_strings("a: 'un', b: 'deux'") == ["un", "deux"])
case("gère la quote échappée",
     audit._scan_line_strings(r"body: 'j\'ai dit oui'") == [r"j\'ai dit oui"])
case("ligne sans littéral -> vide",
     audit._scan_line_strings("final int day = 12;") == [])


# ── 3. Intégration : l'audit reste vert sur le vrai repo ───────────────────

def run_full_audit():
    """Rejoue le pipeline de main() sans le rapport, en isolant les globals."""
    for lst in (audit.FAILS, audit.WARNS, audit.OKS, audit.EDITORIAL):
        lst.clear()
    with redirect_stdout(io.StringIO()):  # check_coverage imprime une table
        parsed = audit.check_json_valid()
        audit.check_scenario(parsed)
        audit.check_asset_refs()
        audit.check_pubspec_assets()
        audit.check_choice_wiring()
        audit.check_conventions()
        audit.check_shop_schema(parsed)
        audit.check_doc_drift(parsed)
        audit.check_data_integrity()
        audit.check_chronology()
        audit.check_lore()
        audit.check_coverage()


run_full_audit()
case("repo réel : 0 FAIL", len(audit.FAILS) == 0)
case("repo réel : conventions sans violation",
     any("aucune violation de convention" in m for m in audit.OKS))
case("repo réel : tous les choix d'épisode écrits (plus de mur J23)",
     any("choix d'épisode tous écrits" in m for m in audit.OKS))
case("repo réel : couverture narrative surfacée",
     any("[coverage]" in m for m in audit.EDITORIAL))


# ── Runner ─────────────────────────────────────────────────────────────────

def main():
    failed = [n for n, ok in CASES if not ok]
    for n, ok in CASES:
        print(("  ok  " if ok else "FAIL ") + n)
    print()
    if failed:
        print(f"ÉCHEC : {len(failed)}/{len(CASES)} cas en échec")
        return 1
    print(f"OK : {len(CASES)}/{len(CASES)} cas passent")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
