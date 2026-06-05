# Phase 01: Setup Environment
Status: ✅ Completed
Dependencies: None

## Objective
Establish the development workspace, download and install the Flutter SDK, enable desktop support for Windows and Linux, bootstrap a clean Flutter Desktop application structure, configure core dependencies (`pubspec.yaml`), and ensure the template compiles.

## Requirements
### Functional
- [x] Install Flutter SDK on the Linux host machine.
- [x] Initialize the Flutter project targeting both Linux and Windows.
- [x] Configure `pubspec.yaml` with essential packages: `html`, `excel`, `http`, `file_picker`, `google_fonts`, `flutter_spinkit`.
- [x] Configure desktop-specific settings (window sizes, title).

### Non-Functional
- [x] Fast build times with a clean structure.
- [x] No compilation errors or lint warnings.

## Implementation Steps
1. [x] Download the Flutter SDK stable bundle for Linux, extract to `~/development/flutter`, and add to `~/.bashrc` `PATH`.
2. [x] Install the required Linux desktop toolchain dependencies: `clang`, `cmake`, `ninja-build`, `pkg-config`, `libgtk-3-dev`, `libstdc++-12-dev`.
3. [x] Run `flutter doctor` to ensure the desktop environment checks are successful.
4. [x] Initialize a new Flutter project in `/home/skul9x/Desktop/Test_code/Drugs Maker Flutter` (e.g., using `flutter create --platforms=linux,windows .`).
5. [x] Update `pubspec.yaml` to include:
    - `http: ^1.2.0`
    - `html: ^0.15.4`
    - `excel: ^4.0.6`
    - `file_picker: ^8.0.0`
    - `google_fonts: ^6.2.0`
6. [x] Setup initial folder organization under `lib/`:
    - `lib/core/` (constants, styles, theme, utils)
    - `lib/models/` (data models like `DrugItem`, `DrugInfo`)
    - `lib/services/` (scraping parser, excel generation, file picker integration)
    - `lib/views/` (screens, widgets)
7. [x] Verify that a default desktop window can be spawned and built (`flutter build linux`).

## Files to Create/Modify
- `pubspec.yaml` - Modify dependencies and assets configuration.
- `lib/main.dart` - Entrypoint of the Flutter app.
- `tests/test-phase-01.py` - Python test runner for Phase 01.

## Test Criteria
- `flutter` command must be executable and pointing to a stable Flutter SDK version >= 3.0.0.
- Flutter project structure must exist with `pubspec.yaml`, `lib/main.dart`, `linux/`, and `windows/` directories.
- Dependencies in `pubspec.yaml` must match the specified list.
- Running `python3 tests/test-phase-01.py` must complete with exit code 0.

## Automated Verification Script
Create a file at `tests/test-phase-01.py` containing code that programmatically verifies:
1. Flutter SDK installation path and command availability.
2. Flutter Desktop Linux target availability.
3. Existence of required folders and `pubspec.yaml` structure.
4. Success of `flutter pub get`.

---
Next Phase: [Phase 02: Core Parser & Excel Logic](./phase-02-core-logic.md)
