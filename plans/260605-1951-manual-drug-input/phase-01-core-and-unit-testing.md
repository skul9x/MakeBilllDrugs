# Phase 01: Core & Unit Testing
Status: ✅ Completed
Dependencies: None

## Objective
Establish unit tests and logic validation for manually adding drug items. Verify that data models and helper functions correctly handle manually entered fields, validate input values (e.g., non-empty name), and process duplicate checks correctly.

## Requirements
### Functional
- Verify `DrugItem` can be instantiated and compared against existing entries.
- Implement duplicate detection logic that is case-insensitive on Name, Brand, and Packaging Specification.
- Verify quantity accumulates correctly for manual duplicates.
- Ensure proper validation (e.g., throwing/handling errors if manual Drug Name is empty).

### Non-Functional
- Test execution must run cleanly in under 5 seconds.

## Implementation Steps
1. [x] Create [manual_input_unit_test.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/test/manual_input_unit_test.dart) in `test/` to test manual list manipulation, duplicate checking, and empty-name validations.
2. [x] Write [test-manual-input-phase-01.py](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/tests/test-manual-input-phase-01.py) to run and assert that the new Dart unit tests pass.

## Files to Create/Modify
- [NEW] [manual_input_unit_test.dart](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/test/manual_input_unit_test.dart) - Unit tests for manual drug addition logic.
- [NEW] [test-manual-input-phase-01.py](file:///home/skul9x/Desktop/Test_code/Drugs%20Maker%20Flutter/tests/test-manual-input-phase-01.py) - Python verifier script for Phase 1.

## Test Criteria
- `test-manual-input-phase-01.py` runs and prints a green success output.
- All Dart tests in `test/manual_input_unit_test.dart` pass.

---
Next Phase: [Phase 02: Dashboard UI Enhancement](./phase-02-ui-implementation.md)
