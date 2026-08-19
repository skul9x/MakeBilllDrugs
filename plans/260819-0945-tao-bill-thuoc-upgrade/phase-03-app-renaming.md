# Phase 03: Application Renaming to "Tạo bill thuốc"

Status: ✅ Completed
Dependencies: [Phase 02: Drug List Alphabetical Sorting (A-Z)](./phase-02-drug-list-az-sorting.md)

## Objective
Update the application brand and display name to **"Tạo bill thuốc"** across all target platforms (Flutter UI, Android APK/launcher, Linux desktop window & packaging, Windows desktop window & resources, installers, and project test suites).

## Requirements
### Functional
- **Flutter Application**:
  - `lib/main.dart`: Set `MaterialApp(title: 'Tạo bill thuốc', ...)`
  - `lib/views/dashboard_page.dart`: Set header title to `'Tạo bill thuốc'`
- **Android Platform**:
  - `android/app/src/main/AndroidManifest.xml`: Set `android:label="Tạo bill thuốc"` in `<application>`
- **Linux Platform**:
  - `linux/runner/my_application.cc`: Set header bar and window title to `"Tạo bill thuốc"`
  - `build-deb.sh`: Update `.desktop` Name to `Tạo bill thuốc` and description strings
- **Windows Platform**:
  - `windows/runner/main.cpp`: Set window title parameter `window.Create(L"Tạo bill thuốc", ...)`
  - `windows/runner/Runner.rc`: Update `FileDescription` and `ProductName` to `"Tạo bill thuốc"`
- **Packaging & Docs**:
  - Update `installer.iss` and `installer.nsi` application name to `Tạo bill thuốc`
  - Update `README.md`
- **Test Compatibility**:
  - Update all existing widget tests and UI tests to expect `'Tạo bill thuốc'` instead of the legacy title.

### Non-Functional
- UTF-8 character encoding must be preserved in C++ source files (using UTF-8 literal or `L"Tạo bill thuốc"` with `#pragma code_page(65001)`) and XML/YAML files to prevent distorted Unicode glyphs on Windows and Linux window titlebars.

## Implementation Steps
1. [x] Update [lib/main.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/main.dart) and [lib/views/dashboard_page.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/views/dashboard_page.dart) with `'Tạo bill thuốc'`.
2. [x] Update [android/app/src/main/AndroidManifest.xml](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/android/app/src/main/AndroidManifest.xml) with `android:label="Tạo bill thuốc"`.
3. [x] Update [linux/runner/my_application.cc](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/linux/runner/my_application.cc) with `"Tạo bill thuốc"`.
4. [x] Update [windows/runner/main.cpp](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/windows/runner/main.cpp) and [windows/runner/Runner.rc](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/windows/runner/Runner.rc) with `"Tạo bill thuốc"`.
5. [x] Update `build-deb.sh`, `installer.iss`, `installer.nsi`, and `README.md`.
6. [x] Update existing tests (`test/widget_test.dart`, `test/ui_widget_test.dart`) to match the new title.
7. [x] Create [test/app_naming_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/app_naming_test.dart) to verify `MaterialApp` title and `DashboardPage` header.
8. [x] Create [tests/test-app-upgrade-phase-03.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-app-upgrade-phase-03.py) Python verification runner checking all source files for correct UTF-8 title strings and running Flutter tests.

## Files to Create/Modify
- [MODIFY] [lib/main.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/main.dart)
- [MODIFY] [lib/views/dashboard_page.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/views/dashboard_page.dart)
- [MODIFY] [android/app/src/main/AndroidManifest.xml](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/android/app/src/main/AndroidManifest.xml)
- [MODIFY] [linux/runner/my_application.cc](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/linux/runner/my_application.cc)
- [MODIFY] [windows/runner/main.cpp](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/windows/runner/main.cpp)
- [MODIFY] [windows/runner/Runner.rc](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/windows/runner/Runner.rc)
- [MODIFY] [build-deb.sh](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/build-deb.sh)
- [MODIFY] [installer.iss](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/installer.iss)
- [MODIFY] [installer.nsi](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/installer.nsi)
- [MODIFY] [test/widget_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/widget_test.dart)
- [MODIFY] [test/ui_widget_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/ui_widget_test.dart)
- [NEW] [test/app_naming_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/app_naming_test.dart)
- [NEW] [tests/test-app-upgrade-phase-03.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-app-upgrade-phase-03.py)

## Test Criteria
- `python3 tests/test-app-upgrade-phase-03.py` executes successfully.
- All Flutter tests pass and confirm `Tạo bill thuốc` renders as the application and header title.
- Configuration and runner source files across Android, Linux, and Windows contain `"Tạo bill thuốc"`.

---
Next Phase: [Phase 04: Cross-Platform Adaptive App Icons](./phase-04-cross-platform-adaptive-icons.md)
