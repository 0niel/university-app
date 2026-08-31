"""Generate Mirea Ninja brand source images (app icon + splash logo).

Single source of truth for the launcher-icon / splash artwork, matching the
design's `AppIcon`: a 160deg blue gradient face (#4D94FF -> #2F7AFF -> #1F5CDB)
with the canonical 4-point shuriken (the `AppNinjaMark` path) in white.

Outputs land in `assets/` and are consumed by `flutter_launcher_icons`
(pubspec) and `flutter_native_splash` (flutter_native_splash.yaml). Re-run with:

    python tool/generate_brand_assets.py

Then regenerate the platform assets:

    fvm dart run flutter_launcher_icons
    fvm dart run flutter_native_splash:create
"""

import math
import os

from PIL import Image, ImageDraw

ASSETS = os.path.join(os.path.dirname(__file__), "..", "assets")

# Gradient stops (160deg) and the shuriken geometry (32x32 design viewBox,
# tip-to-tip span is 28: x in [2, 30]).
ANGLE = 160
STOPS = [(0.0, (0x4D, 0x94, 0xFF)), (0.5, (0x2F, 0x7A, 0xFF)), (1.0, (0x1F, 0x5C, 0xDB))]
POINTS = [(16, 2), (19, 13), (30, 16), (19, 19), (16, 30), (13, 19), (2, 16), (13, 13)]
WHITE = (255, 255, 255, 255)


def _lerp(a, b, t):
    return tuple(round(a[i] + (b[i] - a[i]) * t) for i in range(3))


def _grad_color(t):
    t = max(0.0, min(1.0, t))
    for i in range(len(STOPS) - 1):
        t0, c0 = STOPS[i]
        t1, c1 = STOPS[i + 1]
        if t <= t1:
            return _lerp(c0, c1, (t - t0) / (t1 - t0) if t1 > t0 else 0.0)
    return STOPS[-1][1]


def gradient(size):
    """Render the 160deg gradient. Computed small then upscaled — a linear
    gradient resamples perfectly, so this stays fast and smooth."""
    small = 256
    a = math.radians(ANGLE)
    dx, dy = math.sin(a), -math.cos(a)
    projections = [cx * dx + cy * dy for cx in (0, 1) for cy in (0, 1)]
    pmin, pmax = min(projections), max(projections)
    img = Image.new("RGB", (small, small))
    px = img.load()
    for yy in range(small):
        for xx in range(small):
            p = (xx / (small - 1)) * dx + (yy / (small - 1)) * dy
            px[xx, yy] = _grad_color((p - pmin) / (pmax - pmin))
    return img.resize((size, size), Image.LANCZOS)


def shuriken(size, width, color=WHITE):
    """A centred, anti-aliased (4x supersampled) shuriken layer of the given
    tip-to-tip `width` on a transparent `size`x`size` canvas."""
    ss = 4
    s = size * ss
    layer = Image.new("RGBA", (s, s), (0, 0, 0, 0))
    scale = (width * ss) / 28.0
    cx = cy = s / 2
    pts = [((x - 16) * scale + cx, (y - 16) * scale + cy) for x, y in POINTS]
    ImageDraw.Draw(layer).polygon(pts, fill=color)
    return layer.resize((size, size), Image.LANCZOS)


def _save(img, name):
    path = os.path.normpath(os.path.join(ASSETS, name))
    img.save(path)
    print("wrote", os.path.relpath(path), img.size, img.mode)


def main():
    os.makedirs(ASSETS, exist_ok=True)
    size = 1024

    # Full launcher icon (iOS + Android legacy): gradient face + 60% shuriken.
    icon = gradient(size).convert("RGBA")
    icon.alpha_composite(shuriken(size, round(size * 0.60)))
    _save(icon.convert("RGB"), "icon.png")

    # Android adaptive background — gradient, full-bleed.
    _save(gradient(size), "icon_background.png")

    # Android adaptive foreground / monochrome. flutter_launcher_icons wraps
    # these in a 16% inset (drawable -> 68% of the face), so the shuriken is
    # drawn large here (0.84) to land at ~0.57 of the face after the inset,
    # matching the design's ~60% face coverage while staying in the safe zone.
    fg = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    fg.alpha_composite(shuriken(size, round(size * 0.84)))
    _save(fg, "icon_foreground.png")
    _save(fg.copy(), "icon_monochrome.png")

    # Splash logo (legacy Android + iOS): a tight white shuriken.
    sp = Image.new("RGBA", (560, 560), (0, 0, 0, 0))
    sp.alpha_composite(shuriken(560, round(560 * 0.92)))
    _save(sp, "splash_logo.png")

    # Splash logo (Android 12+): 1152 canvas, shuriken within the 768 circle.
    sp12 = Image.new("RGBA", (1152, 1152), (0, 0, 0, 0))
    sp12.alpha_composite(shuriken(1152, 640))
    _save(sp12, "splash_logo_android12.png")


if __name__ == "__main__":
    main()
