# ROADMAP — Drama

## L'objectif du jeu

Un jeu narratif qui se joue **exclusivement dans une messagerie de téléphone**.

Le joueur ouvre une app qui ressemble à Messages. Toute l'histoire passe par
les conversations : des personnages lui écrivent, il répond en choisissant
parmi des réponses proposées, et ses choix font avancer l'histoire.

**Rien d'autre.** Pas d'autres applis, pas de faux téléphone complet, pas de
mini-jeux. Une seule surface : les conversations.

## Les principes (garde-fous)

1. **Simple avant tout.** Si une fonctionnalité n'est pas indispensable pour
   raconter l'histoire, on ne la fait pas.
2. **Tout arrive dans la messagerie.** L'histoire s'explique d'elle-même par
   les messages, dans l'ordre, au bon moment. Jamais d'information hors des
   conversations.
3. **Les messages arrivent naturellement.** Un par un, avec le « en train
   d'écrire… », jamais en bloc.
4. **Le joueur sait toujours quoi faire.** À tout instant, il voit clairement
   quelle conversation attend sa réponse.
5. **On construit ensemble.** Chaque étape est décidée avec l'auteur avant
   d'être développée.

## Ce qu'on garde de l'ancien projet

- Les **227 images** dans `assets/` (photos, avatars, références personnages).
- L'univers de l'ancienne histoire (Shen, les Heng), **repris et retravaillé
  avec l'auteur** en juillet 2026 — la nouvelle version fait foi :
  voir `docs/HISTOIRE.md`. L'ancien code, lui, reste enterré dans l'historique.

## Étapes (à remplir ensemble)

- [x] Définir l'histoire : qui écrit au joueur, quel est l'enjeu, comment ça finit. → `docs/HISTOIRE.md`
- [x] Maquette d'une conversation (l'écran unique du jeu). → `maquette/conversation.html`
- [x] Prototype jouable : une journée d'histoire, des fils, des choix.
  → **l'app Flutter** (`lib/`) : le prologue (jour 1), testé (`flutter analyze` + `flutter test`).
  La version web de repérage reste dans `prototype/prologue.html`.
- [ ] Étendre l'histoire, tester, ajuster.
- [ ] Publier sur TestFlight → prêt : pousser sur la branche que Xcode Cloud surveille
  (le script `ios/ci_scripts/ci_post_clone.sh` installe Flutter 3.27.4 et gère le build).
