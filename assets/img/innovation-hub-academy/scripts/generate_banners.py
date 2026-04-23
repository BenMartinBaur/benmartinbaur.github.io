"""
Generate 7 Innovation Hub Academy banner images.
Style: Clean dark panels with abstract geometric elements on colored backgrounds.
No text, faces, or logos.
"""

from PIL import Image, ImageDraw, ImageFilter
import random
import math
import os

# Banner dimensions (wide header format)
WIDTH = 1500
HEIGHT = 420

# Output directory
OUT_DIR = os.path.join(os.path.dirname(__file__), "innovation-hub-academy")
os.makedirs(OUT_DIR, exist_ok=True)

# 7 color schemes inspired by the gradient palette and examples
COLOR_SCHEMES = [
    {
        "name": "golden-yellow",
        "bg": (245, 197, 24),
        "panel": (18, 22, 28),
        "accents": [(245, 197, 24), (255, 165, 0), (200, 150, 10), (180, 130, 5)],
    },
    {
        "name": "emerald-green",
        "bg": (72, 187, 120),
        "panel": (16, 24, 20),
        "accents": [(72, 187, 120), (56, 142, 60), (129, 199, 132), (85, 139, 47)],
    },
    {
        "name": "ocean-teal",
        "bg": (0, 188, 212),
        "panel": (12, 20, 28),
        "accents": [(0, 188, 212), (0, 150, 170), (77, 208, 225), (0, 96, 100)],
    },
    {
        "name": "royal-blue",
        "bg": (66, 133, 244),
        "panel": (14, 18, 30),
        "accents": [(66, 133, 244), (25, 80, 180), (100, 160, 255), (13, 71, 161)],
    },
    {
        "name": "vivid-purple",
        "bg": (156, 39, 176),
        "panel": (22, 14, 28),
        "accents": [(156, 39, 176), (186, 104, 200), (123, 31, 162), (224, 64, 251)],
    },
    {
        "name": "coral-pink",
        "bg": (255, 107, 107),
        "panel": (28, 16, 18),
        "accents": [(255, 107, 107), (255, 138, 128), (229, 57, 53), (255, 171, 145)],
    },
    {
        "name": "sunset-orange",
        "bg": (255, 152, 0),
        "panel": (26, 18, 12),
        "accents": [(255, 152, 0), (255, 111, 0), (255, 183, 77), (230, 81, 0)],
    },
]


def draw_gradient_bg(draw, width, height, color):
    """Fill background with a subtle radial gradient of the scheme color."""
    r, g, b = color
    for y in range(height):
        for x in range(width):
            # Subtle vignette: darken edges slightly
            dx = (x - width / 2) / (width / 2)
            dy = (y - height / 2) / (height / 2)
            dist = math.sqrt(dx * dx + dy * dy)
            factor = max(0.82, 1.0 - dist * 0.18)
            draw.point(
                (x, y),
                fill=(int(r * factor), int(g * factor), int(b * factor)),
            )


def draw_fast_gradient_bg(img, color):
    """Fast gradient background using resize trick."""
    r, g, b = color
    # Create small gradient then upscale
    small = Image.new("RGB", (32, 32), (r, g, b))
    draw_s = ImageDraw.Draw(small)
    for y in range(32):
        for x in range(32):
            dx = (x - 16) / 16
            dy = (y - 16) / 16
            dist = math.sqrt(dx * dx + dy * dy)
            factor = max(0.82, 1.0 - dist * 0.18)
            draw_s.point(
                (x, y),
                fill=(int(r * factor), int(g * factor), int(b * factor)),
            )
    bg = small.resize((WIDTH, HEIGHT), Image.LANCZOS)
    img.paste(bg)


def draw_rounded_rect(draw, bbox, radius, fill):
    """Draw a rounded rectangle."""
    x1, y1, x2, y2 = bbox
    draw.rounded_rectangle(bbox, radius=radius, fill=fill)


def draw_dashed_curve(draw, cx, cy, radius, start_angle, end_angle, color, width=2, dash_len=12, gap_len=8):
    """Draw a dashed arc/curve."""
    total_angle = end_angle - start_angle
    circumference = abs(total_angle) * radius * math.pi / 180
    step_angle = (dash_len / circumference) * total_angle if circumference > 0 else 1
    gap_angle = (gap_len / circumference) * total_angle if circumference > 0 else 1

    angle = start_angle
    drawing = True
    while angle < end_angle:
        if drawing:
            a1 = angle
            a2 = min(angle + step_angle, end_angle)
            # Draw small line segments for the dash
            pts = []
            steps = max(3, int(abs(a2 - a1) * 2))
            for i in range(steps + 1):
                a = math.radians(a1 + (a2 - a1) * i / steps)
                px = cx + radius * math.cos(a)
                py = cy + radius * math.sin(a)
                pts.append((px, py))
            for i in range(len(pts) - 1):
                draw.line([pts[i], pts[i + 1]], fill=color, width=width)
            angle += step_angle
        else:
            angle += gap_angle
        drawing = not drawing


def draw_dotted_line(draw, x1, y1, x2, y2, color, dot_radius=2, gap=12):
    """Draw a dotted line between two points."""
    dx = x2 - x1
    dy = y2 - y1
    length = math.sqrt(dx * dx + dy * dy)
    if length == 0:
        return
    steps = int(length / gap)
    for i in range(steps + 1):
        t = i / max(steps, 1)
        px = x1 + dx * t
        py = y1 + dy * t
        draw.ellipse(
            [px - dot_radius, py - dot_radius, px + dot_radius, py + dot_radius],
            fill=color,
        )


def draw_triangle(draw, cx, cy, size, color, rotation=0):
    """Draw a filled triangle."""
    pts = []
    for i in range(3):
        angle = math.radians(rotation + i * 120 - 90)
        px = cx + size * math.cos(angle)
        py = cy + size * math.sin(angle)
        pts.append((px, py))
    draw.polygon(pts, fill=color)


def draw_circle(draw, cx, cy, radius, fill=None, outline=None, width=1):
    """Draw a circle."""
    bbox = [cx - radius, cy - radius, cx + radius, cy + radius]
    draw.ellipse(bbox, fill=fill, outline=outline, width=width)


def draw_gradient_stripes(img, x1, y1, x2, y2, panel_color, accent_color, gap=5, direction="left"):
    """Draw vertical stripes with a horizontal gradient fade.
    
    Stripes are colored with the accent color and fade into the dark panel.
    direction: 'left' = bright on left fading right, 'right' = bright on right fading left,
               'center' = bright in center fading to edges.
    """
    draw = ImageDraw.Draw(img)
    pr, pg, pb = panel_color
    ar, ag, ab = accent_color
    stripe_width = int(x2 - x1)
    
    for x in range(int(x1), int(x2), gap):
        # Calculate horizontal gradient factor (0.0 = panel color, 1.0 = full accent)
        t = (x - x1) / max(stripe_width, 1)
        
        if direction == "left":
            # Bright on left, fading right
            factor = max(0, 1.0 - t * 1.3)
        elif direction == "right":
            # Bright on right, fading left
            factor = max(0, (t - 0.2) * 1.3)
            factor = min(1.0, max(0, factor))
        else:  # center
            # Bright in center, fading to edges
            factor = 1.0 - abs(t - 0.5) * 2.2
            factor = min(1.0, max(0, factor))
        
        # Blend: stripe is slightly lighter than panel, tinted with accent
        # At full factor: a rich but not overpowering accent tint
        intensity = factor * 0.35  # Max 35% accent blend for subtlety
        sr = int(pr + (ar - pr) * intensity)
        sg = int(pg + (ag - pg) * intensity)
        sb = int(pb + (ab - pb) * intensity)
        
        # Also add slight brightness lift for visible stripes
        brightness_lift = int(factor * 18)
        sr = min(255, sr + brightness_lift)
        sg = min(255, sg + brightness_lift)
        sb = min(255, sb + brightness_lift)
        
        draw.line([(x, int(y1)), (x, int(y2))], fill=(sr, sg, sb), width=1)


def generate_banner(scheme, index):
    """Generate one banner image."""
    random.seed(42 + index * 7)  # Deterministic but varied

    img = Image.new("RGB", (WIDTH, HEIGHT), scheme["bg"])

    # Fast gradient background
    draw_fast_gradient_bg(img, scheme["bg"])

    draw = ImageDraw.Draw(img)

    # Draw dark rounded panel in center
    panel_margin_x = 30
    panel_margin_y = 22
    panel_bbox = (
        panel_margin_x,
        panel_margin_y,
        WIDTH - panel_margin_x,
        HEIGHT - panel_margin_y,
    )
    draw_rounded_rect(draw, panel_bbox, radius=24, fill=scheme["panel"])

    # Add gradient vertical stripes inside panel (like the Finding Mastery examples)
    accents = scheme["accents"]
    
    # Each banner gets stripes in a different position/direction for variety
    stripe_configs = [
        {"x_offset": 200, "width": 500, "gap": 5, "direction": "center"},  # golden-yellow
        {"x_offset": 250, "width": 450, "gap": 5, "direction": "center"},  # emerald-green
        {"x_offset": 150, "width": 550, "gap": 4, "direction": "center"},  # ocean-teal (keep)
        {"x_offset": 300, "width": 500, "gap": 5, "direction": "center"},  # royal-blue
        {"x_offset": 180, "width": 480, "gap": 5, "direction": "center"},  # vivid-purple
        {"x_offset": 220, "width": 520, "gap": 4, "direction": "center"},  # coral-pink (keep)
        {"x_offset": 280, "width": 460, "gap": 5, "direction": "center"},  # sunset-orange
    ]
    sc = stripe_configs[index]
    stripe_x_start = panel_margin_x + sc["x_offset"]
    stripe_x_end = stripe_x_start + sc["width"]
    
    draw_gradient_stripes(
        img,
        stripe_x_start,
        panel_margin_y,
        stripe_x_end,
        HEIGHT - panel_margin_y,
        scheme["panel"],
        accents[0],
        gap=sc["gap"],
        direction=sc["direction"],
    )

    # --- Place geometric elements ---
    # Each banner gets a unique composition

    # Panel edges for anchoring dashed curves
    panel_top = panel_margin_y
    panel_bottom = HEIGHT - panel_margin_y
    panel_left = panel_margin_x
    panel_right = WIDTH - panel_margin_x

    if index == 0:
        # Large circle top-right, triangle bottom-left, dashed arc from bottom edge
        draw_circle(draw, 1150, 100, 55, fill=accents[0])
        draw_circle(draw, 1320, 280, 28, fill=(*accents[1][:3],))
        draw_triangle(draw, 350, 300, 40, accents[2], rotation=15)
        draw_triangle(draw, 420, 260, 22, accents[3], rotation=45)
        draw_dashed_curve(draw, 1100, panel_bottom, 200, -80, 10, accents[0], width=2)
        draw_circle(draw, 1400, 160, 12, fill=accents[2])
        draw_circle(draw, 250, 130, 8, fill=accents[0])
        draw_circle(draw, 680, 350, 6, outline=accents[1], width=2)

    elif index == 1:
        # Triangles cluster right, circles left, dashed curve from bottom border
        draw_triangle(draw, 1100, 180, 60, accents[0], rotation=0)
        draw_triangle(draw, 1180, 280, 45, accents[1], rotation=30)
        draw_triangle(draw, 1050, 300, 30, accents[2], rotation=-15)
        draw_circle(draw, 300, 150, 45, fill=accents[0])
        draw_circle(draw, 380, 280, 25, fill=accents[3])
        draw_dashed_curve(draw, 700, panel_bottom, 250, -140, -30, accents[1], width=2)
        draw_circle(draw, 1350, 120, 10, fill=accents[2])
        draw_circle(draw, 200, 340, 7, outline=accents[0], width=2)

    elif index == 2:
        # Concentric circles center-right, scattered triangles, arc from top border
        for r in [90, 65, 40]:
            draw_circle(draw, 1100, 210, r, outline=accents[0], width=2)
        draw_circle(draw, 1100, 210, 18, fill=accents[1])
        draw_triangle(draw, 350, 120, 35, accents[2], rotation=10)
        draw_triangle(draw, 450, 320, 25, accents[0], rotation=60)
        draw_dashed_curve(draw, 550, panel_top, 220, 10, 170, accents[3], width=2)
        draw_circle(draw, 1350, 100, 14, fill=accents[2])
        draw_circle(draw, 280, 250, 9, fill=accents[3])

    elif index == 3:
        # Clean composition: circles and triangles, dashed arc from right border
        draw_circle(draw, 1200, 140, 50, fill=accents[0])
        draw_circle(draw, 1050, 310, 30, fill=accents[2])
        draw_circle(draw, 1350, 260, 18, fill=accents[1])
        draw_triangle(draw, 350, 160, 45, accents[0], rotation=0)
        draw_triangle(draw, 450, 300, 30, accents[2], rotation=30)
        draw_triangle(draw, 280, 310, 20, accents[3], rotation=-20)
        draw_dashed_curve(draw, panel_right, 210, 220, 100, 260, accents[1], width=2)
        draw_dashed_curve(draw, 600, panel_top, 180, 20, 160, accents[3], width=2)
        draw_circle(draw, 700, 340, 12, fill=accents[0])
        draw_circle(draw, 900, 100, 8, outline=accents[2], width=2)

    elif index == 4:
        # Large ring left, triangles staircase right, dashed curve from bottom border
        draw_circle(draw, 300, 210, 80, outline=accents[0], width=3)
        draw_circle(draw, 300, 210, 60, outline=accents[1], width=2)
        draw_circle(draw, 300, 210, 20, fill=accents[2])
        for i in range(4):
            draw_triangle(
                draw,
                1000 + i * 90,
                300 - i * 50,
                25 + i * 5,
                accents[i % len(accents)],
                rotation=i * 20,
            )
        draw_dashed_curve(draw, 950, panel_bottom, 250, -110, -10, accents[0], width=2)
        draw_circle(draw, 1380, 340, 15, fill=accents[1])
        draw_circle(draw, 600, 320, 8, outline=accents[2], width=2)

    elif index == 5:
        # Scattered circles of various sizes, one large triangle, dotted paths
        sizes = [55, 35, 22, 15, 10, 8, 45, 30]
        positions = [
            (1100, 130), (1250, 250), (1350, 150), (1050, 330),
            (350, 100), (280, 280), (450, 200), (600, 330),
        ]
        for i, (pos, size) in enumerate(zip(positions, sizes)):
            c = accents[i % len(accents)]
            if i % 3 == 0:
                draw_circle(draw, pos[0], pos[1], size, fill=c)
            else:
                draw_circle(draw, pos[0], pos[1], size, outline=c, width=2)
        draw_triangle(draw, 750, 160, 50, accents[0], rotation=0)
        draw_dashed_curve(draw, 850, panel_bottom, 200, -160, -20, accents[1], width=2)

    elif index == 6:
        # Abstract wave: multiple dashed arcs, triangles as peaks
        for i in range(5):
            r = 150 + i * 40
            cx = 750 + i * 30
            cy = 210 + (i % 2) * 80
            draw_dashed_curve(
                draw, cx, cy, r, -60 + i * 10, 60 + i * 10,
                accents[i % len(accents)], width=2, dash_len=10, gap_len=6,
            )
        draw_triangle(draw, 350, 140, 35, accents[0], rotation=0)
        draw_triangle(draw, 1200, 280, 40, accents[1], rotation=180)
        draw_circle(draw, 250, 300, 18, fill=accents[2])
        draw_circle(draw, 1350, 130, 25, fill=accents[0])
        draw_circle(draw, 900, 100, 10, fill=accents[3])

    # Save
    filename = f"banner-{index + 1}-{scheme['name']}.png"
    filepath = os.path.join(OUT_DIR, filename)
    img.save(filepath, "PNG", quality=95)
    print(f"  ✓ {filename} ({WIDTH}x{HEIGHT})")
    return filepath


if __name__ == "__main__":
    print(f"Generating 7 Innovation Hub Academy banners...\n")
    paths = []
    for i, scheme in enumerate(COLOR_SCHEMES):
        path = generate_banner(scheme, i)
        paths.append(path)
    print(f"\nDone! All banners saved to: {OUT_DIR}")
