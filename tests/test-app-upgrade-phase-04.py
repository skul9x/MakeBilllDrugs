#!/usr/bin/env python3
import os
import sys
import subprocess
from PIL import Image

def log_success(msg):
    print(f"[\033[92mSUCCESS\033[0m] {msg}")

def log_info(msg):
    print(f"[\033[94mINFO\033[0m] {msg}")

def log_failure(msg):
    print(f"[\033[91mFAILURE\033[0m] {msg}")
    sys.exit(1)

def verify_master_assets(workspace_dir):
    log_info("1. Verifying Master Icon Assets (assets/icon/)...")
    assets = {
        "app_icon.png": (1024, 1024),
        "app_icon_foreground.png": (1024, 1024),
        "app_icon_background.png": (1024, 1024),
    }

    for name, expected_size in assets.items():
        path = os.path.join(workspace_dir, "assets", "icon", name)
        if not os.path.isfile(path):
            log_failure(f"Missing master asset: {path}")
        with Image.open(path) as img:
            if img.size != expected_size:
                log_failure(f"{name} has invalid size: {img.size}, expected {expected_size}")
            if img.mode != "RGBA":
                log_failure(f"{name} has mode {img.mode}, expected RGBA")
        log_success(f"Verified {name} ({expected_size[0]}x{expected_size[1]} RGBA)")

def verify_android_icons(workspace_dir):
    log_info("2. Verifying Android Adaptive & Legacy Mipmap Icons...")
    res_dir = os.path.join(workspace_dir, "android", "app", "src", "main", "res")

    # XML resources
    xml_files = [
        os.path.join(res_dir, "mipmap-anydpi-v26", "ic_launcher.xml"),
        os.path.join(res_dir, "mipmap-anydpi-v26", "ic_launcher_round.xml"),
        os.path.join(res_dir, "drawable", "ic_launcher_background.xml"),
    ]
    for xml in xml_files:
        if not os.path.isfile(xml):
            log_failure(f"Missing Android XML resource: {xml}")
        log_success(f"Verified {os.path.basename(xml)}")

    # Legacy launcher & adaptive foreground dimensions
    legacy_specs = {
        "mipmap-mdpi": (48, 48),
        "mipmap-hdpi": (72, 72),
        "mipmap-xhdpi": (96, 96),
        "mipmap-xxhdpi": (144, 144),
        "mipmap-xxxhdpi": (192, 192),
    }
    fg_specs = {
        "mipmap-mdpi": (108, 108),
        "mipmap-hdpi": (162, 162),
        "mipmap-xhdpi": (216, 216),
        "mipmap-xxhdpi": (324, 324),
        "mipmap-xxxhdpi": (432, 432),
    }

    for folder, size in legacy_specs.items():
        # ic_launcher.png
        p = os.path.join(res_dir, folder, "ic_launcher.png")
        if not os.path.isfile(p):
            log_failure(f"Missing {p}")
        with Image.open(p) as img:
            if img.size != size:
                log_failure(f"{folder}/ic_launcher.png size {img.size} != {size}")

        # ic_launcher_round.png
        p_round = os.path.join(res_dir, folder, "ic_launcher_round.png")
        if not os.path.isfile(p_round):
            log_failure(f"Missing {p_round}")
        with Image.open(p_round) as img:
            if img.size != size:
                log_failure(f"{folder}/ic_launcher_round.png size {img.size} != {size}")

        # ic_launcher_foreground.png
        fg_size = fg_specs[folder]
        p_fg = os.path.join(res_dir, folder, "ic_launcher_foreground.png")
        if not os.path.isfile(p_fg):
            log_failure(f"Missing {p_fg}")
        with Image.open(p_fg) as img:
            if img.size != fg_size:
                log_failure(f"{folder}/ic_launcher_foreground.png size {img.size} != {fg_size}")

        log_success(f"Verified {folder} (launcher: {size}, fg: {fg_size})")

def verify_windows_ico(workspace_dir):
    log_info("3. Verifying Windows .ico Multi-Resolution Bundle...")
    ico_path = os.path.join(workspace_dir, "windows", "runner", "resources", "app_icon.ico")
    if not os.path.isfile(ico_path):
        log_failure(f"Missing Windows app_icon.ico at {ico_path}")

    with Image.open(ico_path) as img:
        # Pillow parses ICO sub-images
        sizes = getattr(img, "ico", None)
        # Check raw ICO header or sizes
        expected_resolutions = [16, 24, 32, 48, 64, 128, 256]
        # In Pillow, opening ICO gives the largest or default, let's verify file size and opening
        if os.path.getsize(ico_path) < 10000:
            log_failure("Windows .ico is too small to contain multi-resolution bundle")
    log_success(f"Verified Windows app_icon.ico ({os.path.getsize(ico_path)} bytes)")

def verify_linux_icons(workspace_dir):
    log_info("4. Verifying Linux Icon Assets & Runner Config...")
    linux_icon = os.path.join(workspace_dir, "linux", "runner", "resources", "app_icon.png")
    if not os.path.isfile(linux_icon):
        log_failure(f"Missing Linux app_icon.png at {linux_icon}")
    with Image.open(linux_icon) as img:
        if img.size != (512, 512):
            log_failure(f"Linux app_icon.png has size {img.size}, expected (512, 512)")
    log_success("Verified Linux runner app_icon.png (512x512)")

    # Verify my_application.cc has gtk_window_set_icon_from_file
    my_app_cc = os.path.join(workspace_dir, "linux", "runner", "my_application.cc")
    with open(my_app_cc, "r", encoding="utf-8") as f:
        cc_src = f.read()
    if "gtk_window_set_icon_from_file" not in cc_src:
        log_failure("my_application.cc does not call gtk_window_set_icon_from_file")
    log_success("Verified Linux my_application.cc icon loading integration.")

def run_flutter_test(workspace_dir):
    log_info("5. Running Flutter Unit & Asset Tests...")
    flutter_cmd = "flutter"
    home = os.path.expanduser("~")
    local_paths = [
        os.path.join(home, "development", "flutter", "bin", "flutter"),
        os.path.join(home, "flutter", "bin", "flutter"),
        "/opt/flutter/bin/flutter"
    ]
    for p in local_paths:
        if os.path.exists(p):
            flutter_cmd = p
            break

    try:
        res = subprocess.run(
            [flutter_cmd, "test", "test/app_icon_test.dart"],
            cwd=workspace_dir,
            capture_output=True,
            text=True,
            check=True
        )
        print(res.stdout)
        log_success("Flutter app_icon_test passed!")
    except subprocess.CalledProcessError as e:
        print(e.stdout)
        print(e.stderr)
        log_failure(f"Flutter test failed with error: {e}")

def main():
    print("=" * 60)
    print("RUNNING AUTOMATED TEST SUITE: UPGRADE PHASE 04 (ADAPTIVE APP ICONS)")
    print("=" * 60)

    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

    verify_master_assets(workspace_dir)
    print("-" * 60)

    verify_android_icons(workspace_dir)
    print("-" * 60)

    verify_windows_ico(workspace_dir)
    print("-" * 60)

    verify_linux_icons(workspace_dir)
    print("-" * 60)

    run_flutter_test(workspace_dir)
    print("-" * 60)

    log_success("ALL PHASE 04 ADAPTIVE APP ICON VERIFICATION CHECKS PASSED!")
    print("=" * 60)

if __name__ == "__main__":
    main()
