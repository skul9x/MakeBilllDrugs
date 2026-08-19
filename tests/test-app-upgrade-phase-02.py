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
    log_info("Running Flutter test for drug sorting...")
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
            [flutter_cmd, "test", "test/drug_sorting_test.dart"],
            cwd=workspace_dir,
            capture_output=True,
            text=True,
            check=True
        )
        print(res.stdout)
        log_success("Flutter drug sorting test passed!")
    except subprocess.CalledProcessError as e:
        print(e.stdout)
        print(e.stderr)
        log_failure(f"Flutter test failed with error: {e}")

def verify_source_implementation(workspace_dir):
    log_info("Verifying DrugItem & DashboardPage & ExcelService sorting integration...")
    
    # 1. DrugItem
    drug_item_file = os.path.join(workspace_dir, "lib", "models", "drug_item.dart")
    with open(drug_item_file, "r", encoding="utf-8") as f:
        drug_item_src = f.read()

    if "compareByName" not in drug_item_src:
        log_failure("compareByName not found in drug_item.dart!")
    if "sortAndReindex" not in drug_item_src:
        log_failure("sortAndReindex not found in drug_item.dart!")
    log_success("Verified DrugItem comparator and sortAndReindex methods.")

    # 2. DashboardPage
    dashboard_file = os.path.join(workspace_dir, "lib", "views", "dashboard_page.dart")
    with open(dashboard_file, "r", encoding="utf-8") as f:
        dashboard_src = f.read()

    if "DrugItem.sortAndReindex(_items)" not in dashboard_src:
        log_failure("DashboardPage _reindexItems does not call DrugItem.sortAndReindex!")
    log_success("Verified DashboardPage auto-sorts on reindex.")

    # 3. ExcelService
    excel_file = os.path.join(workspace_dir, "lib", "services", "excel_service.dart")
    with open(excel_file, "r", encoding="utf-8") as f:
        excel_src = f.read()

    if "DrugItem.sortAndReindex(items)" not in excel_src:
        log_failure("ExcelService generateExcel does not sort items before export!")
    log_success("Verified ExcelService auto-sorts before export.")

def main():
    print("=" * 60)
    print("RUNNING AUTOMATED TEST SUITE: UPGRADE PHASE 02 (DRUG LIST A-Z SORTING)")
    print("=" * 60)

    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

    verify_source_implementation(workspace_dir)
    print("-" * 60)

    run_flutter_test(workspace_dir)
    print("-" * 60)

    log_success("ALL PHASE 02 DRUG LIST SORTING VERIFICATION CHECKS PASSED!")
    print("=" * 60)

if __name__ == "__main__":
    main()
