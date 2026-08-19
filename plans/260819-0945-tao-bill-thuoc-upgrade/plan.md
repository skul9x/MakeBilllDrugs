# Plan: "Tạo bill thuốc" App Upgrade - Excel Formatting, A-Z Sorting, App Renaming & Adaptive Icons

Created: 2026-08-19 09:45
Status: 🟢 Completed

## Overview
This plan implements four core enhancements requested for the Flutter medical bill generator application:
1. **Excel Export Formatting**: Configure default font to **Times New Roman**, font size **12pt**, and dynamic auto-fitting for column widths and row heights.
2. **Alphabetical Drug Sorting (A-Z)**: Enforce strict alphabetical ordering (Vietnamese locale-aware and case-insensitive) across the active UI table, manual entry, smart import, excel import, and exported Excel sheets.
3. **Application Renaming**: Update the application title to **"Tạo bill thuốc"** across Flutter UI, Android manifest/label, Linux window/header bar, Windows window/metadata, build scripts, and tests.
4. **Adaptive Cross-Platform Icons**: Design and generate complete adaptive icon sets for **Android** (API 26+ adaptive XML + mipmaps mdpi to xxxhdpi), **Windows** (multi-resolution `.ico` up to 256x256), and **Linux** (application/window icons & `.desktop` packaging).

## Tech Stack
- **Framework**: Flutter Desktop (Linux/Windows) & Mobile (Android)
- **Language**: Dart / C++ (Linux & Windows runners) / XML & Kotlin (Android)
- **Libraries**: `excel: ^4.0.6`, `google_fonts: ^6.2.0`, `flutter_spinkit: ^5.2.2`
- **Testing & Verification**: Flutter Test (`flutter test`), Python verification runners (`openpyxl`, `Pillow`, `subprocess`)

## Phases

| Phase | Name | Status | Progress |
|-------|------|--------|----------|
| 01 | [Phase 01: Excel Export Formatting & Auto-Fit Optimization](./phase-01-excel-export-formatting.md) | 🟢 Completed | 100% |
| 02 | [Phase 02: Drug List Alphabetical Sorting (A-Z)](./phase-02-drug-list-az-sorting.md) | 🟢 Completed | 100% |
| 03 | [Phase 03: Application Renaming to "Tạo bill thuốc"](./phase-03-app-renaming.md) | 🟢 Completed | 100% |
| 04 | [Phase 04: Cross-Platform Adaptive App Icons](./phase-04-cross-platform-adaptive-icons.md) | 🟢 Completed | 100% |
| 05 | [Phase 05: End-to-End Integration & Regression Testing](./phase-05-integration-and-verification.md) | 🟢 Completed | 100% |

## Verification Strategy
Each phase includes:
1. Dedicated Flutter unit or widget tests in `test/`.
2. Dedicated Python-based automated test runner in `tests/test-app-upgrade-phase-XX.py` that validates file contents, data models, Excel formatting with `openpyxl`, or image asset dimensions with `Pillow`.
3. All tests must execute cleanly and return exit code 0 before moving to subsequent phases.

## Quick Commands
- Start Phase 1: `/code phase-01`
- Start Phase 2: `/code phase-02`
- Start Phase 3: `/code phase-03`
- Start Phase 4: `/code phase-04`
- Start Phase 5: `/code phase-05`
