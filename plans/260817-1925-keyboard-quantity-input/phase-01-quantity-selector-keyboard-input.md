# Phase 01: QuantitySelector Keyboard Input Widget

Status: ✅ Completed
Dependencies: None

## Objective
Upgrade `QuantitySelector` widget from a static text display into a stateful, editable numeric input widget with keyboard input support, while retaining `+` and `-` stepper buttons.

## Requirements
### Functional
- Replace the static `Text('$value')` inside `QuantitySelector` with an inline `TextField` / `TextFormField`.
- Support direct keyboard typing of positive integer numbers.
- Filter input with `FilteringTextInputFormatter.digitsOnly` to prevent letters and negative symbols.
- Automatically synchronize internal `TextEditingController` text whenever external `value` prop changes (e.g. when reset to 1 upon form submission or row data changes).
- Enforce minimum value validation (`min`, default 1).
- Handle focus loss (unfocus/blur) and submission (`onSubmitted` / `onEditingComplete`): if the field is empty, 0, or below `min`, clamp/reset it to `min` and notify `onChanged`.
- Maintain full compatibility with existing `+` and `-` buttons.
- Expose a clear `ValueKey` or accessibility key for robust automated testing.

### Non-Functional
- Compact and elegant glassmorphism styling consistent with `GlassTheme`.
- No visual glitches or horizontal overflow when typing multi-digit numbers (e.g., 100, 500).

## Implementation Steps
1. [x] Convert `QuantitySelector` in [lib/views/widgets/quantity_selector.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/views/widgets/quantity_selector.dart) from `StatelessWidget` to `StatefulWidget`.
2. [x] Add `TextEditingController` and `FocusNode` with listener for blur validation and `didUpdateWidget` sync.
3. [x] Configure `TextField` with `TextInputType.number`, `TextAlign.center`, proper padding, and input formatter.
4. [x] Create [test/quantity_selector_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/quantity_selector_test.dart) testing:
   - Initial value rendering.
   - Typing new values via keyboard.
   - Fallback/clamp when typing invalid or below-min values.
   - Stepper `+` and `-` button interactions updating the text field.
5. [x] Create [tests/test-quantity-phase-01.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-quantity-phase-01.py) test runner script.

## Files to Create/Modify
- [MODIFY] [quantity_selector.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/lib/views/widgets/quantity_selector.dart) - Implement editable text field in `QuantitySelector`.
- [NEW] [quantity_selector_test.dart](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/test/quantity_selector_test.dart) - Flutter unit and widget tests for `QuantitySelector`.
- [NEW] [test-quantity-phase-01.py](file:///home/skul9x/Desktop/Test_code/MakeBilllDrugs-main/tests/test-quantity-phase-01.py) - Python verification runner for Phase 01.

## Test Criteria
- `python3 tests/test-quantity-phase-01.py` executes successfully.
- All widget tests in `test/quantity_selector_test.dart` pass without error.

---
Next Phase: [Phase 02: Smart & Manual Input Integration](./phase-02-smart-and-manual-input-integration.md)
