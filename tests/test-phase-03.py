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

def verify_files_exist(workspace_dir):
    log_info("Checking Phase 03 Dialog Service files...")
    required_files = [
        "lib/services/dialog_service.dart",
        "lib/services/dialog_service_impl.dart",
        "lib/services/mock_dialog_service.dart",
        "test/dialog_service_test.dart"
    ]
    
    for file in required_files:
        path = os.path.join(workspace_dir, file)
        if not os.path.exists(path):
            log_failure(f"Missing required Phase 03 file: {file}")
        log_success(f"File exists: {file}")

def run_dialog_tests(workspace_dir):
    log_info("Running Dart unit tests for Dialog Service...")
    
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
            [flutter_cmd, "test", "test/dialog_service_test.dart"],
            cwd=workspace_dir,
            capture_output=True,
            text=True,
            check=True
        )
        print(res.stdout)
        log_success("All Dialog Service unit tests passed successfully!")
    except subprocess.CalledProcessError as e:
        print(e.stdout)
        print(e.stderr)
        log_failure(f"Dialog Service tests failed with error: {e}")

def main():
    print("=" * 60)
    print("RUNNING AUTOMATED FLUTTER PHASE 03 DIALOGS TEST SUITE")
    print("=" * 60)
    
    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    
    verify_files_exist(workspace_dir)
    print("-" * 60)
    
    run_dialog_tests(workspace_dir)
    print("-" * 60)
    
    log_success("ALL PHASE 03 DIALOGS VERIFICATION CHECKS PASSED!")
    print("=" * 60)

if __name__ == "__main__":
    main()
