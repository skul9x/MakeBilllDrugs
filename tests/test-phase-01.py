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
                
    log_failure("Flutter SDK could not be found. Please check implementation plan steps to install Flutter SDK.")

def verify_flutter_desktop(flutter_bin):
    log_info("Verifying Flutter Linux desktop support...")
    try:
        res = subprocess.run([flutter_bin, "devices"], capture_output=True, text=True, check=True)
        devices_output = res.stdout.lower()
        if "linux" in devices_output:
            log_success("Linux desktop device target detected.")
        else:
            log_info("Linux device target not running, checking doctor...")
            
        res_doc = subprocess.run([flutter_bin, "doctor"], capture_output=True, text=True, check=True)
        doctor_output = res_doc.stdout.lower()
        if "linux toolchain" in doctor_output and "missing" not in doctor_output:
            log_success("Linux Desktop toolchain dependencies are fully configured.")
        else:
            log_info("Ensure 'clang', 'cmake', 'ninja-build', 'pkg-config', 'libgtk-3-dev' are installed.")
    except Exception as e:
        log_failure(f"Error checking devices/doctor: {e}")

def verify_project_structure(project_dir):
    log_info(f"Verifying project skeleton at: {project_dir}")
    
    required_files = [
        "pubspec.yaml",
        "lib/main.dart",
        "linux/CMakeLists.txt",
        "windows/CMakeLists.txt"
    ]
    
    for file in required_files:
        path = os.path.join(project_dir, file)
        if not os.path.exists(path):
            log_failure(f"Required file/directory is missing: {file}")
        log_success(f"Verified existence of {file}")

def verify_pubspec_dependencies(pubspec_path):
    log_info("Checking dependencies in pubspec.yaml...")
    with open(pubspec_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    required_deps = ["http", "html", "excel", "file_picker", "google_fonts"]
    for dep in required_deps:
        pattern = rf"\b{dep}\s*:"
        if not re.search(pattern, content):
            log_failure(f"Missing required dependency in pubspec.yaml: {dep}")
        log_success(f"Dependency verified: {dep}")

def main():
    print("=" * 60)
    print("RUNNING AUTOMATED FLUTTER PHASE 01 ENVIRONMENT TEST SUITE")
    print("=" * 60)
    
    workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    
    flutter_bin = find_flutter()
    print("-" * 60)
    
    verify_flutter_desktop(flutter_bin)
    print("-" * 60)
    
    verify_project_structure(workspace_dir)
    print("-" * 60)
    
    verify_pubspec_dependencies(os.path.join(workspace_dir, "pubspec.yaml"))
    print("-" * 60)
    
    log_success("ALL PHASE 01 CHECKS COMPLETED SUCCESSFULLY!")
    print("=" * 60)

if __name__ == "__main__":
    main()
