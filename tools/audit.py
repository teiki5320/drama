#!/usr/bin/env python3
"""Harnais d'audit & simulation pour Drama (À Contre-Jour).

Comme l'environnement web n'a pas Flutter/Dart, ce script valide à la place
ce qui est vérifiable sans compiler :

  1. Validité + schéma des JSON canoniques (assets/data/*.json)
  2. IDs dupliqués / trous dans scenario.json
  3. Références d'assets (chemins assets/... dans lib/) qui existent sur disque
  4. Déclarations d'assets du pubspec qui existent
  5. Cohérence croisée : chaque `requiresChoice` d'un beat a bien un SmsChoice
  6. Linter des conventions linguistiques (CLAUDE.md) sur les chaînes affichées
  7. Simulation de couverture narrative J1 -> J112 (densité par app)

Sortie : rapport lisible + code retour non nul si au moins un FAIL.
Usage :  python3 tools/audit.py [--strict]
  --strict : les WARN deviennent bloquants (code retour non nul).
"""
from __future__ import annotations

import json
import os
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LIB = ROOT / "lib"
DATA = ROOT / "assets" / "data"
PHOTOS = ROOT / "assets" / "photos"

# ── Accumulateurs de résultats ────────────────────────────────────────────
# FAIL     : défaut code/données réparable mécaniquement -> bloque le gate.
# WARN     : à surveiller / réparable -> bloque seulement en --strict.
# EDITORIAL: décision d'auteur requise (voix de Shen, contenu Ep2+). Signalé
#            en clair mais NE bloque PAS le gate : aucun travail code ne le
#            résout, seul l'auteur tranche.
FAILS: list[str] = []
WARNS: list[str] = []
OKS: list[str] = []
EDITORIAL: list[str] = []


def ok(msg: str) -> None:
    OKS.append(msg)


def warn(msg: str) -> None:
    WARNS.append(msg)


def fail(msg: str) -> None:
    FAILS.append(msg)


def editorial(msg: str) -> None:
    EDITORIAL.append(msg)


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


# ── 1. Validité JSON ───────────────────────────────────────────────────────
def check_json_valid() -> dict[str, object]:
    parsed: dict[str, object] = {}
    # scenario.json = référence narrative (non embarquée) ; shop_catalog =
    # seul JSON runtime. investments/insta_seed ont été supprimés (vestiges).
    for name in ("scenario.json", "shop_catalog.json"):
        p = DATA / name
        if not p.exists():
            fail(f"[json] {name} absent de assets/data/")
            continue
        try:
            parsed[name] = json.loads(read(p))
            ok(f"[json] {name} valide")
        except json.JSONDecodeError as e:
            fail(f"[json] {name} invalide : {e}")
    return parsed


# ── 2. scenario.json : doublons & trous ────────────────────────────────────
def check_scenario(parsed: dict[str, object]) -> None:
    data = parsed.get("scenario.json")
    if not isinstance(data, list):
        return
    ids = [e.get("id") for e in data]
    seen: dict[int, int] = {}
    dups: list[int] = []
    for i in ids:
        seen[i] = seen.get(i, 0) + 1
    for i, n in seen.items():
        if n > 1:
            dups.append(i)
    if dups:
        fail(f"[scenario] IDs dupliqués {sorted(dups)} — le doublon J8-J14 a "
             f"été purgé (juillet 2026), il ne doit pas revenir")
    else:
        ok(f"[scenario] {len(data)} entrées, IDs uniques")

    # Schéma minimal de chaque entrée
    required = {"id", "date", "location", "time", "narrative"}
    for e in data:
        missing = required - set(e.keys())
        if missing:
            fail(f"[scenario] J{e.get('id')} : champs manquants {missing}")
    # Trous dans la séquence d'IDs uniques
    uniq = sorted(set(i for i in ids if isinstance(i, int)))
    if uniq:
        holes = [d for d in range(uniq[0], uniq[-1] + 1) if d not in uniq]
        if holes:
            warn(f"[scenario] jours manquants dans la plage encodée : {holes}")


# ── 3. Références d'assets dans lib/ ───────────────────────────────────────
ASSET_RE = re.compile(r"assets/[A-Za-z0-9_/.\-]+\.(?:webp|png|jpg|jpeg|json|gif)")


def check_asset_refs() -> None:
    refs: set[str] = set()
    for dart in LIB.rglob("*.dart"):
        for m in ASSET_RE.findall(read(dart)):
            refs.add(m)
    missing = sorted(r for r in refs if not (ROOT / r).exists())
    if missing:
        for r in missing:
            fail(f"[assets] référence introuvable sur disque : {r}")
    else:
        ok(f"[assets] {len(refs)} références d'assets résolues sur disque")


# ── 4. Déclarations d'assets du pubspec ────────────────────────────────────
def check_pubspec_assets() -> None:
    pub = ROOT / "pubspec.yaml"
    if not pub.exists():
        fail("[pubspec] pubspec.yaml absent")
        return
    in_assets = False
    for line in read(pub).splitlines():
        if re.match(r"\s*assets:\s*$", line):
            in_assets = True
            continue
        if in_assets:
            m = re.match(r"\s*-\s*(\S+)\s*$", line)
            if not m:
                if line.strip() and not line.startswith(" "):
                    in_assets = False
                continue
            decl = m.group(1)
            target = ROOT / decl
            if decl.endswith("/"):
                if not target.is_dir():
                    fail(f"[pubspec] dossier d'assets déclaré mais absent : {decl}")
            else:
                if not target.exists():
                    fail(f"[pubspec] asset déclaré mais absent : {decl}")
    ok("[pubspec] déclarations d'assets vérifiées")


# ── 5. Câblage des choix SMS ───────────────────────────────────────────────
# Modèle réel à deux couches :
#   a) Contrat RUNTIME : un message porte `beatId: X` -> il DOIT exister un
#      SmsChoice X, sinon le panneau de choix s'affiche vide (joueur bloqué).
#      Réciproquement, un SmsChoice X doit être déclenché par un message.
#   b) Couche CONTENU : un beat d'épisode `requiresChoice: X` ne progresse
#      que si le choix X est joué. Les beats sans SmsChoice sont du contenu
#      Ep2+ pas encore écrit (statut, pas bug runtime).
def check_choice_wiring() -> None:
    sms = read(LIB / "data" / "sms_choices.dart")
    defined = set(re.findall(r"beatId:\s*'([^']+)'", sms))

    # beatId déclencheurs présents dans les données Messages (arc inclus)
    msg_text = read(LIB / "data" / "messages_data.dart")
    for arc in (LIB / "data" / "messages_arcs").rglob("*.dart"):
        msg_text += read(arc)
    triggered = set(re.findall(r"beatId:\s*'([^']+)'", msg_text))

    # a) Contrat runtime, dans les deux sens
    no_choice = sorted(triggered - defined)
    if no_choice:
        fail(f"[choices] messages avec beatId SANS SmsChoice (panneau vide) : "
             f"{no_choice}")
    dead = sorted(defined - triggered)
    if dead:
        warn(f"[choices] SmsChoice définis mais jamais déclenchés par un "
             f"message (code mort) : {dead}")
    if not no_choice and not dead:
        ok(f"[choices] {len(defined)} SmsChoice cohérents avec les messages "
           f"déclencheurs (contrat runtime OK)")

    # b) Couche contenu : statut de l'écriture des choix d'épisode
    episodes = read(LIB / "data" / "episodes.dart")
    required = set(re.findall(r"requiresChoice:\s*'([^']+)'", episodes))
    pending = sorted(required - defined)
    if pending:
        editorial(f"[contenu] choix d'épisode à écrire ({len(pending)}/"
                  f"{len(required)}, Ep2+) : {pending}")
    else:
        ok(f"[contenu] {len(required)} choix d'épisode tous écrits")


# ── 6. Linter conventions linguistiques (CLAUDE.md) ────────────────────────
# On ne lint QUE les valeurs de chaînes destinées à l'affichage, pas les
# identifiants techniques. Heuristique : chaînes après des clés de contenu,
# ou prose dans les JSON.
DISPLAY_KEYS = (
    "content", "body", "text", "reply", "message", "title", "subtitle",
    "snippet", "description", "label", "coda", "narrative", "caption",
    "preview", "summary", "notifBody", "notifTitle",
)

# Motifs interdits -> message
BANNED = [
    (re.compile(r"\bMme Heng\b"), "« Mme Heng » interdit -> « Madame Heng »"),
    (re.compile(r"\bMadame HENG\b"), "« Madame HENG » interdit -> « Madame Heng »"),
    (re.compile(r"\bPnL\b"), "« PnL » interdit -> « Plus-value latente »"),
    # Arrondissements / etages : borne 1-2 chiffres pour NE PAS flagger les
    # decomptes canoniques « 312eme/313eme/314eme lettre » (scenes non-negociables).
    (re.compile(r"\b[0-9]{1,2} ?ème\b"), "« Xème » interdit -> « Xe »"),
    (re.compile(r"[0-9](?:€|€)"), "montant collé au € -> espace insécable avant €"),
    (re.compile(r"[’]"), "apostrophe typographique -> apostrophe droite '"),
]


def _scan_line_strings(line: str):
    """Renvoie les littéraux de chaîne Dart (entre ' ou ") d'une ligne."""
    # Capture grossière des contenus de chaîne ; suffisant pour du data.
    out = []
    for m in re.finditer(r"'((?:[^'\\]|\\.)*)'", line):
        out.append(m.group(1))
    for m in re.finditer(r'"((?:[^"\\]|\\.)*)"', line):
        out.append(m.group(1))
    return out


def check_conventions() -> None:
    hits = 0
    # JSON : on lint toute la prose (valeurs de content/body/narrative)
    for name in ("scenario.json", "insta_seed.json", "shop_catalog.json"):
        p = DATA / name
        if not p.exists():
            continue
        for ln, line in enumerate(read(p).splitlines(), 1):
            for rx, msg in BANNED:
                if rx.search(line):
                    # ignore les clés JSON techniques évidentes
                    fail(f"[conv] {name}:{ln} {msg}")
                    hits += 1
    # Dart (data + ui + core) : ne linter que les lignes qui portent une clé
    # d'affichage ou une chaîne de continuation. On couvre tout lib/ car la
    # prose affichée vit aussi dans lib/ui (ex. stories Instagram).
    key_re = re.compile(r"\b(" + "|".join(DISPLAY_KEYS) + r")\b\s*:")
    for dart in LIB.rglob("*.dart"):
        rel = dart.relative_to(ROOT)
        lines = read(dart).splitlines()
        for ln, line in enumerate(lines, 1):
            stripped = line.lstrip()
            if stripped.startswith("//") or stripped.startswith("///"):
                continue  # commentaire, pas affiché
            # ligne pertinente : porte une clé d'affichage OU est une chaîne
            # de continuation (ligne qui commence par une quote)
            is_display = bool(key_re.search(line)) or stripped[:1] in {"'", '"'}
            if not is_display:
                continue
            for s in _scan_line_strings(line):
                for rx, msg in BANNED:
                    if rx.search(s):
                        fail(f"[conv] {rel}:{ln} {msg}")
                        hits += 1
    if hits == 0:
        ok("[conv] aucune violation de convention dans les chaînes affichées")


# ── 6b. shop_catalog.json : schéma vs modèle Dart ShopItem ─────────────────
def check_shop_schema(parsed: dict[str, object]) -> None:
    data = parsed.get("shop_catalog.json")
    if not isinstance(data, list):
        return
    # Champs requis par ShopItem.fromJson (cast direct, non nullable)
    required = {"id", "category", "emoji", "name", "description", "price"}
    # Champs connus du modèle (parsés)
    known = required | {
        "moodGain", "reputationGain", "requiredReputation",
        "requiredMood", "generatesInstaPost",
        # câblés juillet 2026 : achat -> post Instagram auto
        "instaPostCaption", "instaPostEmoji",
    }
    # Catégories déclarées dans kShopCategories
    model = read(LIB / "models" / "shop_item.dart")
    cats = set(re.findall(r"'([a-z]+)':\s*'", model))
    bad = 0
    seen_extra: set[str] = set()
    seen_ids: set[str] = set()
    for it in data:
        miss = required - set(it.keys())
        if miss:
            fail(f"[shop] item {it.get('id','?')} : champs requis manquants {miss}")
            bad += 1
        if it.get("id") in seen_ids:
            fail(f"[shop] id dupliqué : {it.get('id')}")
        seen_ids.add(it.get("id"))
        if it.get("category") not in cats:
            warn(f"[shop] item {it.get('id')} : catégorie « {it.get('category')} » "
                 f"absente de kShopCategories {sorted(cats)}")
        seen_extra |= (set(it.keys()) - known)
    if seen_extra:
        editorial(f"[shop] champs JSON {sorted(seen_extra)} présents mais non "
                  f"câblés : la feature « achat -> post Instagram » "
                  f"(generatesInstaPost) est parsée mais jamais consommée. "
                  f"Feature à implémenter, pas un défaut.")
    if bad == 0:
        ok(f"[shop] {len(data)} items, schéma compatible avec ShopItem.fromJson")


# ── 6c. Drift de documentation : CLAUDE.md vs réalité ──────────────────────
def check_doc_drift(parsed: dict[str, object]) -> None:
    claude = ROOT / "CLAUDE.md"
    if not claude.exists():
        return
    txt = read(claude)
    # Tolérant au markdown : on capture le 1er nombre dans la 1re parenthèse
    # qui suit le nom de fichier (en sautant `, *, ~ et espaces).
    for name in ("shop_catalog.json",):
        rx = re.escape(name) + r"[^\n(]*\(\D*(\d+)"
        m = re.search(rx, txt)
        data = parsed.get(name)
        if m and isinstance(data, list):
            claimed = int(m.group(1))
            actual = len(data)
            if claimed != actual:
                warn(f"[doc] CLAUDE.md annonce {claimed} pour {name} "
                     f"mais le fichier en contient {actual}")
            else:
                ok(f"[doc] CLAUDE.md à jour pour {name} ({actual})")
    # main.dart n'est plus un placeholder ?
    main = read(LIB / "main.dart")
    if "PhoneShell" in main and "Refonte en cours" in txt:
        warn("[doc] CLAUDE.md décrit lib/main.dart comme un placeholder "
             "« Refonte en cours », mais main.dart instancie déjà PhoneShell")


# ── 6d. Intégrité structurelle (catalogues, IDs, contacts) ─────────────────
def _imports_in(catalog: Path, folder: str) -> set[str]:
    txt = read(catalog)
    return set(re.findall(rf"import '([^']*{folder}/[^']+\.dart)'", txt))


def check_data_integrity() -> None:
    # a) Catalogues : pas d'import cassé ni de fichier orphelin
    for catalog, folder in (
        (LIB / "data" / "romance_templates.dart", "romance"),
        (LIB / "data" / "messages_arcs_catalog.dart", "messages_arcs"),
    ):
        if not catalog.exists():
            continue
        imported = {os.path.basename(p) for p in _imports_in(catalog, folder)}
        actual = {p.name for p in (LIB / "data" / folder).glob("*.dart")}
        dangling = sorted(imported - actual)
        orphan = sorted(actual - imported)
        if dangling:
            fail(f"[integrite] {catalog.name} importe des fichiers absents : "
                 f"{dangling}")
        if orphan:
            warn(f"[integrite] fichiers jamais importés par {catalog.name} "
                 f"(code mort) : {orphan}")
        if not dangling and not orphan:
            ok(f"[integrite] {catalog.name} : {len(imported)} imports cohérents "
               f"avec {folder}/")

    # b) IDs dupliqués dans les archétypes / arcs
    for folder in ("romance", "messages_arcs"):
        d = LIB / "data" / folder
        if not d.is_dir():
            continue
        ids: dict[str, str] = {}
        dups: list[str] = []
        for f in d.glob("*.dart"):
            for i in re.findall(r"\bid:\s*'([^']+)'", read(f)):
                if i in ids and ids[i] != f.name:
                    dups.append(i)
                ids[i] = f.name
        if dups:
            warn(f"[integrite] id dupliqués dans {folder}/ : {sorted(set(dups))}")

    # c) Chaque thread Messages pointe vers un contact défini
    msg = LIB / "data" / "messages_data.dart"
    if msg.exists():
        txt = read(msg)
        m = re.search(r"kThreads\s*=\s*\{(.*)", txt, re.S)
        contacts = set(re.findall(r"id:\s*'([a-z_]+)'", txt))
        if m:
            keys = re.findall(r"^\s{2}'([a-z_]+)'\s*:", m.group(1), re.M)
            missing = [k for k in keys if k not in contacts]
            if missing:
                fail(f"[integrite] threads sans contact défini : {missing}")
            else:
                ok(f"[integrite] {len(keys)} threads Messages -> contacts "
                   f"tous définis")


# ── 6e. Chronologie : beats monotones, events ordonnés ─────────────────────
def check_chronology() -> None:
    ep = read(LIB / "data" / "episodes.dart")
    problems = 0
    for num, body in re.findall(r"number:\s*(\d+),(.*?)(?=number:\s*\d+,|\Z)",
                                ep, re.S):
        prev = None
        for idx, d, h, mi in re.findall(
            r"idx:\s*(\d+),\s*day:\s*(\d+),\s*hour:\s*(\d+),\s*minute:\s*(\d+)",
            body,
        ):
            key = (int(d), int(h), int(mi))
            if prev and key < prev[1]:
                fail(f"[chrono] Ep{num} beat idx={idx} ({key}) antérieur au "
                     f"beat idx={prev[0]} ({prev[1]}) — progression cassée")
                problems += 1
            prev = (idx, key)
    if problems == 0:
        ok("[chrono] beats d'épisode monotones en temps")

    ev = read(LIB / "data" / "day_events.dart")
    keys = [(int(d), int(h), int(m)) for d, h, m in re.findall(
        r"day:\s*(\d+),\s*hour:\s*(\d+),\s*minute:\s*(\d+)", ev)]
    unordered = [b for a, b in zip(keys, keys[1:]) if b < a]
    if unordered:
        fail(f"[chrono] day_events non ordonnés chronologiquement : {unordered}")
    else:
        ok(f"[chrono] {len(keys)} day_events ordonnés chronologiquement")


# ── 6f. Cohérence de lore (adresse appartement Tristan) ────────────────────
def check_lore() -> None:
    # Canon tranché (juillet 2026, décision d'auteur) : l'appartement de
    # Tristan est RUE DE BERRI (8e). L'ancienne dérive « avenue Foch » (16e)
    # a été purgée — garde anti-régression : aucune réf Foch ne doit revenir.
    refs = 0
    for dart in LIB.rglob("*.dart"):
        refs += len(re.findall(r"[Ff]och", read(dart)))
    roadmap = ROOT / "ROADMAP.md"
    if roadmap.exists():
        refs += len(re.findall(r"[Ff]och", read(roadmap)))
    if refs:
        fail(f"[lore] {refs} référence(s) « Foch » réapparue(s) — le canon "
             f"est rue de Berri (8e)")
    else:
        ok("[lore] adresse canonique rue de Berri (8e) respectée (0 réf Foch)")


# ── 7. Simulation couverture narrative J1 -> J112 ──────────────────────────
def _days_in(path: Path, pattern: str = r"day:\s*(\d+)") -> set[int]:
    if not path.exists():
        return set()
    return set(int(d) for d in re.findall(pattern, read(path)))


def check_coverage() -> None:
    sources = {
        "beats (episodes)": _days_in(LIB / "data" / "episodes.dart"),
        "dayEvents": _days_in(LIB / "data" / "day_events.dart"),
        "messages": _days_in(LIB / "data" / "messages_data.dart",
                             r"(?:day|fromDay):\s*(\d+)"),
        "notes/carnet": _days_in(LIB / "data" / "notes_data.dart"),
        "photos": _days_in(LIB / "data" / "photos_data.dart"),
        "banque": _days_in(LIB / "data" / "banque_data.dart"),
        "calendrier": _days_in(LIB / "data" / "calendar_data.dart"),
        "telephone": _days_in(LIB / "data" / "telephone_data.dart"),
    }
    print("\n  Couverture narrative par source (sur 112 jours) :")
    for label, days in sources.items():
        days = {d for d in days if 1 <= d <= 112}
        n = len(days)
        last = max(days) if days else 0
        bar = "#" * round(n / 112 * 30)
        print(f"    {label:20s} {n:3d} jours  (dernier J{last:<3d}) {bar}")
    union = set()
    for days in sources.values():
        union |= {d for d in days if 1 <= d <= 112}
    covered = len(union)
    # La métrique qui compte : le jeu ne VISITE que les jours de beats
    # (advanceToNextBeat saute de beat en beat). Un jour sans beat n'est
    # jamais affiché — le « trou » calendaire est donc théorique.
    beat_days = sources["beats (episodes)"]
    other = union - beat_days
    visited_covered = len(beat_days & union)
    editorial(f"[coverage] {covered}/112 jours calendaires ont une trace ; "
              f"surtout : {visited_covered}/{len(beat_days)} jours de beats "
              f"(les seuls visités) sont couverts, + {len(other)} jours "
              f"d'ambiance hors beats. Densité d'auteur, non bloquant.")


# ── main ───────────────────────────────────────────────────────────────────
def main() -> int:
    strict = "--strict" in sys.argv
    print("=" * 70)
    print("AUDIT DRAMA — À Contre-Jour")
    print("=" * 70)

    parsed = check_json_valid()
    check_scenario(parsed)
    check_asset_refs()
    check_pubspec_assets()
    check_choice_wiring()
    check_conventions()
    check_shop_schema(parsed)
    check_doc_drift(parsed)
    check_data_integrity()
    check_chronology()
    check_lore()
    check_coverage()

    print("\n" + "-" * 70)
    print(f"OK   : {len(OKS)}")
    for m in OKS:
        print(f"  ✓ {m}")
    if WARNS:
        print(f"\nWARN : {len(WARNS)}")
        for m in WARNS:
            print(f"  ! {m}")
    if EDITORIAL:
        print(f"\nEDITORIAL ({len(EDITORIAL)}) — décision d'auteur, non bloquant :")
        for m in EDITORIAL:
            print(f"  ✎ {m}")
    if FAILS:
        print(f"\nFAIL : {len(FAILS)}")
        for m in FAILS:
            print(f"  ✗ {m}")
    print("-" * 70)

    if FAILS:
        print(f"RÉSULTAT : ÉCHEC ({len(FAILS)} fail, {len(WARNS)} warn, "
              f"{len(EDITORIAL)} editorial)")
        return 1
    if strict and WARNS:
        print(f"RÉSULTAT : ÉCHEC strict ({len(WARNS)} warn, "
              f"{len(EDITORIAL)} editorial)")
        return 1
    print(f"RÉSULTAT : OK ({len(WARNS)} warn, {len(EDITORIAL)} editorial "
          f"non bloquants)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
