# Phase 01: Excel Export Formatting & Auto-Fit Optimization

Status: 🟢 Completed
Dependencies: None

## Objective
Upgrade `ExcelService` so that all exported Excel spreadsheets use **Times New Roman** as the default font, font size **12pt**, and dynamically calculate optimal column widths and row heights to prevent text clipping across languages and UTF-8 multi-byte characters.

## Requirements
### Functional
- Default font family for all cells (headers, text data, numbers) must be `'Times New Roman'`.
- Default font size for all cells (headers and data rows) must be `12`.
- Row height must be automatically fitted:
  - Header row height: `28.0` pt (providing comfortable breathing room for 12pt bold text).
  - Data row height: `24.0` pt (matching standard 12pt line height).
- Column width must be dynamically calculated for every column:
  - Base width on maximum cell character length (including header and all row values).
  - Incorporate UTF-8 rune length multiplier (`* 1.25` for Vietnamese accented characters) to account for proportional font metrics in Times New Roman 12pt.
  - Add appropriate padding margin (`+ 5` width units) and establish a minimum column width of `12.0`.
- Preserve cell border styles, alignments (Left for text, Center for STT & Quantity), and slate-gray header background styling.

### Non-Functional
- Generated `.xlsx` files must be 100% compliant with standard spreadsheet viewers (Microsoft Excel, LibreOffice Calc, Google Sheets).
- Fast generation performance without memory leaks when processing hundreds of rows.

## Implementation Steps
1. [x] Update `lib/services/excel_service.dart`:
   - Set `fontFamily: 'Times New Roman'` and `fontSize: 12` in `headerStyle`, `dataLeftStyle`, and `dataCenterStyle`.
   - Update `sheet.setRowHeight(0, 28.0)` for header and `sheet.setRowHeight(rowIdx, 24.0)` for data rows.
   - Refactor column width calculation loop with 12pt font metric scaling factor and minimum width threshold.
2. [x] Create [test/excel_formatting_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/excel_formatting_test.dart):
   - Test generating Excel with Vietnamese characters and verify file creation.
   - Test font attributes, cell values, and column/row dimensions in `ExcelService`.
3. [x] Create [tests/test-app-upgrade-phase-01.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-app-upgrade-phase-01.py):
   - Use `openpyxl` to inspect the generated `.xlsx` output.
   - Assert all cells have `font.name == 'Times New Roman'` and `font.size == 12`.
   - Assert row heights and column dimensions are within expected auto-fit bounds.
   - Run `flutter test test/excel_formatting_test.dart`.

## Files to Create/Modify
- [MODIFY] [lib/services/excel_service.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/services/excel_service.dart) - Set Times New Roman 12pt font & auto-fit metrics.
- [NEW] [test/excel_formatting_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/excel_formatting_test.dart) - Unit test for Excel export styling.
- [NEW] [tests/test-app-upgrade-phase-01.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-app-upgrade-phase-01.py) - Python verification runner for Phase 01.

## Test Criteria
- `python3 tests/test-app-upgrade-phase-01.py` completes with exit code 0.
- All cell font families in exported Excel are strictly `Times New Roman`.
- All cell font sizes are strictly `12`.
- Column widths and row heights are non-zero and properly auto-sized.

---
Next Phase: [Phase 02: Drug List Alphabetical Sorting (A-Z)](./phase-02-drug-list-az-sorting.md)
