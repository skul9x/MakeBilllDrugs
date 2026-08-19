#!/usr/bin/env python3
import os
import sys
import subprocess

def log_success(msg):
    print(f"[\033[92mSUCCESS\033[0m] {msg}")

def log_info(msg):
    print(f"[\033[94mINFO\033[0m] {msg}")

def log_failure(msg):
    print(f"[\033[91mFAILURE\033[0m] {msg}")
    sys.exit(1)

def run_flutter_tests(workspace_dir):
    log_info("Running Flutter widget & naming tests...")
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

    test_files = [
        "test/app_naming_test.dart",
        "test/widget_test.dart",
        "test/ui_widget_test.dart",
        "test/drug_sorting_test.dart"
    ]

    for tf in test_files:
        try:
            res = subprocess.run(
                [flutter_cmd, "test", tf],
                cwd=workspace_dir,
                capture_output=True,
                text=True,
                check=True
            )
            print(res.stdout)
            log_success(f"Flutter test {tf} passed!")
        except subprocess.CalledProcessError as e:
            print(e.stdout)
            print(e.stderr)
            log_failure(f"Flutter test {tf} failed with error: {e}")

def verify_source_files(workspace_dir):
    log_info("Verifying application title strings across all platforms...")

    target_name = "Tạo bill thuốc"

    # 1. lib/main.dart
    main_dart = os.path.join(workspace_dir, "lib", "main.dart")
    with open(main_dart, "r", encoding="utf-8") as f:
        src = f.read()
    if f"title: '{target_name}'" not in src:
        log_failure(f"lib/main.dart does not contain title: '{target_name}'")
    log_success("Verified lib/main.dart title.")

    # 2. lib/views/dashboard_page.dart
    dashboard_page = os.path.join(workspace_dir, "lib", "views", "dashboard_page.dart")
    with open(dashboard_page, "r", encoding="utf-8") as f:
        src = f.read()
    if f"'{target_name}'" not in src:
        log_failure(f"lib/views/dashboard_page.dart does not contain '{target_name}'")
    log_success("Verified lib/views/dashboard_page.dart title.")

    # 3. android/app/src/main/AndroidManifest.xml
    android_manifest = os.path.join(workspace_dir, "android", "app", "src", "main", "AndroidManifest.xml")
    with open(android_manifest, "r", encoding="utf-8") as f:
        src = f.read()
    if f'android:label="{target_name}"' not in src:
        log_failure(f"AndroidManifest.xml does not contain android:label=\"{target_name}\"")
    log_success("Verified AndroidManifest.xml label.")

    # 4. linux/runner/my_application.cc
    linux_app = os.path.join(workspace_dir, "linux", "runner", "my_application.cc")
    with open(linux_app, "r", encoding="utf-8") as f:
        src = f.read()
    if f'"{target_name}"' not in src:
        log_failure(f"linux/runner/my_application.cc does not contain \"{target_name}\"")
    log_success("Verified linux/runner/my_application.cc window and header bar title.")

    # 5. windows/runner/main.cpp
    win_main = os.path.join(workspace_dir, "windows", "runner", "main.cpp")
    with open(win_main, "r", encoding="utf-8") as f:
        src = f.read()
    if f'L"{target_name}"' not in src:
        log_failure(f"windows/runner/main.cpp does not contain L\"{target_name}\"")
    log_success("Verified windows/runner/main.cpp window title.")

    # 6. windows/runner/Runner.rc
    win_rc = os.path.join(workspace_dir, "windows", "runner", "Runner.rc")
    with open(win_rc, "r", encoding="utf-8") as f:
        src = f.read()
    if f'VALUE "FileDescription", "{target_name}"' not in src or f'VALUE "ProductName", "{target_name}"' not in src:
        log_failure(f"windows/runner/Runner.rc does not contain \"{target_name}\" in FileDescription/ProductName")
    log_success("Verified windows/runner/Runner.rc metadata strings.")

    # 7. build-deb.sh
    build_deb = os.path.join(workspace_dir, "build-deb.sh")
    with open(build_deb, "r", encoding="utf-8") as f:
        src = f.read()
    if f"Name={target_name}" not in src:
        log_failure(f"build-deb.sh does not contain Name={target_name}")
    log_success("Verified build-deb.sh packaging metadata.")

    # 8. installer.iss & installer.nsi
    iss_file = os.path.join(workspace_dir, "installer.iss")
    with open(iss_file, "r", encoding="utf-8") as f:
        src = f.read()
    if f'#define AppName "{target_name}"' not in src:
        log_failure(f"installer.iss does not define AppName as \"{target_name}\"")
    log_success("Verified installer.iss AppName.")

    nsi_file = os.path.join(workspace_dir, "installer.nsi")
    with open(nsi_file, "r", encoding="utf-8") as f:
        src = f.read()
    if f'!define APP_NAME      "{target_name}"' not in src:
        log_failure(f"installer.nsi does not define APP_NAME as \"{target_name}\"")
    log_success("Verified installer.nsi APP_NAME.")

def main():
    print("=" * 60)
    print("RUNNING AUTOMATED TEST SUITE: UPGRADE PHASE 03 (APP RENAMING)")
    print("=" * 60)

    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

    verify_source_files(workspace_dir)
    print("-" * 60)

    run_flutter_tests(workspace_dir)
    print("-" * 60)

    log_success("ALL PHASE 03 APP RENAMING VERIFICATION CHECKS PASSED!")
    print("=" * 60)

if __name__ == "__main__":
    main()
