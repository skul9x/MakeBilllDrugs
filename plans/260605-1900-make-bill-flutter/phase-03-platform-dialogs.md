# Phase 03: Native Platform Integration
Status: ✅ Completed
Dependencies: [Phase 02: Core Parser & Excel Logic](./phase-02-core-logic.md)

## Objective
Implement native platform UI dialogs for file operations (importing spreadsheets and selecting export path destinations) using standard Flutter desktop integrations. Build a testable service wrapper that allows headless testing.

## Requirements
### Functional
- [x] **Open File Dialog**: Launch a native file picker to select `.xlsx` spreadsheets, filtering other file types.
- [x] **Save File Dialog**: Open a native system file save dialog, prompting the user to select the output directory and input the file name (`Danh_sach_thuoc.xlsx` by default).
- [x] **Mock Service Configuration**: Provide a mock or headless option in the service so verification tests can automate import/export triggers without displaying user-interactive modals.

### Non-Functional
- [x] Responsive native desktop performance (dialogs must not block the main UI thread).
- [x] Resilience against user cancellation (properly handling null outcomes without causing system crashes).

## Implementation Steps
1. [x] Create a dialog service interface `lib/services/dialog_service.dart`:
   - Methods: `Future<String?> selectSavePath()` and `Future<String?> selectImportPath()`.
2. [x] Implement the production dialog service `lib/services/dialog_service_impl.dart` using the `file_picker` package:
   - Apply specific file filters (e.g. `allowedExtensions: ['xlsx']`, `type: FileType.custom`).
3. [x] Implement a mock dialog service `lib/services/mock_dialog_service.dart` for automated tests and CI environments where graphical displays are not initialized.
4. [x] Create unit tests at `test/dialog_service_test.dart` to verify dialog wrapper configurations and fallback behaviors when the user cancels selection.

## Files to Create/Modify
- `lib/services/dialog_service.dart` - Interface definitions.
- `lib/services/dialog_service_impl.dart` - Platform-specific implementations using `file_picker`.
- `lib/services/mock_dialog_service.dart` - Mock dialog service for testing.
- `test/dialog_service_test.dart` - Test cases for native integration services.
- `tests/test-phase-03.py` - Python test validator for Phase 03.

## Test Criteria
- Code must compile without errors.
- Unit tests at `test/dialog_service_test.dart` must pass successfully.
- Python verification script `tests/test-phase-03.py` must run and exit with 0.

## Automated Verification Script
Create a file at `tests/test-phase-03.py` which:
1. Verifies that the dialog services exist and compile correctly.
2. Runs the unit test suite targeting the dialog wrappers (`flutter test test/dialog_service_test.dart`).

---
Next Phase: [Phase 04: Premium Glassmorphism UI](./phase-04-frontend-ui.md)

