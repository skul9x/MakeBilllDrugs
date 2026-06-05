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

def find_flutter():
    log_info("Locating Flutter SDK...")
    
    # Try global path first
    try:
        res = subprocess.run(["flutter", "--version"], capture_output=True, text=True, check=True)
        version_output = res.stdout.strip()
        log_success(f"Flutter is available globally: {version_output.splitlines()[0]}")
        return "flutter"
    except Exception:
        pass
        
    # Check common local installation directories
    home = os.path.expanduser("~")
    local_paths = [
        os.path.join(home, "development", "flutter", "bin", "flutter"),
        os.path.join(home, "flutter", "bin", "flutter"),
        "/opt/flutter/bin/flutter"
    ]
    
    for path in local_paths:
        if os.path.exists(path):
            try:
                res = subprocess.run([path, "--version"], capture_output=True, text=True, check=True)
                version_output = res.stdout.strip()
                log_success(f"Flutter found at local path: {path}")
                log_info(f"Version: {version_output.splitlines()[0]}")
                return path
            except Exception:
                pass
                
    log_failure("Flutter SDK could not be found.")

def main():
    print("=" * 60)
    print("RUNNING AUTOMATED MANUAL DRUG INPUT PHASE 02 UI TESTS")
    print("=" * 60)
    
    flutter_bin = find_flutter()
    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    
    dashboard_file = os.path.join(workspace_dir, "lib", "views", "dashboard_page.dart")
    if not os.path.exists(dashboard_file):
        log_failure(f"Dashboard file not found: {dashboard_file}")
        
    # Read dashboard file and check for required UI components
    log_info("Verifying UI components inside dashboard_page.dart...")
    with open(dashboard_file, "r", encoding="utf-8") as f:
        content = f.read()
        
    required_keywords = [
        "InputMode",
        "_inputMode",
        "tabSmartImport",
        "tabManualInput",
        "nameField",
        "brandField",
        "quyCachField",
        "addManuallyButton"
    ]
    
    for kw in required_keywords:
        if kw not in content:
            log_failure(f"Required UI keyword/key '{kw}' not found in dashboard_page.dart!")
        log_success(f"Verified existence of: {kw}")
        
    test_file = os.path.join(workspace_dir, "test", "manual_input_ui_test.dart")
    if not os.path.exists(test_file):
        log_failure(f"UI widget test file not found: {test_file}")
        
    log_info(f"Running UI widget test: {test_file}...")
    try:
        res = subprocess.run(
            [flutter_bin, "test", "test/manual_input_ui_test.dart"],
            cwd=workspace_dir,
            capture_output=True,
            text=True
        )
        print(res.stdout)
        if res.returncode == 0:
            log_success("All manual input UI widget tests passed successfully!")
        else:
            print(res.stderr)
            log_failure(f"UI widget tests failed with code {res.returncode}")
    except Exception as e:
        log_failure(f"Failed to execute tests: {e}")
        
    print("=" * 60)
    log_success("PHASE 02 COMPLETED SUCCESSFULLY!")
    print("=" * 60)

if __name__ == "__main__":
    main()
