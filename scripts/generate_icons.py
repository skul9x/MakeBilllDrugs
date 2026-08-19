#!/usr/bin/env python3
import os
import math
from PIL import Image, ImageDraw, ImageFilter

def create_master_icons(assets_dir):
    os.makedirs(assets_dir, exist_ok=True)
    size = 1024

    # 1. Background image (1024x1024)
    # Deep navy gradient (#0F172A to #1E293B) with subtle radial cyan glow
    bg_img = Image.new("RGBA", (size, size), (15, 23, 42, 255))
    bg_draw = ImageDraw.Draw(bg_img)

    # Diagonal gradient
    for y in range(size):
        for x in range(size):
            ratio = (x + y) / (2.0 * size)
            # interpolate between #0F172A (15, 23, 42) and #1E293B (30, 41, 59)
            r = int(15 + (30 - 15) * ratio)
            g = int(23 + (41 - 23) * ratio)
            b = int(42 + (59 - 42) * ratio)
            # Center subtle neon glow
            dx = x - size / 2
            dy = y - size / 2
            dist = math.sqrt(dx * dx + dy * dy)
            if dist < 450:
                glow = (1.0 - dist / 450.0) * 0.25
                r = int(min(255, r + 0 * glow))
                g = int(min(255, g + 242 * glow))
                b = int(min(255, b + 254 * glow))
            bg_img.putpixel((x, y), (r, g, b, 255))

    bg_path = os.path.join(assets_dir, "app_icon_background.png")
    bg_img.save(bg_path, format="PNG")
    print(f"Saved: {bg_path}")

    # 2. Foreground layer (1024x1024 transparent)
    # Stored on transparent canvas with safe margins (432x432 safe zone centered in 1024 for adaptive icon)
    fg_img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    fg_draw = ImageDraw.Draw(fg_img)

    # We draw:
    # 1) A stylized glowing bill / invoice sheet with rounded corners
    # 2) A stylized medical capsule/cross in neon cyan (#00F2FE) and glass white/teal
    # Center is at (512, 512)

    # Bill base card (angled slightly or centered sleek rounded rect)
    # Bill rect: (320, 240) to (704, 784) -> size 384 x 544
    bill_left, bill_top, bill_right, bill_bottom = 330, 220, 694, 804
    card_radius = 48

    # Glassmorphism bill background (semi-transparent white/cyan)
    # Draw soft shadow first
    shadow_img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow_img)
    shadow_draw.rounded_rectangle(
        [bill_left - 10, bill_top + 20, bill_right + 10, bill_bottom + 30],
        radius=card_radius,
        fill=(0, 0, 0, 160)
    )
    shadow_img = shadow_img.filter(ImageFilter.GaussianBlur(radius=25))
    fg_img = Image.alpha_composite(fg_img, shadow_img)
    fg_draw = ImageDraw.Draw(fg_img)

    # Draw bill body
    bill_overlay = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    b_draw = ImageDraw.Draw(bill_overlay)
    b_draw.rounded_rectangle(
        [bill_left, bill_top, bill_right, bill_bottom],
        radius=card_radius,
        fill=(255, 255, 255, 38), # 15% opacity white glass
        outline=(0, 242, 254, 220), # Neon cyan border
        width=8
    )

    # Bill receipt lines
    line_x_start = bill_left + 50
    line_x_end = bill_right - 50
    
    # Header notch/lines
    b_draw.rounded_rectangle([line_x_start, bill_top + 50, bill_left + 150, bill_top + 66], radius=8, fill=(0, 242, 254, 255))
    b_draw.rounded_rectangle([bill_right - 140, bill_top + 50, line_x_end, bill_top + 66], radius=8, fill=(255, 255, 255, 180))

    # Divider
    b_draw.line([line_x_start, bill_top + 100, line_x_end, bill_top + 100], fill=(0, 242, 254, 100), width=4)

    # Medical Cross & Pill emblem in the center of bill
    # Cross center at (512, 470)
    cx, cy = 512, 470
    cross_arm_w = 42
    cross_arm_h = 140

    # Cross glow
    glow_img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    g_draw = ImageDraw.Draw(glow_img)
    g_draw.rounded_rectangle([cx - cross_arm_w//2, cy - cross_arm_h//2, cx + cross_arm_w//2, cy + cross_arm_h//2], radius=16, fill=(0, 242, 254, 255))
    g_draw.rounded_rectangle([cx - cross_arm_h//2, cy - cross_arm_w//2, cx + cross_arm_h//2, cy + cross_arm_w//2], radius=16, fill=(0, 242, 254, 255))
    glow_img = glow_img.filter(ImageFilter.GaussianBlur(radius=18))
    bill_overlay = Image.alpha_composite(bill_overlay, glow_img)
    b_draw = ImageDraw.Draw(bill_overlay)

    # Vertical bar of medical cross (Gradient cyan to teal)
    b_draw.rounded_rectangle(
        [cx - cross_arm_w//2, cy - cross_arm_h//2, cx + cross_arm_w//2, cy + cross_arm_h//2],
        radius=16,
        fill=(0, 242, 254, 255),
        outline=(255, 255, 255, 220),
        width=4
    )
    # Horizontal bar of medical cross
    b_draw.rounded_rectangle(
        [cx - cross_arm_h//2, cy - cross_arm_w//2, cx + cross_arm_h//2, cy + cross_arm_w//2],
        radius=16,
        fill=(79, 172, 254, 255),
        outline=(255, 255, 255, 220),
        width=4
    )

    # Lower receipt detail lines (simulating drug prescription items & total)
    for idx, ly in enumerate([580, 620, 660]):
        width_ratio = 0.85 if idx % 2 == 0 else 0.65
        item_end = int(line_x_start + (line_x_end - line_x_start) * width_ratio)
        b_draw.rounded_rectangle([line_x_start, ly, item_end, ly + 14], radius=7, fill=(255, 255, 255, 140))

    # Total check badge at bottom of receipt
    b_draw.rounded_rectangle([line_x_start, 715, line_x_end, 755], radius=12, fill=(0, 242, 254, 50), outline=(0, 242, 254, 180), width=3)
    b_draw.rounded_rectangle([line_x_start + 20, 727, line_x_start + 120, 743], radius=6, fill=(0, 242, 254, 255))
    b_draw.rounded_rectangle([line_x_end - 100, 727, line_x_end - 20, 743], radius=6, fill=(255, 255, 255, 230))

    fg_img = Image.alpha_composite(fg_img, bill_overlay)

    fg_path = os.path.join(assets_dir, "app_icon_foreground.png")
    fg_img.save(fg_path, format="PNG")
    print(f"Saved: {fg_path}")

    # 3. Master App Icon (1024x1024 composite)
    master_img = Image.alpha_composite(bg_img, fg_img)
    master_path = os.path.join(assets_dir, "app_icon.png")
    master_img.save(master_path, format="PNG")
    print(f"Saved: {master_path}")

    return master_img, fg_img, bg_img

def generate_android_icons(workspace_dir, master_img, fg_img):
    res_dir = os.path.join(workspace_dir, "android", "app", "src", "main", "res")

    densities_legacy = {
        "mipmap-mdpi": (48, 48),
        "mipmap-hdpi": (72, 72),
        "mipmap-xhdpi": (96, 96),
        "mipmap-xxhdpi": (144, 144),
        "mipmap-xxxhdpi": (192, 192),
    }

    densities_foreground = {
        "mipmap-mdpi": (108, 108),
        "mipmap-hdpi": (162, 162),
        "mipmap-xhdpi": (216, 216),
        "mipmap-xxhdpi": (324, 324),
        "mipmap-xxxhdpi": (432, 432),
    }

    # Generate round mask for round icons
    def make_round(img):
        w, h = img.size
        mask = Image.new("L", (w, h), 0)
        draw = ImageDraw.Draw(mask)
        draw.ellipse((0, 0, w, h), fill=255)
        round_img = Image.new("RGBA", (w, h), (0, 0, 0, 0))
        round_img.paste(img, (0, 0), mask=mask)
        return round_img

    for folder, (w, h) in densities_legacy.items():
        out_dir = os.path.join(res_dir, folder)
        os.makedirs(out_dir, exist_ok=True)
        
        # Legacy square launcher
        resized = master_img.resize((w, h), Image.Resampling.LANCZOS)
        resized.save(os.path.join(out_dir, "ic_launcher.png"), format="PNG")
        
        # Legacy round launcher
        round_icon = make_round(resized)
        round_icon.save(os.path.join(out_dir, "ic_launcher_round.png"), format="PNG")

    for folder, (w, h) in densities_foreground.items():
        out_dir = os.path.join(res_dir, folder)
        os.makedirs(out_dir, exist_ok=True)
        
        # Adaptive foreground (scaled from 1024 fg_img)
        fg_resized = fg_img.resize((w, h), Image.Resampling.LANCZOS)
        fg_resized.save(os.path.join(out_dir, "ic_launcher_foreground.png"), format="PNG")

    print("Generated all Android legacy & adaptive icons.")

def generate_windows_ico(workspace_dir, master_img):
    win_res_dir = os.path.join(workspace_dir, "windows", "runner", "resources")
    os.makedirs(win_res_dir, exist_ok=True)
    ico_path = os.path.join(win_res_dir, "app_icon.ico")

    sizes = [(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)]
    master_img.save(ico_path, format="ICO", sizes=sizes)
    print(f"Saved multi-res Windows ICO: {ico_path} with sizes: {sizes}")

def generate_linux_icons(workspace_dir, master_img):
    linux_res_dir = os.path.join(workspace_dir, "linux", "runner", "resources")
    os.makedirs(linux_res_dir, exist_ok=True)
    linux_png = os.path.join(linux_res_dir, "app_icon.png")
    master_img.resize((512, 512), Image.Resampling.LANCZOS).save(linux_png, format="PNG")
    print(f"Saved Linux app_icon.png: {linux_png}")

def main():
    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    assets_dir = os.path.join(workspace_dir, "assets", "icon")

    print("Generating Master Icons...")
    master_img, fg_img, bg_img = create_master_icons(assets_dir)

    print("Generating Android Mipmaps...")
    generate_android_icons(workspace_dir, master_img, fg_img)

    print("Generating Windows ICO...")
    generate_windows_ico(workspace_dir, master_img)

    print("Generating Linux Icon Resources...")
    generate_linux_icons(workspace_dir, master_img)

    print("All icons successfully generated.")

if __name__ == "__main__":
    main()
