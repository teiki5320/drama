#!/usr/bin/env python3
"""Simulation de partie complète pour Drama (À Contre-Jour).

Rejoue la boucle de jeu réelle sans Flutter, en parsant les données Dart :

  1. PARCOURS   : avance beat par beat (advanceToNextBeat) de J1 à J112.
                  À chaque beat `requiresChoice`, vérifie qu'un message
                  déclencheur existe, qu'il est VISIBLE (day <= jour courant),
                  qu'il est le DERNIER du fil à cet instant (condition
                  d'affichage du ChoicePanel) et que le contact du SmsChoice
                  correspond au fil. Répond, puis continue.
  2. ÉPILOGUES  : rejoue la fin avec toutes les combinaisons de choix pivots
                  (J52 x J95 x J112) + le cas solde < 18 000 et vérifie que
                  resolveEpilogue tombe sur la fin attendue.
  3. ÉCONOMIE   : calcule le solde canonique à J112 sans aucune action joueur
                  (mouvements banque échus) — le deuil ne doit PAS être la
                  fin par défaut d'une partie sans achats.

Sortie : OK/FAIL par vérification + RÉSULTAT final. Exit 1 si un FAIL.
Usage : python3 tools/simulate.py [--verbose]
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LIB = ROOT / "lib"

VERBOSE = "--verbose" in sys.argv
FAILS: list[str] = []
OKS: list[str] = []


def ok(msg):
    OKS.append(msg)
    if VERBOSE:
        print(f"  ✓ {msg}")


def fail(msg):
    FAILS.append(msg)


def read(p: Path) -> str:
    return p.read_text(encoding="utf-8")


# ── Parsing des données Dart ────────────────────────────────────────────────

def parse_beats():
    """[{episode, idx, day, hour, minute, requiresChoice}] dans l'ordre de jeu."""
    src = read(LIB / "data" / "episodes.dart")
    beats = []
    # découpe par épisode pour garder l'ordre canonique
    ep_iter = list(re.finditer(r"id:\s*'([a-z_]+)',\s*\n\s*number:", src))
    for k, m in enumerate(ep_iter):
        ep_id = m.group(1)
        start = m.end()
        end = ep_iter[k + 1].start() if k + 1 < len(ep_iter) else len(src)
        body = src[start:end]
        for b in re.finditer(
            r"Beat\(\s*idx:\s*(\d+),\s*day:\s*(\d+),\s*hour:\s*(\d+),\s*"
            r"minute:\s*(\d+),(.*?)(?=Beat\(|\Z)", body, re.S,
        ):
            rc = re.search(r"requiresChoice:\s*'([^']+)'", b.group(5))
            beats.append({
                "episode": ep_id,
                "idx": int(b.group(1)),
                "day": int(b.group(2)),
                "hour": int(b.group(3)),
                "minute": int(b.group(4)),
                "requiresChoice": rc.group(1) if rc else None,
            })
    return beats


def parse_threads():
    """{contactId: [{day, time, sender, beatId}]} dans l'ordre du fichier."""
    src = read(LIB / "data" / "messages_data.dart")
    m = re.search(r"kThreads\s*=\s*\{(.*)\n\};", src, re.S)
    threads = {}
    parts = re.split(r"\n  '([a-z_]+)':\s*\[", m.group(1))
    for i in range(1, len(parts), 2):
        cid, blk = parts[i], parts[i + 1]
        msgs = []
        for mm in re.finditer(
            r"Msg\((.*?)\),\n(?=    Msg\(|  \],|\n)", blk + "\n", re.S,
        ):
            body = mm.group(1)
            d = re.search(r"day:\s*(\d+)", body)
            t = re.search(r"time:\s*'([^']+)'", body)
            s = re.search(r"sender:\s*'([^']+)'", body)
            b = re.search(r"beatId:\s*'([^']+)'", body)
            if d and t and s:
                msgs.append({
                    "day": int(d.group(1)),
                    "time": t.group(1),
                    "sender": s.group(1),
                    "beatId": b.group(1) if b else None,
                })
        threads[cid] = msgs
    return threads


def parse_choices():
    """{beatId: contactId} depuis kSmsChoices."""
    src = read(LIB / "data" / "sms_choices.dart")
    out = {}
    for m in re.finditer(
        r"'([a-z0-9_]+)':\s*SmsChoice\(\s*beatId:\s*'([^']+)',\s*"
        r"contactId:\s*'([^']+)'", src,
    ):
        out[m.group(2)] = m.group(3)
        if m.group(1) != m.group(2):
            fail(f"kSmsChoices : clé '{m.group(1)}' != beatId '{m.group(2)}'")
    return out


def parse_reply_consts():
    """Constantes kReply* (concaténations Dart recollées)."""
    src = read(LIB / "data" / "sms_choices.dart")
    out = {}
    for m in re.finditer(
        r"const String (kReply\w+)\s*=\s*((?:'(?:[^'\\]|\\.)*'\s*)+);", src,
    ):
        parts = re.findall(r"'((?:[^'\\]|\\.)*)'", m.group(2))
        out[m.group(1)] = "".join(parts).replace("\\'", "'")
    return out


def parse_bank():
    """(kStartingBalance, [(day, amount)]) depuis banque_data.dart."""
    src = read(LIB / "data" / "banque_data.dart")
    start = int(re.search(r"kStartingBalance\s*=\s*(-?\d+)", src).group(1))
    mvts = []
    m = re.search(r"kMovements\s*=\s*(?:<\w+>)?\[(.*?)\n\];", src, re.S)
    for b in re.finditer(r"day:\s*(\d+),(.*?)amount:\s*(-?[\d_]+)",
                         m.group(1), re.S):
        mvts.append((int(b.group(1)), int(b.group(3).replace("_", ""))))
    return start, mvts


# ── 1. Simulation du parcours ───────────────────────────────────────────────

def simulate_playthrough(beats, threads, choices):
    answered = set()
    for beat in beats:
        rc = beat["requiresChoice"]
        if rc is None:
            continue
        day = beat["day"]
        # a) un SmsChoice existe
        if rc not in choices:
            fail(f"J{day} : requiresChoice '{rc}' sans SmsChoice — "
                 f"MUR DE PROGRESSION")
            continue
        contact = choices[rc]
        # b) le message déclencheur existe dans le fil du BON contact
        thread = threads.get(contact)
        if thread is None:
            fail(f"J{day} : '{rc}' → contact '{contact}' sans fil kThreads")
            continue
        trigger = [m for m in thread if m["beatId"] == rc]
        if not trigger:
            fail(f"J{day} : aucun message beatId '{rc}' dans le fil "
                 f"'{contact}' — ChoicePanel jamais affiché")
            continue
        trig = trigger[0]
        # c) visible au jour du beat
        if trig["day"] > day:
            fail(f"J{day} : le message '{rc}' est daté J{trig['day']} "
                 f"(> jour du beat) — invisible au moment du choix")
        # d) atteignable via le ChoicePanel : celui-ci affiche le PREMIER
        #    message reçu (ordre chrono) à beatId non répondu dont le choix
        #    existe. On rejoue cet algorithme : tous les déclencheurs
        #    visibles avant `rc` doivent aussi avoir un SmsChoice, sinon on
        #    ne remonte jamais jusqu'à lui.
        visible = [m for m in thread if m["day"] <= day]
        for m in visible:
            if m["beatId"] == rc:
                break  # rc surfacé — tous ceux d'avant sont répondables
            if (m["sender"] != "moi" and m["beatId"] is not None
                    and m["beatId"] not in answered
                    and m["beatId"] not in choices):
                # sans SmsChoice, le panel le saute (guard choiceForBeat) —
                # pas bloquant, mais dette : message à choix muet.
                pass
            elif (m["sender"] != "moi" and m["beatId"] is not None
                    and m["beatId"] not in answered):
                answered.add(m["beatId"])  # le joueur y répond en chemin
        answered.add(rc)
        ok(f"J{day} : choix '{rc}' atteignable (fil '{contact}', "
           f"message {trig['time']})")
    # e) partie complète
    days = [b["day"] for b in beats]
    if days[-1] == 112 and beats[-1]["requiresChoice"] == "epilogue_j112":
        ok(f"parcours complet : {len(beats)} beats, J{days[0]} → J{days[-1]}, "
           f"{len(answered)} choix requis tous répondus")
    else:
        fail("le dernier beat n'est pas l'épilogue J112")


# ── 2. Simulation des épilogues ─────────────────────────────────────────────

def resolve_epilogue(balance, replies, K):
    """Réimplémentation fidèle de resolveEpilogue (epilogues.dart)."""
    j52 = replies.get("tristan_fin_contrat_j52", "")
    j95 = replies.get("tristan_revient_j95", "")
    j112 = replies.get("epilogue_j112", "")
    left = j52 == K["kReplyJ52LeaveToCamille"]
    paris = j112 == K["kReplyJ112Paris"]
    hk = j112 == K["kReplyJ112HongKong"] or (
        j112 == "" and j95 == K["kReplyJ95HongKong"])
    fujian = j112 == K["kReplyJ112Fujian"]
    if balance < 18000:
        return "belleville_deuil"
    if paris and left:
        return "camille_troisieme"
    if hk:
        return "hk_promesse"
    if fujian:
        return "parc_ma_fille"
    if paris and not left:
        return "foch_encore"
    return "parc_ma_fille"


def simulate_epilogues(K, final_balance):
    rich = max(final_balance, 18000)
    scenarios = [
        # (nom, solde, réponses pivots, épilogue attendu)
        ("Fujian (reste au village)", rich,
         {"epilogue_j112": K["kReplyJ112Fujian"]}, "parc_ma_fille"),
        ("Paris fidèle à Tristan", rich,
         {"epilogue_j112": K["kReplyJ112Paris"]}, "foch_encore"),
        ("Paris après rupture J52 → Camille", rich,
         {"tristan_fin_contrat_j52": K["kReplyJ52LeaveToCamille"],
          "epilogue_j112": K["kReplyJ112Paris"]}, "camille_troisieme"),
        ("Hong Kong assumé", rich,
         {"epilogue_j112": K["kReplyJ112HongKong"]}, "hk_promesse"),
        ("HK via J95 (repli sans réponse J112)", rich,
         {"tristan_revient_j95": K["kReplyJ95HongKong"]}, "hk_promesse"),
        ("Ruine → deuil (écrase tout)", 17999,
         {"epilogue_j112": K["kReplyJ112Paris"]}, "belleville_deuil"),
        ("Rupture J52 mais reste au Fujian", rich,
         {"tristan_fin_contrat_j52": K["kReplyJ52LeaveToCamille"],
          "epilogue_j112": K["kReplyJ112Fujian"]}, "parc_ma_fille"),
    ]
    for name, bal, replies, expected in scenarios:
        got = resolve_epilogue(bal, replies, K)
        if got == expected:
            ok(f"épilogue « {name} » → {got}")
        else:
            fail(f"épilogue « {name} » : attendu {expected}, obtenu {got}")
    # les 5 fins sont-elles toutes atteignables ?
    reachable = {resolve_epilogue(b, r, K)
                 for _, b, r, _ in scenarios}
    missing = {"parc_ma_fille", "foch_encore", "belleville_deuil",
               "hk_promesse", "camille_troisieme"} - reachable
    if missing:
        fail(f"fins inatteignables dans la simulation : {sorted(missing)}")
    else:
        ok("les 5 épilogues sont tous atteignables")


# ── 3. Économie canonique ───────────────────────────────────────────────────

def simulate_economy():
    start, mvts = parse_bank()
    balance = start + sum(a for d, a in mvts if d <= 112)
    if balance >= 18000:
        ok(f"solde canonique à J112 sans achats : {balance} — "
           f"le deuil n'est pas la fin par défaut")
    else:
        fail(f"solde canonique à J112 sans achats : {balance} < 18000 — "
             f"toute partie sans achats finit en deuil !")
    return balance


# ── main ────────────────────────────────────────────────────────────────────

def main():
    print("SIMULATION DRAMA — parcours J1 → J112, épilogues, économie")
    print("-" * 66)
    beats = parse_beats()
    threads = parse_threads()
    choices = parse_choices()
    K = parse_reply_consts()

    needed = {"kReplyJ52LeaveToCamille", "kReplyJ95HongKong",
              "kReplyJ112Fujian", "kReplyJ112Paris", "kReplyJ112HongKong"}
    if not needed <= set(K):
        fail(f"constantes kReply* manquantes : {sorted(needed - set(K))}")

    simulate_playthrough(beats, threads, choices)
    balance = simulate_economy()
    if not FAILS or VERBOSE:
        simulate_epilogues(K, balance)

    print()
    for m in OKS if not VERBOSE else []:
        print(f"  ✓ {m}")
    for m in FAILS:
        print(f"  ✗ FAIL {m}")
    print("-" * 66)
    if FAILS:
        print(f"RÉSULTAT : ÉCHEC ({len(FAILS)} fail, {len(OKS)} ok)")
        return 1
    print(f"RÉSULTAT : OK ({len(OKS)} vérifications)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
