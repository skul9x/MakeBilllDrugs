# Plan: Manual Drug Input Option
Created: 2026-06-05
Status: 🟡 In Progress
Current Phase: Phase 01: Core & Unit Testing

## 1. Overview
This plan introduces the capability to manually enter drug items (Name, Brand, and Packaging Specification) into the **Drugs Maker Flutter** billing manager, alongside the existing automated web scraping functionality.
- **Manual Input View:** Add a segmented toggle or custom Tab bar in the Left Input panel to switch between "Smart Import" (Scraping) and "Manual Input".
- **Fields for Manual Input:** Title/Name, Brand, and Packaging Specification, with integrated validation (Name is required).
- **Deduplication:** Manually added items will check for case-insensitive matches against existing items (matching Name, Brand, and Packaging). If a duplicate is found, the quantity will be incremented; otherwise, a new item will be appended.
- **Integration:** The manually added drugs will integrate seamlessly into the interactive live table, reactive STT calculations, and the premium Excel export/import system.

## 2. Tech Stack
- **Framework:** Flutter Desktop (Dart)
- **State management:** Flutter State Hooks (`setState` in `_DashboardPageState`)
- **Excel Styling & Handling:** `excel` package
- **Unit/Widget Testing:** `flutter_test` package
- **Verification Scripts:** Python 3 (`subprocess`, `openpyxl`, `re`)

## 3. Progress Tracker

| Phase | Name | Status | Progress | Description |
|-------|------|--------|----------|-------------|
| [01](./phase-01-core-and-unit-testing.md) | Core Logic & Unit Testing | ✅ Completed | 100% | Create unit tests and modify duplicate-check logic to cleanly support manual drug creation and validation. |
| [02](./phase-02-ui-implementation.md) | Dashboard UI Enhancement | ⬜ Pending | 0% | Implement manual input form with tab-switching in the Left Panel and perform widget validation tests. |
| [03](./phase-03-integration-e2e.md) | E2E Testing & Package Verification | ⬜ Pending | 0% | Build validation tests for manual-input data exporting to formatted Excel and package building. |

## 4. Quick Commands
- Verify Phase 1: `python3 tests/test-manual-input-phase-01.py`
- Verify Phase 2: `python3 tests/test-manual-input-phase-02.py`
- Verify Phase 3: `python3 tests/test-manual-input-phase-03.py`
- Check progress: `/next`
- Save context: `/save-brain`
