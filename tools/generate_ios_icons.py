#!/usr/bin/env python3
"""Generate iOS AppIcon set from assets/icon/icon.png. Mirrors what
`dart run flutter_launcher_icons` would write — useful when we want the
icons in-repo without waiting on a Flutter toolchain."""
import json
from pathlib import Path
from PIL import Image

SRC = Path("assets/icon/icon.png")
OUT_DIR = Path("ios/Runner/Assets.xcassets/AppIcon.appiconset")

# (filename, size_in_pixels)
TARGETS = [
    ("Icon-App-20x20@1x.png", 20),
    ("Icon-App-20x20@2x.png", 40),
    ("Icon-App-20x20@3x.png", 60),
    ("Icon-App-29x29@1x.png", 29),
    ("Icon-App-29x29@2x.png", 58),
    ("Icon-App-29x29@3x.png", 87),
    ("Icon-App-40x40@1x.png", 40),
    ("Icon-App-40x40@2x.png", 80),
    ("Icon-App-40x40@3x.png", 120),
    ("Icon-App-60x60@2x.png", 120),
    ("Icon-App-60x60@3x.png", 180),
    ("Icon-App-76x76@1x.png", 76),
    ("Icon-App-76x76@2x.png", 152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("Icon-App-1024x1024@1x.png", 1024),
]


def main() -> None:
    src = Image.open(SRC).convert("RGB")
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for name, size in TARGETS:
        img = src.resize((size, size), Image.LANCZOS)
        out_path = OUT_DIR / name
        img.save(out_path, format="PNG", optimize=True)
        print(f"  {name}: {size}x{size}")
    print(f"Wrote {len(TARGETS)} icon files to {OUT_DIR}")


if __name__ == "__main__":
    main()
