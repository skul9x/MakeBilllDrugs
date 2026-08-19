# Phase 02: Drug List Alphabetical Sorting (A-Z)

Status: ✅ Completed
Dependencies: [Phase 01: Excel Export Formatting & Auto-Fit Optimization](./phase-01-excel-export-formatting.md)

## Objective
Enforce alphabetical ordering (A-Z) for drug items across the application, ensuring that adding drugs (smart import, manual entry), importing from Excel files, and exporting to Excel files always maintain a sorted list with consistent STT index renumbering (1, 2, 3, ...).

## Requirements
### Functional
- **Vietnamese Locale-Aware & Case-Insensitive Comparator**:
  - Implement a dedicated comparison function `DrugItem.compareByName(DrugItem a, DrugItem b)` or helper utility.
  - Sort strings by drug name alphabetically (A-Z) handling Vietnamese diacritics (a, à, á, ả, ã, ạ, ă, ắ, â, b, c, d, đ, e, ê, ...).
  - Use brand and quy cách as secondary tie-breakers if drug names are identical.
- **UI State Sorting**:
  - Whenever drugs are added (via Smart Import `_fetchAndAddDrug` or Manual Entry `_addDrugManually`), insert/re-sort `_items` in A-Z order and re-index `stt` from 1 to N.
  - Whenever drugs are imported (`_importFromExcel`), sort `_items` in A-Z order and re-index `stt`.
  - When drug row quantities are updated or items deleted, maintain proper sorted order and re-index `stt`.
- **Excel Export Sorting**:
  - In `ExcelService.generateExcel`, sort the item list alphabetically (A-Z) before writing rows to ensure exported sheets are guaranteed to be in A-Z sequence even if external lists were unsorted.
- **Sequential STT Numbering**:
  - `stt` column in both the UI table and exported Excel must always start at `1` and increment consecutively (`1, 2, 3, ...`).

### Non-Functional
- Sorting must be instantaneous (< 5ms for hundreds of items) and prevent UI freezing.
- Selection states (e.g. keyboard row selection) must correctly follow the selected item or reset cleanly without throwing out-of-bounds index exceptions.

## Implementation Steps
1. [x] Implement sorting logic in [lib/models/drug_item.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/models/drug_item.dart):
   - Add `static int compareByName(DrugItem a, DrugItem b)` with Vietnamese collation support.
   - Add helper method `static List<DrugItem> sortAndReindex(List<DrugItem> items)`.
2. [x] Update [lib/views/dashboard_page.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/views/dashboard_page.dart):
   - Replace `_reindexItems()` with a method that sorts items alphabetically by name first, then assigns sequential `stt` indices (1..N).
   - Ensure all item additions, imports, and modifications trigger this sorted reindexing.
3. [x] Update [lib/services/excel_service.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/services/excel_service.dart):
   - Ensure `generateExcel` sorts incoming items using `DrugItem.compareByName` before rendering cells.
4. [x] Create [test/drug_sorting_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/drug_sorting_test.dart):
   - Test sorting of drug names with mixed casing and Vietnamese accents (e.g. "Amoxicillin", "Áo Giáp", "Đông Trùng Hạ Thảo", "Bổ Phế", "Cephalexin", "Decolgen").
   - Test UI table rendering order after additions and Excel import.
   - Test generated Excel output ordering.
5. [x] Create [tests/test-app-upgrade-phase-02.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-app-upgrade-phase-02.py):
   - Validate exported Excel ordering via Python `openpyxl`.
   - Run `flutter test test/drug_sorting_test.dart`.

## Files to Create/Modify
- [MODIFY] [lib/models/drug_item.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/models/drug_item.dart) - Add Vietnamese-aware A-Z comparator and `sortAndReindex`.
- [MODIFY] [lib/views/dashboard_page.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/views/dashboard_page.dart) - Enforce A-Z sorting across all state mutations.
- [MODIFY] [lib/services/excel_service.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/services/excel_service.dart) - Ensure Excel rows are output in A-Z order.
- [NEW] [test/drug_sorting_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/drug_sorting_test.dart) - Unit and widget tests for A-Z sorting.
- [NEW] [tests/test-app-upgrade-phase-02.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-app-upgrade-phase-02.py) - Python verification runner for Phase 02.

## Test Criteria
- `python3 tests/test-app-upgrade-phase-02.py` passes with exit code 0.
- Drug items added in arbitrary order appear sorted A-Z in the dashboard table.
- Exported Excel files contain drug items sorted A-Z with sequential STT (1, 2, 3, ...).

---
Next Phase: [Phase 03: Application Renaming to "Tạo bill thuốc"](./phase-03-app-renaming.md)
