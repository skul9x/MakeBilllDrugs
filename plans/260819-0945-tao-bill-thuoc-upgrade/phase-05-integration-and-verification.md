# Phase 05: End-to-End Integration & Regression Testing

Status: 🟢 Completed
Dependencies: [Phase 04: Cross-Platform Adaptive App Icons](./phase-04-cross-platform-adaptive-icons.md)

## Objective
Perform complete end-to-end integration and regression testing across the entire codebase to guarantee that all 4 user requirements function seamlessly together without breaking existing features (smart import, manual input, keyboard quantity editing, table navigation, deduplication, and responsive mobile/desktop UI).

## Requirements
### Functional
- Verify complete lifecycle:
  1. Add multiple drugs via smart import, manual input, and excel import.
  2. Verify UI table is continuously sorted in A-Z order by drug name with sequential STT numbering.
  3. Edit drug quantities using keyboard and stepper buttons.
  4. Export to Excel and verify file properties using `openpyxl`:
     - Font family is strictly `Times New Roman`.
     - Font size is strictly `12`.
     - Row heights and column widths are properly auto-fitted.
     - Rows are strictly sorted A-Z by drug name.
  5. Verify application title is `"Tạo bill thuốc"` in all UI components and platform configs.
  6. Verify all adaptive and desktop icon assets exist and pass integrity checks.

### Non-Functional
- All test suites must execute under 30 seconds.
- Zero test failures, analyzer warnings, or lint issues.

## Implementation Steps
1. [x] Run full Flutter test suite:
   ```bash
   flutter test
   ```
2. [x] Create [tests/test-app-upgrade-phase-05.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-app-upgrade-phase-05.py):
   - Comprehensive test runner consolidating tests from Phase 01 to Phase 04.
   - Run end-to-end workflow generation and deep verification.
3. [x] Run code analysis to ensure zero analyzer warnings:
   ```bash
   flutter analyze
   ```
4. [x] Generate final verification report.

## Files to Create/Modify
- [NEW] [tests/test-app-upgrade-phase-05.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-app-upgrade-phase-05.py) - Master end-to-end test runner.
- [MODIFY] [plans/260819-0945-tao-bill-thuoc-upgrade/plan.md](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/plans/260819-0945-tao-bill-thuoc-upgrade/plan.md) - Update phase progress tracker.

## Test Criteria
- `python3 tests/test-app-upgrade-phase-05.py` passes with 100% success rate.
- `flutter test` passes all tests without failure.
- `flutter analyze` returns no issues.

---
Plan Complete.
