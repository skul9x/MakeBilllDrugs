# Phase 02: Core Parser & Excel Logic
Status: ✅ Completed
Dependencies: [Phase 01: Setup Environment](./phase-01-setup.md)

## Objective
Implement and verify the core Dart business logic for drug data extraction and Excel import/export processing. This phase executes as a pure Dart library package, allowing fast CLI-based testing without visual GUI dependencies.

## Requirements
### Functional
- [x] **HTTP Fetch & Scraper**: Download HTML from remote URLs with a standard browser User-Agent or read local files.
- [x] **HTML DOM Parser**: Parse HTML to extract:
  - **Drug Name**: `h1` element or fallbacks (`.product-name`, `.entry-title`, `.title-detail`).
  - **Quy Cách (Packaging)**: Table cell traversal, lists, or fallback regex `(?i)(?:Quy cách đóng gói|Đóng gói)\s*:\s*([^.\n\r]+)`.
  - **Brand**: ID `#cs-thuong-hieu` td cells, table row cells with "thương hiệu"/"brand", comma cleaning, and "An Thiên" replacement rule.
- [x] **Excel Exporter**: Generate a spreadsheet with columns `STT`, `Tên thuốc`, `Thương hiệu`, `Quy cách`, `Số lượng`, using slate-gray header background (`#E2E8F0`), Inter font, cell borders, correct alignments, and auto-fit column widths.
- [x] **Excel Importer**: Read spreadsheets, support both legacy 4-column and standard 5-column configurations, validate columns, and parse elements back into `DrugItem` objects.

### Non-Functional
- [x] Pure Dart implementations that do not depend on the Flutter rendering pipeline (to support simple unit tests).
- [x] Robust error handling for network requests and corrupt spreadsheet uploads.

## Implementation Steps
1. [x] Create model classes:
   - `lib/models/drug_info.dart`: properties `name`, `brand`, `quyCach`.
   - `lib/models/drug_item.dart`: properties `stt`, `name`, `brand`, `quyCach`, `quantity`.
2. [x] Create scraper and DOM parser service at `lib/services/drug_parser.dart`:
   - Methods: `Future<DrugInfo> extractDrugInfo(String htmlContent)` and `Future<DrugInfo> fetchAndParse(String source)`.
   - Use `package:html/parser.dart` to query DOM nodes.
3. [x] Create Excel manager service at `lib/services/excel_service.dart`:
   - Methods: `Future<void> generateExcel(List<DrugItem> items, String outputPath)` and `Future<List<DrugItem>> importExcel(String filePath)`.
   - Apply specific formatting (header font Inter Bold, cell borders, alignment, padding row heights).
4. [x] Write unit test file at `test/core_logic_test.dart` to cover DOM extraction on offline mockup HTML and roundtrip Excel generation & import.

## Files to Create/Modify
- `lib/models/drug_info.dart` - Data model representing extracted info.
- `lib/models/drug_item.dart` - Data model representing a table row entry.
- `lib/services/drug_parser.dart` - Scraping and regex parser implementation.
- `lib/services/excel_service.dart` - Excel file builder and parser implementation.
- `test/core_logic_test.dart` - Dart unit test script.
- `tests/test-phase-02.py` - Python test validator for Phase 02.

## Test Criteria
- `test/core_logic_test.dart` must pass successfully using `dart test`.
- Visual validation of generated Excel files must match headers, cell styles, fonts, and columns.
- Python validation script `tests/test-phase-02.py` must run and exit with 0.

## Automated Verification Script
Create a file at `tests/test-phase-02.py` which:
1. Checks for file structure of the models and services.
2. Invokes `dart test test/core_logic_test.dart` to execute unit tests.
3. Checks if a temporary Excel file is successfully generated and matches openpyxl checks (like headers and values).

---
Next Phase: [Phase 03: Native Platform Integration](./phase-03-platform-dialogs.md)
