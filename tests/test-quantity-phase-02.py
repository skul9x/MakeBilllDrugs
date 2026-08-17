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
    print("RUNNING AUTOMATED QUANTITY SELECTOR PHASE 02 TESTS")
    print("=" * 60)
    
    flutter_bin = find_flutter()
    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    
    test_files = [
        os.path.join("test", "smart_import_quantity_test.dart"),
        os.path.join("test", "manual_input_ui_test.dart"),
        os.path.join("test", "quantity_selector_test.dart"),
    ]
    
    for rel_path in test_files:
        full_path = os.path.join(workspace_dir, rel_path)
        if not os.path.exists(full_path):
            log_failure(f"Test file not found: {full_path}")
            
        log_info(f"Running test: {rel_path}...")
        try:
            res = subprocess.run(
                [flutter_bin, "test", rel_path],
                cwd=workspace_dir,
                capture_output=True,
                text=True
            )
            print(res.stdout)
            if res.returncode == 0:
                log_success(f"{rel_path} passed successfully!")
            else:
                print(res.stderr)
                log_failure(f"{rel_path} failed with code {res.returncode}")
        except Exception as e:
            log_failure(f"Failed to execute test {rel_path}: {e}")
            
    print("=" * 60)
    log_success("PHASE 02 COMPLETED SUCCESSFULLY!")
    print("=" * 60)

if __name__ == "__main__":
    main()
