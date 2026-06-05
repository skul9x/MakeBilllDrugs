# Phase 05: E2E Testing & Distribution Packaging
Status: 🟩 Completed
Dependencies: [Phase 04: Premium Glassmorphism UI](./phase-04-frontend-ui.md)

## Objective
Conduct End-to-End (E2E) testing on the compiled application bundle to verify functional compliance, and package the final application for Linux (.deb installer and portable bundle) and Windows (portable zip archive).

## Requirements
### Functional
- [ ] **E2E Styling Verification**: Verify that the generated Excel documents produced by the release build comply cell-by-cell with the styling guidelines: Slate gray `#E2E8F0` header, bold Inter 11pt, text left-aligned, numbers center-aligned, auto-fit columns.
- [ ] **Release Builds**: Compile release mode binaries on both Linux (`flutter build linux --release`) and Windows (`flutter build windows --release`).
- [ ] **Linux .deb Installer Packaging**: Package the bundle using a custom bash script into an installable `.deb` Debian package containing icons, menu desktop shortcuts, and library dependencies.
- [ ] **Windows Portability**: Package the Windows build output into a zip file including all required DLL files.

### Non-Functional
- [ ] Output packages must install and launch on vanilla clean target environments without developer tool chains.
- [ ] No visual performance degradation or memory leaks during E2E test runs.

## Implementation Steps
1. [ ] Create a compilation and packaging script `build-deb.sh` for Linux:
   - Run `flutter build linux --release`.
   - Setup a temporary directory `debian-pack/` with folders `DEBIAN`, `opt/drugs-maker-flutter`, `usr/bin`, `usr/share/applications`, and `usr/share/pixmaps`.
   - Copy the compiled bundle (`build/linux/x64/release/bundle/*`) into `debian-pack/opt/drugs-maker-flutter/`.
   - Create a symlink or wrapper in `debian-pack/usr/bin/drugs-maker-flutter` pointing to `/opt/drugs-maker-flutter/drugs_maker_flutter`.
   - Generate `control` and `drugs-maker-flutter.desktop` files.
   - Run `dpkg-deb --build debian-pack` to output the installable Debian package.
2. [ ] Write the E2E excel generation integration test `test/e2e_excel_generation_test.dart` that uses local mock HTML files to output a spreadsheet at the project root (`test_output.xlsx`), and the final E2E style checker at `tests/verify_app.py` utilizing Python and `openpyxl` to inspect the generated structures.
3. [ ] Configure GitHub Actions or local CI scripts to build targets and run verification test sequences automatically.

## Files to Create/Modify
- `build-deb.sh` - Linux debian packaging script.
- `test/e2e_excel_generation_test.dart` - Integration test to generate Excel sheet from mock HTML.
- `tests/verify_app.py` - Excel cell styling E2E verifier.
- `tests/test-phase-05.py` - Python test validator for Phase 05.

## Test Criteria
- `flutter build linux --release` must complete successfully.
- Running `build-deb.sh` must generate `drugs-maker-flutter_1.0.0_amd64.deb` which installs cleanly.
- Running `flutter test test/e2e_excel_generation_test.dart` must generate `test_output.xlsx` at root.
- `tests/verify_app.py` must run and validate generated Excel sheets, completing with exit code 0.
- Python verification script `tests/test-phase-05.py` must run and exit with 0.

## Automated Verification Script
Create a file at `tests/test-phase-05.py` that:
1. Triggers `flutter build linux --release` to verify compilation.
2. Runs the debian packaging script `build-deb.sh` and checks if the `.deb` file exists.
3. Runs the `test/e2e_excel_generation_test.dart` test to generate `test_output.xlsx`.
4. Runs the E2E verification checking tool `verify_app.py` on the output spreadsheet.

---
Next Steps: Once Phase 05 is completed, the application is ready for final distribution and deployment review.
