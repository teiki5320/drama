#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Garde-fou de build « pauvre » pour Drama, sans compilateur Dart.

L'environnement web n'a pas Flutter/Dart : `tools/audit.py` valide les
données mais laisse passer un Dart incompilable (c'est ainsi qu'un bloc
`instaPosts` mal imbriqué est parti sur `main`). Ce script attrape les
erreurs de structure les plus courantes SANS compiler :

  1. Équilibre des délimiteurs () [] {} par fichier (hors chaînes/commentaires).
  2. Chaînes ' " non fermées en fin de ligne (le style du repo n'utilise
     jamais de littéral multi-ligne — une chaîne ouverte = une faute).
  3. Chaque `import '...';` de fichier du projet pointe vers un fichier
     existant (les imports package: sont ignorés).

Sortie : liste des problèmes + RÉSULTAT. Exit 1 si au moins un problème.
À lancer avant chaque PR, avec audit.py / simulate.py / test_audit.py.
"""
from __future__ import annotations

import glob
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
PAIRS = {")": "(", "]": "[", "}": "{"}
OPEN = set("([{")


def scan(path: str):
    src = open(path, encoding="utf-8").read()
    problems = []
    stack = []
    in_str = None
    in_line_comment = False
    in_block_comment = False
    line = 1
    i, n = 0, len(src)
    while i < n:
        c = src[i]
        nxt = src[i + 1] if i + 1 < n else ""
        if c == "\n":
            line += 1
            in_line_comment = False
            if in_str is not None:
                problems.append(f"{path}:{line - 1}: chaîne {in_str} non fermée")
                in_str = None
            i += 1
            continue
        if in_line_comment:
            i += 1
            continue
        if in_block_comment:
            if c == "*" and nxt == "/":
                in_block_comment = False
                i += 2
                continue
            i += 1
            continue
        if in_str is not None:
            if c == "\\":
                i += 2
                continue
            if c == in_str:
                in_str = None
            i += 1
            continue
        # hors chaîne / commentaire
        if c == "/" and nxt == "/":
            in_line_comment = True
            i += 2
            continue
        if c == "/" and nxt == "*":
            in_block_comment = True
            i += 2
            continue
        if c in "'\"":
            in_str = c
            i += 1
            continue
        if c in OPEN:
            stack.append((c, line))
        elif c in PAIRS:
            if not stack or stack[-1][0] != PAIRS[c]:
                problems.append(f"{path}:{line}: '{c}' sans ouvrant correspondant")
            elif stack:
                stack.pop()
        i += 1
    for ch, ln in stack:
        problems.append(f"{path}:{ln}: '{ch}' jamais refermé")
    # imports projet
    for m in re.finditer(r"import\s+'([^']+)'", src):
        imp = m.group(1)
        if imp.startswith("package:") or imp.startswith("dart:"):
            continue
        target = os.path.normpath(os.path.join(os.path.dirname(path), imp))
        if not os.path.exists(target):
            problems.append(f"{path}: import introuvable → {imp}")
    return problems


def main():
    files = sorted(glob.glob(os.path.join(ROOT, "lib", "**", "*.dart"),
                             recursive=True))
    all_problems = []
    for f in files:
        all_problems.extend(scan(f))
    for p in all_problems:
        print("FAIL " + os.path.relpath(p.split(":")[0], ROOT) +
              ":" + ":".join(p.split(":")[1:]) if ":" in p else p)
    print()
    if all_problems:
        print(f"RÉSULTAT : {len(all_problems)} problème(s) sur "
              f"{len(files)} fichiers")
        return 1
    print(f"RÉSULTAT : OK ({len(files)} fichiers Dart, structure saine)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
