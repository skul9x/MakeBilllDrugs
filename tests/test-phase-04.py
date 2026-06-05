#!/usr/bin/env python3
import os
import sys
import subprocess
import re

def log_success(msg):
    print(f"[\033[92mSUCCESS\033[0m] {msg}")

def log_info(msg):
    print(f"[\033[94mINFO\033[0m] {msg}")

def log_failure(msg):
    print(f"[\033[91mFAILURE\033[0m] {msg}")
    sys.exit(1)

def check_file_exists(path):
    if not os.path.exists(path):
        log_failure(f"Required file does not exist: {path}")
    log_success(f"File exists: {path}")

def check_content(path, patterns):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    for label, pattern in patterns.items():
        if not re.search(pattern, content, re.IGNORECASE):
            log_failure(f"Missing {label} in {os.path.basename(path)}")
        log_success(f"Verified {label} exists in {os.path.basename(path)}")

def run_ui_widget_tests(workspace_dir):
    log_info("Running Flutter widget tests for UI components...")
    
    # Locate flutter command
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
            [flutter_cmd, "test", "test/ui_widget_test.dart"],
            cwd=workspace_dir,
            capture_output=True,
            text=True,
            check=True
        )
        print(res.stdout)
        log_success("All UI widget tests passed successfully!")
    except subprocess.CalledProcessError as e:
        print(e.stdout)
        print(e.stderr)
        log_failure(f"UI widget tests failed with error: {e}")

def main():
    print("=" * 60)
    print("RUNNING AUTOMATED FLUTTER PHASE 04 FRONTEND UI TEST SUITE")
    print("=" * 60)
    
    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    
    theme_dart = os.path.join(workspace_dir, "lib", "core", "theme.dart")
    dashboard_dart = os.path.join(workspace_dir, "lib", "views", "dashboard_page.dart")
    glass_card_dart = os.path.join(workspace_dir, "lib", "views", "widgets", "glass_card.dart")
    toast_dart = os.path.join(workspace_dir, "lib", "views", "widgets", "toast_overlay.dart")
    qty_dart = os.path.join(workspace_dir, "lib", "views", "widgets", "quantity_selector.dart")
    widget_test_dart = os.path.join(workspace_dir, "test", "ui_widget_test.dart")
    
    print("Checking UI files existence...")
    check_file_exists(theme_dart)
    check_file_exists(dashboard_dart)
    check_file_exists(glass_card_dart)
    check_file_exists(toast_dart)
    check_file_exists(qty_dart)
    check_file_exists(widget_test_dart)
    print("-" * 60)
    
    print("Verifying theme styling code...")
    theme_patterns = {
        "Outfit Google Font": r"Outfit",
        "Inter Google Font": r"Inter",
        "Translucent colors or BackdropFilter references": r"Color|Backdrop|blur"
    }
    check_content(theme_dart, theme_patterns)
    print("-" * 60)
    
    print("Verifying GlassCard implementation...")
    glass_patterns = {
        "BackdropFilter widget": r"BackdropFilter",
        "ImageFilter.blur": r"ImageFilter\.blur",
        "Translucent background styling": r"color.*?opacity|withOpacity"
    }
    check_content(glass_card_dart, glass_patterns)
    print("-" * 60)
    
    print("Verifying Toast system code...")
    toast_patterns = {
        "OverlayEntry or standard Flutter toast triggers": r"OverlayEntry|Overlay|toast|toastState",
        "SlideTransition or FadeTransition animations": r"Transition|AnimationController"
    }
    check_content(toast_dart, toast_patterns)
    print("-" * 60)
    
    print("Verifying Dashboard layout code...")
    dashboard_patterns = {
        "Live reactive list / state hooks": r"ListView|Table|DataTable|stt",
        "Scraper/Excel action bindings": r"extract|generateExcel|importExcel"
    }
    check_content(dashboard_dart, dashboard_patterns)
    print("-" * 60)
    
    # Run widget tests
    run_ui_widget_tests(workspace_dir)
    print("-" * 60)
    
    log_success("ALL PHASE 04 FRONTEND UI VERIFICATION CHECKS PASSED!")
    print("=" * 60)

if __name__ == "__main__":
    main()
