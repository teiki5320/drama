# Musique — la playlist de Shen

> L'app « Musique » du téléphone : le joueur choisit un morceau, il tourne
> en boucle discrète pendant qu'il lit. Les titres existent dans la fiction —
> c'est la playlist de Shen.

## Convention

- Fichiers : `assets/audio/<nom>.mp3` — **exactement les noms ci-dessous**.
- Instrumental uniquement, 2 à 3 minutes, pensé pour boucler (pas de fin
  brutale, pas de montée finale), volume homogène et doux (c'est un fond).
- Export mp3 192 kbps suffit.
- Dès que les fichiers sont commités, l'app Musique est branchée
  (icône sur l'accueil, choix persistant, bouton couper).

## Les cinq morceaux

| Fichier | Rôle dans le jeu | Prompt (Suno/Udio) |
|---|---|---|
| ~~`pluie_sur_belleville.mp3`~~ ✅ reçu (« dawn in the rain », 3 min 28) | Le thème principal — l'accueil, les matins | *lofi piano, gentle rain ambience, melancholic but warm, slow tempo 70 bpm, vinyl crackle, soft tape saturation, small Paris apartment at dawn, instrumental, no vocals, seamless loop, subtle* |
| ~~`nuit_blanche.mp3`~~ ✅ reçu (« midnight static », 3 min 29) | Les soirs de doute (diagnostic, la réponse à Tristan) | *ambient neo-classical, felt piano, sparse notes, distant city hum at night, quiet tension, minor key, slow string swells far in the background, instrumental, no vocals, seamless loop* |
| ~~`fujian.mp3`~~ ✅ reçu (« dawn over rice terraces », 3 min 42) | Les souvenirs de Chine, le passé du père | *guzheng and soft felt piano duet, chinese traditional meets lofi, nostalgic, rice terraces at dawn, gentle and spacious, instrumental, no vocals, seamless loop* |
| `quarante_septieme_etage.mp3` | L'univers Heng — tours, marbre, argent | *minimal electronic pulse, cold marble lobby ambience, quiet luxury tension, deep soft sub bass, sparse piano notes, cinematic restraint, instrumental, no vocals, seamless loop* |
| `deux_sucres.mp3` | Camille — les cafés, la légèreté | *upbeat mellow lofi jazz, brushed drums, rhodes piano, parisian café morning, warm and playful, light swing, instrumental, no vocals, seamless loop* |

## Après

- L'app laisse toujours le choix au joueur (jamais de musique imposée).
- Plus tard, les scripts pourront *suggérer* un morceau aux moments clés
  (une ligne « 🎵 » discrète), sans forcer.
