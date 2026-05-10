#!/usr/bin/env python3
"""Generate the placeholder app icon (1024x1024, no alpha) from the project's
visual identity: paper-cream background with the character 逆 in warm orange.
This is a *placeholder* — drop a custom 1024x1024 PNG at the same path to
override it."""

from PIL import Image, ImageDraw, ImageFont

OUT = "assets/icon/icon.png"
SIZE = 1024
BG = (251, 247, 239)        # #FBF7EF papier crème
ACCENT = (217, 119, 87)     # #D97757 orange chaud
GLYPH = "逆"            # 逆

# WenQuanYi Zen Hei has solid Han glyph coverage and ships on Debian.
FONT_PATH = "/usr/share/fonts/truetype/wqy/wqy-zenhei.ttc"
FONT_SIZE = 760


def main() -> None:
    img = Image.new("RGB", (SIZE, SIZE), BG)
    draw = ImageDraw.Draw(img)
    font = ImageFont.truetype(FONT_PATH, FONT_SIZE)

    # Compute the glyph's true bounding box, then center it on the canvas.
    bbox = draw.textbbox((0, 0), GLYPH, font=font)
    glyph_w = bbox[2] - bbox[0]
    glyph_h = bbox[3] - bbox[1]
    x = (SIZE - glyph_w) // 2 - bbox[0]
    y = (SIZE - glyph_h) // 2 - bbox[1]

    draw.text((x, y), GLYPH, font=font, fill=ACCENT)

    img.save(OUT, format="PNG", optimize=True)
    print(f"Wrote {OUT} ({SIZE}x{SIZE})")


if __name__ == "__main__":
    main()
