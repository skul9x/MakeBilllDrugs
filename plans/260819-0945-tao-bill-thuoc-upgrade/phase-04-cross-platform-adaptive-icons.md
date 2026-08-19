# Phase 04: Cross-Platform Adaptive App Icons

Status: ✅ Completed
Dependencies: [Phase 03: Application Renaming to "Tạo bill thuốc"](./phase-03-app-renaming.md)

## Objective
Design and generate a cohesive, premium medical/bill glassmorphism adaptive icon suite for **Android**, **Windows**, and **Linux** platforms, including full Android API 26+ adaptive XML structures, multi-density foreground/background mipmaps, Windows `.ico` multi-resolution bundle, and Linux desktop icons.

## Requirements
### Functional
- **Master Icon Design**:
  - High-resolution master icon (1024x1024 PNG) featuring a stylized medical capsule/cross blended with a smart receipt bill on a modern neon cyan & deep navy glassmorphism backdrop.
  - Transparent foreground layer (1024x1024 PNG) for Android adaptive icon rendering.
  - Background layer (solid or gradient `#0F172A` / `#00F2FE`) for Android adaptive icon rendering.
- **Android Adaptive & Legacy Icons**:
  - Create `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` and `ic_launcher_round.xml` referencing `@drawable/ic_launcher_background` and `@mipmap/ic_launcher_foreground`.
  - Provide `android/app/src/main/res/drawable/ic_launcher_background.xml`.
  - Generate multi-density legacy launcher icons (`ic_launcher.png` and `ic_launcher_round.png`):
    - `mipmap-mdpi`: 48x48
    - `mipmap-hdpi`: 72x72
    - `mipmap-xhdpi`: 96x96
    - `mipmap-xxhdpi`: 144x144
    - `mipmap-xxxhdpi`: 192x192
  - Generate multi-density adaptive foreground icons (`ic_launcher_foreground.png`):
    - `mipmap-mdpi`: 108x108
    - `mipmap-hdpi`: 162x162
    - `mipmap-xhdpi`: 216x216
    - `mipmap-xxhdpi`: 324x324
    - `mipmap-xxxhdpi`: 432x432
- **Windows Icon**:
  - Create multi-size `windows/runner/resources/app_icon.ico` embedding standard Windows icon sizes: 16x16, 24x24, 32x32, 48x48, 64x64, 128x128, and 256x256.
- **Linux Icon**:
  - Provide `assets/icon/app_icon.png` (512x512 PNG) and `linux/runner/resources/app_icon.png`.
  - Update `linux/runner/my_application.cc` to set window icon with `gtk_window_set_icon_from_file` if available.
  - Update `build-deb.sh` to package high-resolution icon into `debian-pack/usr/share/pixmaps/tao-bill-thuoc.png`.

### Non-Functional
- Crisp rendering across low-DPI and high-DPI displays (including Retina, 4K, and high-density mobile screens).
- Consistent visual branding matching the application theme (`GlassTheme.primaryNeon` / `GlassTheme.bgDark`).

## Implementation Steps
1. [x] Create master icon assets in `assets/icon/`:
   - `assets/icon/app_icon.png` (1024x1024)
   - `assets/icon/app_icon_foreground.png` (1024x1024)
   - `assets/icon/app_icon_background.png` (1024x1024)
2. [x] Build an automated asset generator script in `scripts/generate_icons.py` utilizing Python `Pillow` to:
   - Produce all Android mipmap densities (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi) for launcher and foreground.
   - Produce `windows/runner/resources/app_icon.ico` with all resolution layers (16x16 to 256x256).
   - Produce Linux icon resources and update `build-deb.sh`.
3. [x] Set up Android adaptive icon XML resources:
   - `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
   - `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml`
   - `android/app/src/main/res/drawable/ic_launcher_background.xml`
4. [x] Update `linux/runner/my_application.cc` to load window icon.
5. [x] Create [test/app_icon_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/app_icon_test.dart) to verify asset presence.
6. [x] Create [tests/test-app-upgrade-phase-04.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-app-upgrade-phase-04.py):
   - Inspect all generated icon files on disk (Android, Windows, Linux).
   - Verify image dimensions, channel format (RGBA), and `.ico` directory headers.

## Files to Create/Modify
- [NEW] `assets/icon/app_icon.png`, `assets/icon/app_icon_foreground.png`, `assets/icon/app_icon_background.png`
- [NEW] `scripts/generate_icons.py`
- [NEW] `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml`
- [NEW] `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml`
- [NEW] `android/app/src/main/res/drawable/ic_launcher_background.xml`
- [MODIFY] `android/app/src/main/res/mipmap-*/` icon files
- [MODIFY] `windows/runner/resources/app_icon.ico`
- [MODIFY] `linux/runner/my_application.cc`
- [MODIFY] `build-deb.sh`
- [NEW] [test/app_icon_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/app_icon_test.dart)
- [NEW] [tests/test-app-upgrade-phase-04.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-app-upgrade-phase-04.py)

## Test Criteria
- `python3 tests/test-app-upgrade-phase-04.py` passes with exit code 0.
- All Android mipmap folders contain valid `ic_launcher.png`, `ic_launcher_round.png`, and `ic_launcher_foreground.png`.
- Windows `.ico` contains at least 7 sub-images (16, 24, 32, 48, 64, 128, 256).
- Linux icon assets exist and are linked in the build configuration.

---
Next Phase: [Phase 05: End-to-End Integration & Regression Testing](./phase-05-integration-and-verification.md)
