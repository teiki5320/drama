#!/usr/bin/env python3
"""transcript.py — extrait TOUT le contenu conversationnel du jeu dans des
tableaux Markdown lisibles, par personnage, avec toutes les branches de
réponse. Objectif : pouvoir relire chaque conversation à plat et repérer
les incohérences (timeline, spoilers, ruptures de ton, branches orphelines).

Aucune dépendance (pas besoin de Flutter). Parse directement les fichiers
Dart de `lib/data/` :
  - kThreads (messages_data.dart)      → fils principaux, plats
  - kSmsChoices (sms_choices.dart)     → choix de réponse (3 options)
  - kContacts (messages_data.dart)     → noms/emoji d'en-tête
  - MessagesArcTemplate (messages_arcs/*, romance/*) → arcs à branches

Sorties dans docs/transcripts/ :
  - main_<contact>.md   un tableau chronologique par personnage principal
  - arcs.md / romance.md tableaux des arcs secondaires (branches, variantes)
  - _incoherences.md    passe heuristique (signale, ne corrige pas)
  - README.md           index

Usage : python3 tools/transcript.py
"""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DATA = ROOT / "lib" / "data"
OUT = ROOT / "docs" / "transcripts"


# ─────────────────────────────────────────────────────────────────────────
# Tokeniseur Dart minimal : chaînes, concaténation de littéraux adjacents,
# découpage d'arguments au niveau supérieur (profondeur brackets/parens).
# ─────────────────────────────────────────────────────────────────────────

def strip_comments(src: str) -> str:
    """Retire les commentaires // et /* */ (hors chaînes)."""
    out = []
    i, n = 0, len(src)
    while i < n:
        c = src[i]
        if c in "'\"":
            # avale la chaîne entière (avec échappements)
            q = c
            out.append(c)
            i += 1
            while i < n:
                out.append(src[i])
                if src[i] == "\\":
                    i += 1
                    if i < n:
                        out.append(src[i])
                        i += 1
                    continue
                if src[i] == q:
                    i += 1
                    break
                i += 1
            continue
        if c == "/" and i + 1 < n and src[i + 1] == "/":
            while i < n and src[i] != "\n":
                i += 1
            continue
        if c == "/" and i + 1 < n and src[i + 1] == "*":
            i += 2
            while i + 1 < n and not (src[i] == "*" and src[i + 1] == "/"):
                i += 1
            i += 2
            continue
        out.append(c)
        i += 1
    return "".join(out)


def read_string_literals(seg: str) -> str | None:
    """Si `seg` est une suite de littéraux chaîne Dart (concaténés), renvoie
    la chaîne Python résultante ; sinon None. Gère 'a' 'b', \\n, \\', etc."""
    i, n = 0, len(seg)
    parts: list[str] = []
    saw = False
    while i < n:
        c = seg[i]
        if c.isspace():
            i += 1
            continue
        if c in "'\"":
            saw = True
            q = c
            i += 1
            buf = []
            while i < n and seg[i] != q:
                if seg[i] == "\\":
                    i += 1
                    if i >= n:
                        break
                    esc = seg[i]
                    buf.append(
                        {"n": "\n", "t": "\t", "'": "'", '"': '"',
                         "\\": "\\", "$": "$"}.get(esc, esc)
                    )
                    i += 1
                else:
                    buf.append(seg[i])
                    i += 1
            i += 1  # ferme le quote
            parts.append("".join(buf))
        else:
            # token non-chaîne présent → ce n'est pas un littéral pur
            return None
    return "".join(parts) if saw else None


def split_top_level(body: str, sep: str = ",") -> list[str]:
    """Découpe `body` sur `sep` au niveau de profondeur 0 (hors (){}[] et
    hors chaînes)."""
    out: list[str] = []
    depth = 0
    i, n = 0, len(body)
    start = 0
    while i < n:
        c = body[i]
        if c in "'\"":
            q = c
            i += 1
            while i < n:
                if body[i] == "\\":
                    i += 2
                    continue
                if body[i] == q:
                    break
                i += 1
            i += 1
            continue
        if c in "([{":
            depth += 1
        elif c in ")]}":
            depth -= 1
        elif c == sep and depth == 0:
            out.append(body[start:i])
            start = i + 1
        i += 1
    tail = body[start:]
    if tail.strip():
        out.append(tail)
    return out


def named_args(body: str) -> dict[str, str]:
    """Parse `key: value, key: value` au niveau supérieur → dict brut."""
    args: dict[str, str] = {}
    for seg in split_top_level(body):
        seg = seg.strip()
        if not seg:
            continue
        # clé : identifiant suivi de ':' au niveau 0, mais pas '::' ni '?'
        m = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)\s*:", seg)
        if not m:
            continue
        key = m.group(1)
        val = seg[m.end():].strip()
        args[key] = val
    return args


def find_calls(src: str, name: str) -> list[str]:
    """Renvoie le corps (...) de chaque appel `name(` au niveau où il
    apparaît, en respectant l'équilibrage des parenthèses."""
    bodies: list[str] = []
    for m in re.finditer(r"\b" + re.escape(name) + r"\s*\(", src):
        i = m.end()  # juste après la parenthèse ouvrante
        depth = 1
        n = len(src)
        start = i
        while i < n and depth > 0:
            c = src[i]
            if c in "'\"":
                q = c
                i += 1
                while i < n:
                    if src[i] == "\\":
                        i += 2
                        continue
                    if src[i] == q:
                        break
                    i += 1
                i += 1
                continue
            if c == "(":
                depth += 1
            elif c == ")":
                depth -= 1
                if depth == 0:
                    bodies.append(src[start:i])
                    break
            i += 1
    return bodies


def list_elements(value: str) -> list[str]:
    """Si `value` est `[ ... ]`, renvoie les éléments de niveau supérieur."""
    v = value.strip()
    if not (v.startswith("[") and v.endswith("]")):
        return []
    return [e.strip() for e in split_top_level(v[1:-1]) if e.strip()]


def unquote(value: str | None) -> str:
    if value is None:
        return ""
    s = read_string_literals(value)
    return s if s is not None else value.strip()


def md_cell(text: str) -> str:
    """Échappe un texte pour une cellule Markdown mono-ligne."""
    return text.replace("\\", "\\\\").replace("|", "\\|").replace("\n", " ⏎ ").strip()


# ─────────────────────────────────────────────────────────────────────────
# Parseurs de données
# ─────────────────────────────────────────────────────────────────────────

def parse_contacts() -> dict[str, dict]:
    src = strip_comments((DATA / "messages_data.dart").read_text(encoding="utf-8"))
    contacts: dict[str, dict] = {}
    for body in find_calls(src, "MsgContact"):
        a = named_args(body)
        cid = unquote(a.get("id"))
        if cid:
            contacts[cid] = {
                "name": unquote(a.get("displayName")) or cid,
                "emoji": unquote(a.get("emoji")),
                "role": unquote(a.get("subtitle")) or unquote(a.get("role")),
            }
    return contacts


def parse_threads() -> dict[str, list[dict]]:
    src = strip_comments((DATA / "messages_data.dart").read_text(encoding="utf-8"))
    m = re.search(r"kThreads\s*=\s*\{", src)
    if not m:
        return {}
    # corps de la map jusqu'au '};' équilibré
    i = m.end()
    depth = 1
    n = len(src)
    start = i
    while i < n and depth > 0:
        c = src[i]
        if c in "'\"":
            q = c
            i += 1
            while i < n:
                if src[i] == "\\":
                    i += 2
                    continue
                if src[i] == q:
                    break
                i += 1
            i += 1
            continue
        if c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
        i += 1
    body = src[start:i - 1]

    threads: dict[str, list[dict]] = {}
    # entrées 'contact': [ ... ]
    for seg in split_top_level(body):
        seg = seg.strip()
        km = re.match(r"^'([^']+)'\s*:\s*\[", seg)
        if not km:
            continue
        cid = km.group(1)
        list_body = seg[km.end() - 1:]  # commence au '['
        msgs = []
        for mb in find_calls("Msg" + list_body if False else list_body, "Msg"):
            a = named_args(mb)
            msgs.append({
                "sender": unquote(a.get("sender")),
                "text": unquote(a.get("text")),
                "time": unquote(a.get("time")),
                "day": int(re.sub(r"\D", "", a.get("day", "0")) or 0),
                "beatId": unquote(a.get("beatId")) if a.get("beatId") else None,
                "suspicion": a.get("requiresSuspicionAtLeast"),
            })
        threads[cid] = msgs
    return threads


def parse_choices() -> dict[str, dict]:
    src = strip_comments((DATA / "sms_choices.dart").read_text(encoding="utf-8"))
    choices: dict[str, dict] = {}
    for body in find_calls(src, "SmsChoice"):
        a = named_args(body)
        beat = unquote(a.get("beatId"))
        if not beat:
            continue
        opts = []
        for ob in find_calls(a.get("options", ""), "SmsChoiceOption"):
            oa = named_args(ob)
            opts.append({
                "label": unquote(oa.get("label")) or "(sans label)",
                "reply": unquote(oa.get("reply")),
                "delta": (oa.get("delta") or "").strip(),
            })
        choices[beat] = {"contact": unquote(a.get("contactId")), "options": opts}
    return choices


def parse_arc_file(path: Path) -> dict | None:
    src = strip_comments(path.read_text(encoding="utf-8"))
    # Deux moteurs partagent la même forme de beats : arcs iMessage et
    # romances Tinder. On détecte lequel selon le template présent.
    if find_calls(src, "MessagesArcTemplate"):
        beat_name, choice_name, tmpl_name = (
            "MessagesArcBeat", "MessagesArcChoice", "MessagesArcTemplate")
    elif find_calls(src, "RomanceTemplate"):
        beat_name, choice_name, tmpl_name = (
            "RomanceBeat", "RomanceChoice", "RomanceTemplate")
    else:
        return None
    ta = named_args(find_calls(src, tmpl_name)[0])
    # contact — arc : MessagesArcContact unique ; romance : pool de profils.
    contact = {}
    cc = find_calls(src, "MessagesArcContact")
    if cc:
        ca = named_args(cc[0])
        contact = {
            "name": unquote(ca.get("displayName")),
            "emoji": unquote(ca.get("emoji")),
            "role": unquote(ca.get("subtitle")),
        }
    else:
        names = [unquote(named_args(pb).get("name"))
                 for pb in find_calls(src, "RomanceProfile")]
        names = [x for x in names if x]
        emojis = [unquote(named_args(pb).get("emoji"))
                  for pb in find_calls(src, "RomanceProfile")]
        contact = {
            "name": " / ".join(names) if names else path.stem,
            "emoji": emojis[0] if emojis else "",
            "role": unquote(ta.get("tone")).split(".")[-1].strip()
            if ta.get("tone") else "",
        }
    beats = []
    for bb in find_calls(src, beat_name):
        a = named_args(bb)
        variants = [unquote(v) for v in list_elements(a.get("textVariants", "[]"))]
        chs = []
        for cb in find_calls(a.get("choices", ""), choice_name):
            cha = named_args(cb)
            chs.append({
                "label": unquote(cha.get("label")),
                "reply": unquote(cha.get("reply")),
                "setBranch": unquote(cha.get("setBranch")) if cha.get("setBranch") else None,
                "endsArc": unquote(cha.get("endsArc")) if cha.get("endsArc") else None,
                "mood": cha.get("moodDelta"),
            })
        beats.append({
            "day": int(re.sub(r"\D", "", a.get("dayOffset", "0")) or 0),
            "hour": int(re.sub(r"\D", "", a.get("atHour", "0")) or 0),
            "min": int(re.sub(r"\D", "", a.get("atMinute", "0")) or 0),
            "type": (a.get("type", "")).split(".")[-1].strip(),
            "fromThem": "false" not in (a.get("fromThem", "true")),
            "variants": variants,
            "choices": chs,
            "require": unquote(a.get("requireBranch")) if a.get("requireBranch") else None,
            "forbid": unquote(a.get("forbidBranch")) if a.get("forbidBranch") else None,
            "set": unquote(a.get("setBranch")) if a.get("setBranch") else None,
            "endsArc": unquote(a.get("endsArc")) if a.get("endsArc") else None,
        })
    return {
        "id": unquote(ta.get("id")) or path.stem,
        "label": unquote(ta.get("label")),
        "category": (ta.get("category", "")).split(".")[-1].strip(),
        "minStartDay": ta.get("minStartDay", "1").strip(),
        "description": unquote(ta.get("description")),
        "contact": contact,
        "beats": beats,
        "file": str(path.relative_to(ROOT)),
    }


# ─────────────────────────────────────────────────────────────────────────
# Rendu Markdown
# ─────────────────────────────────────────────────────────────────────────

def render_main(cid: str, contact: dict, msgs: list[dict],
                choices: dict[str, dict]) -> str:
    head = contact.get("name", cid)
    emoji = contact.get("emoji", "")
    lines = [f"# {emoji} {head}  ·  fil principal", ""]
    lines.append(f"Contact `{cid}` — {len(msgs)} messages canoniques. "
                 f"« moi » = Shen.")
    lines.append("")
    cur_day = None
    for m in msgs:
        if m["day"] != cur_day:
            cur_day = m["day"]
            lines.append("")
            lines.append(f"## J{cur_day}")
            lines.append("")
            lines.append("| Heure | Qui | Message | beat |")
            lines.append("|---|---|---|---|")
        who = "**Shen**" if m["sender"] == "moi" else head
        beat = f"`{m['beatId']}`" if m["beatId"] else ""
        susp = f" ⟨susp≥{m['suspicion']}⟩" if m["suspicion"] else ""
        lines.append(f"| {m['time']} | {who} | {md_cell(m['text'])}{susp} | {beat} |")
        # si beat avec choix → détaille les options juste après
        if m["beatId"] and m["beatId"] in choices:
            opts = choices[m["beatId"]]["options"]
            lines.append(f"| | | ↳ **{len(opts)} réponses possibles :** | |")
            for o in opts:
                lines.append(
                    f"| | | · **{md_cell(o['label'])}** → "
                    f"« {md_cell(o['reply'])} » {md_cell(o['delta'])} | |")
    lines.append("")
    return "\n".join(lines)


def render_arc(arc: dict) -> str:
    c = arc["contact"]
    lines = [f"### {c.get('emoji','')} {arc['label']}  ·  `{arc['id']}`", ""]
    lines.append(f"- Catégorie **{arc['category']}** · démarre ≥ J{arc['minStartDay']} "
                 f"· contact {c.get('name','?')} ({c.get('role','')})")
    if arc["description"]:
        lines.append(f"- _{arc['description']}_")
    lines.append(f"- Fichier `{arc['file']}` · {len(arc['beats'])} beats")
    lines.append("")
    lines.append("| J+ | Heure | Qui | Type | Contenu / branches |")
    lines.append("|---|---|---|---|---|")
    for b in arc["beats"]:
        who = "l'autre" if b["fromThem"] else "**Shen**"
        cond = []
        if b["require"]:
            cond.append(f"si `{b['require']}`")
        if b["forbid"]:
            cond.append(f"sauf `{b['forbid']}`")
        if b["set"]:
            cond.append(f"→pose `{b['set']}`")
        if b["endsArc"]:
            cond.append(f"FIN `{b['endsArc']}`")
        condtxt = (" _(" + ", ".join(cond) + ")_") if cond else ""
        t = f"{b['hour']:02d}:{b['min']:02d}"
        if b["type"] == "choice":
            content = "**CHOIX :**" + condtxt
            lines.append(f"| J+{b['day']} | {t} | {who} | choice | {content} |")
            for ch in b["choices"]:
                tail = []
                if ch["setBranch"]:
                    tail.append(f"→`{ch['setBranch']}`")
                if ch["endsArc"]:
                    tail.append(f"FIN `{ch['endsArc']}`")
                reply = md_cell(ch["reply"]) if ch["reply"] else "_(silence)_"
                lines.append(
                    f"| | | | | · **{md_cell(ch['label'])}** → « {reply} » "
                    f"{' '.join(tail)} |")
        else:
            if len(b["variants"]) <= 1:
                content = md_cell(b["variants"][0]) if b["variants"] else f"_{b['type']}_"
            else:
                content = f"**{len(b['variants'])} variantes :** " + " ⁄ ".join(
                    f"« {md_cell(v)} »" for v in b["variants"])
            lines.append(f"| J+{b['day']} | {t} | {who} | {b['type']} | {content}{condtxt} |")
    lines.append("")
    return "\n".join(lines)


# ─────────────────────────────────────────────────────────────────────────
# Passe heuristique d'incohérences (signale, ne corrige pas)
# ─────────────────────────────────────────────────────────────────────────

def scan_incoherences(threads, choices, arcs) -> list[str]:
    flags: list[str] = []

    def _min_of(t: str) -> int:
        mm = re.match(r"(\d{1,2}):(\d{2})", t or "")
        return int(mm.group(1)) * 60 + int(mm.group(2)) if mm else -1

    # 1) Ordre horaire non monotone à l'intérieur d'un jour (par fil)
    for cid, msgs in threads.items():
        last = {}
        for m in msgs:
            d = m["day"]
            cur = _min_of(m["time"])
            if d in last and cur >= 0 and cur < last[d]:
                flags.append(
                    f"[timeline] {cid} J{d} : {m['time']} arrive après un "
                    f"message plus tardif (« {m['text'][:40]}… »)")
            if cur >= 0:
                last[d] = cur

    # 2) Mention « 18 000 » / montant clé avant J2 (révélation Aubin)
    for cid, msgs in threads.items():
        for m in msgs:
            if m["day"] < 2 and re.search(r"18\s?000|18\.000", m["text"]):
                flags.append(f"[spoiler] {cid} J{m['day']} évoque 18 000 € "
                             f"avant la révélation (J2)")

    # 3) beat déclencheur sans choix défini / choix orphelin
    triggered = {m["beatId"] for msgs in threads.values() for m in msgs if m["beatId"]}
    defined = set(choices)
    for b in sorted(triggered - defined):
        flags.append(f"[choix] beat déclenché sans SmsChoice : `{b}`")
    for b in sorted(defined - triggered):
        flags.append(f"[choix] SmsChoice jamais déclenché : `{b}`")

    # 4) Arcs : branche requise jamais posée / fin jamais atteinte
    for arc in arcs:
        posed = set()
        for b in arc["beats"]:
            if b["set"]:
                posed.add(b["set"])
            for ch in b["choices"]:
                if ch["setBranch"]:
                    posed.add(ch["setBranch"])
        for b in arc["beats"]:
            if b["require"] and b["require"] not in posed:
                flags.append(f"[arc {arc['id']}] requireBranch `{b['require']}` "
                             f"jamais posé par aucun choix")
    return flags


# ─────────────────────────────────────────────────────────────────────────

def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    contacts = parse_contacts()
    threads = parse_threads()
    choices = parse_choices()

    arc_files = sorted((DATA / "messages_arcs").glob("*.dart")) + \
        sorted((DATA / "romance").glob("*.dart"))
    arcs = [a for a in (parse_arc_file(p) for p in arc_files) if a]

    index = ["# Transcripts — tous les fils & branches", "",
             "Généré par `tools/transcript.py`. Relire pour repérer les "
             "incohérences (timeline, spoilers, ton, branches).", "",
             "## Fils principaux", ""]

    for cid, msgs in threads.items():
        if not msgs:
            continue
        c = contacts.get(cid, {"name": cid})
        fn = f"main_{cid}.md"
        (OUT / fn).write_text(render_main(cid, c, msgs, choices), encoding="utf-8")
        index.append(f"- [{c.get('emoji','')} {c.get('name',cid)}](./{fn}) "
                     f"— {len(msgs)} msg")

    # Arcs & romances
    arc_md = ["# Arcs Messages secondaires", ""]
    rom_md = ["# Romances (Tinder / arcs amoureux)", ""]
    for arc in arcs:
        block = render_arc(arc)
        if "romance/" in arc["file"]:
            rom_md.append(block)
        else:
            arc_md.append(block)
    (OUT / "arcs.md").write_text("\n".join(arc_md), encoding="utf-8")
    (OUT / "romance.md").write_text("\n".join(rom_md), encoding="utf-8")
    index += ["", "## Arcs & romances", "",
              f"- [Arcs secondaires](./arcs.md) — {sum(1 for a in arcs if 'romance/' not in a['file'])} arcs",
              f"- [Romances](./romance.md) — {sum(1 for a in arcs if 'romance/' in a['file'])} arcs"]

    # Incohérences
    flags = scan_incoherences(threads, choices, arcs)
    inc = ["# Passe heuristique d'incohérences", "",
           f"{len(flags)} signalement(s). Heuristique = indices, pas vérités.",
           ""]
    inc += [f"- {f}" for f in flags] if flags else ["Aucun signalement automatique."]
    (OUT / "_incoherences.md").write_text("\n".join(inc), encoding="utf-8")
    index += ["", "## Analyse", "", f"- [Incohérences heuristiques](./_incoherences.md) — {len(flags)} signalement(s)"]

    (OUT / "README.md").write_text("\n".join(index), encoding="utf-8")

    print(f"OK — {len(threads)} fils principaux, {len(arcs)} arcs, "
          f"{len(flags)} signalements heuristiques.")
    print(f"→ {OUT.relative_to(ROOT)}/README.md")


if __name__ == "__main__":
    main()
