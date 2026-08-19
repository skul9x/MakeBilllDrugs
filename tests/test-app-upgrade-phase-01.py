#!/usr/bin/env python3
import os
import sys
import subprocess
import tempfile
import openpyxl

def log_success(msg):
    print(f"[\033[92mSUCCESS\033[0m] {msg}")

def log_info(msg):
    print(f"[\033[94mINFO\033[0m] {msg}")

def log_failure(msg):
    print(f"[\033[91mFAILURE\033[0m] {msg}")
    sys.exit(1)

def run_flutter_test(workspace_dir):
    log_info("Running Flutter test for excel formatting...")
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
            [flutter_cmd, "test", "test/excel_formatting_test.dart"],
            cwd=workspace_dir,
            capture_output=True,
            text=True,
            check=True
        )
        print(res.stdout)
        log_success("Flutter excel formatting test passed!")
    except subprocess.CalledProcessError as e:
        print(e.stdout)
        print(e.stderr)
        log_failure(f"Flutter test failed with error: {e}")

def verify_excel_service_source(workspace_dir):
    log_info("Verifying ExcelService source code configurations...")
    service_file = os.path.join(workspace_dir, "lib", "services", "excel_service.dart")
    if not os.path.exists(service_file):
        log_failure(f"File not found: {service_file}")

    with open(service_file, "r", encoding="utf-8") as f:
        content = f.read()

    if "'Times New Roman'" not in content:
        log_failure("ExcelService does not configure 'Times New Roman' font!")
    log_success("Verified 'Times New Roman' font family configured.")

    if "fontSize: 12" not in content:
        log_failure("ExcelService does not configure fontSize: 12!")
    log_success("Verified fontSize: 12 configured.")

    if "sheet.setRowHeight(0, 28.0)" not in content:
        log_failure("Header row height 28.0 not found in ExcelService!")
    log_success("Verified header row height: 28.0.")

    if "sheet.setRowHeight(rowIdx, 24.0)" not in content:
        log_failure("Data row height 24.0 not found in ExcelService!")
    log_success("Verified data row height: 24.0.")

    if "12.0" not in content or "5.0" not in content:
        log_failure("Auto-fit metrics (minimum 12.0 or padding 5.0) not found!")
    log_success("Verified column auto-fit sizing logic.")

def main():
    print("=" * 60)
    print("RUNNING AUTOMATED TEST SUITE: UPGRADE PHASE 01 (EXCEL FORMATTING)")
    print("=" * 60)

    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

    verify_excel_service_source(workspace_dir)
    print("-" * 60)

    run_flutter_test(workspace_dir)
    print("-" * 60)

    log_success("ALL PHASE 01 EXCEL FORMATTING VERIFICATION CHECKS PASSED!")
    print("=" * 60)

if __name__ == "__main__":
    main()
