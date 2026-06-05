# Phase 02: Dashboard UI Enhancement
Status: ✅ Completed
Dependencies: [Phase 01: Core & Unit Testing](./phase-01-core-and-unit-testing.md)

## Objective
Design and implement the UI changes to support manual input in the Left Panel of the Dashboard. Use a segmented toggle/tab interface matching the dark glassmorphism theme, validate field entries, and ensure user notifications are correctly displayed.

## Requirements
### Functional
- Add a visual input-mode switch tab (e.g., "Smart Import" vs "Manual Input") using premium styling (neon border, translucent backdrop).
- If "Smart Import":
  - Show the existing URL/Path input field.
- If "Manual Input":
  - Show text fields for **Tên thuốc** (Drug Name), **Thương hiệu** (Brand), and **Quy cách** (Packaging Spec).
  - All text fields must match the design tokens defined in [theme.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/core/theme.dart) (translucent background, white text, Inter font, custom focus border).
- Integrate validation so that attempting to add an item with an empty "Tên thuốc" shows a warning toast overlay.
- Clicking "Add Manually" adds the item to the list (re-indexing and checking for duplicates) and shows a success toast.

### Non-Functional
- Smooth fade/slide transitions when switching tabs to maintain premium feel.
- Fully responsive layout inside the 320px Left Panel width.

## Implementation Steps
1. [x] Modify [dashboard_page.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/views/dashboard_page.dart) to introduce an `_inputMode` enum or state variable, render the segmented switch tab, toggle rendering of fields, validate inputs, and update state.
2. [x] Create [manual_input_ui_test.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/test/manual_input_ui_test.dart) to verify the tab toggles, fields existence, text entry, button action, and toast overlays.
3. [x] Create [test-manual-input-phase-02.py](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/tests/test-manual-input-phase-02.py) to check the UI source code content and run the Flutter widget tests.

## Files to Create/Modify
- [MODIFY] [dashboard_page.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/lib/views/dashboard_page.dart) - Add the input mode UI tabs, text fields, and state logic.
- [NEW] [manual_input_ui_test.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/test/manual_input_ui_test.dart) - Widget tests verifying the tab toggles and inputs.
- [NEW] [test-manual-input-phase-02.py](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/tests/test-manual-input-phase-02.py) - Python verifier script for Phase 2.

## Test Criteria
- UI widget tests in `test/manual_input_ui_test.dart` pass.
- `test-manual-input-phase-02.py` reports success.

---
Next Phase: [Phase 03: Integration & E2E Verification](./phase-03-integration-e2e.md)
