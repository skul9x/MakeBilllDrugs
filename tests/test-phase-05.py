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

def verify_build_compiles(workspace_dir):
    log_info("Compiling Flutter release build for Linux desktop...")
    
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
            [flutter_cmd, "build", "linux", "--release"],
            cwd=workspace_dir,
            capture_output=True,
            text=True,
            check=True
        )
        print(res.stdout)
        log_success("Flutter release build completed successfully.")
    except subprocess.CalledProcessError as e:
        print(e.stdout)
        print(e.stderr)
        log_failure(f"Flutter build failed with error: {e}")

def verify_deb_packaging(workspace_dir):
    log_info("Executing Debian packaging script...")
    packaging_script = os.path.join(workspace_dir, "build-deb.sh")
    
    if not os.path.exists(packaging_script):
        log_failure(f"Missing packaging script: {packaging_script}")
        
    try:
        res = subprocess.run(
            ["bash", "build-deb.sh"],
            cwd=workspace_dir,
            capture_output=True,
            text=True,
            check=True
        )
        print(res.stdout)
        log_success("Debian packaging executed successfully.")
        
        # Check if deb package exists
        deb_packages = [f for f in os.listdir(workspace_dir) if f.endswith(".deb")]
        if not deb_packages:
            log_failure("No .deb installer package generated at repository root!")
            
        log_success(f"Generated Debian package: {deb_packages[0]}")
    except subprocess.CalledProcessError as e:
        print(e.stdout)
        print(e.stderr)
        log_failure(f"Debian packaging failed: {e}")

def run_excel_verifier(workspace_dir):
    log_info("Running E2E Excel generator integration test...")
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
            [flutter_cmd, "test", "test/e2e_excel_generation_test.dart"],
            cwd=workspace_dir,
            capture_output=True,
            text=True,
            check=True
        )
        print(res.stdout)
        log_success("Generated test_output.xlsx successfully via Integration Test.")
    except subprocess.CalledProcessError as e:
        print(e.stdout)
        print(e.stderr)
        log_failure(f"Excel generation Integration Test failed: {e}")

    log_info("Invoking E2E Excel verifier script...")
    verifier_script = os.path.join(workspace_dir, "tests", "verify_app.py")
    
    try:
        res = subprocess.run(
            [sys.executable, verifier_script],
            cwd=workspace_dir,
            capture_output=True,
            text=True,
            check=True
        )
        print(res.stdout)
        log_success("E2E Excel verifier checks completed successfully!")
    except subprocess.CalledProcessError as e:
        print(e.stdout)
        print(e.stderr)
        log_failure(f"E2E Excel verifier failed: {e}")

def main():
    print("=" * 60)
    print("RUNNING AUTOMATED FLUTTER PHASE 05 E2E & DEB PACKAGE TEST SUITE")
    print("=" * 60)
    
    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    
    # 1. Compile release executable
    verify_build_compiles(workspace_dir)
    print("-" * 60)
    
    # 2. Package release package (.deb)
    verify_deb_packaging(workspace_dir)
    print("-" * 60)
    
    # 3. Verify excel styling
    run_excel_verifier(workspace_dir)
    print("-" * 60)
    
    log_success("ALL PHASE 05 E2E VERIFICATION AND PACKAGING CHECKS PASSED!")
    print("=" * 60)

if __name__ == "__main__":
    main()
