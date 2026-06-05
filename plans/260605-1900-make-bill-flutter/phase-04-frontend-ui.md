# Phase 04: Premium Glassmorphism UI
Status: ✅ Completed
Dependencies: [Phase 03: Native Platform Integration](./phase-03-platform-dialogs.md)

## Objective
Design and implement a premium desktop interface mirroring the original Glassmorphism styling. The UI must feature responsive desktop layouts, typography (Outfit & Inter), smooth micro-animations, a live reactive data table, and an custom in-app Toast notification panel.

## Requirements
### Functional
- **Input Panel**: URL/path text input, quantity selector with numeric adjustments (plus/minus buttons), and a submit button displaying active scraping loading spinner states.
- **Reactive Live Table**:
  - Automatically re-indexed STT rows upon adding, editing, or deleting items.
  - Control buttons on each row for incrementing/decrementing quantities, and row removal.
  - Badges displaying summary data (e.g. total row items, total product units).
- **Control Bar**: Primary actions to "Export Excel", "Import Excel", and "Clear All" items.
- **Custom Toast System**: Non-blocking pop-up messages (Success, Warning, Error) with animated entrances and exits.
- **Desktop Interactivity**: Supports keyboard hotkeys (e.g., Enter key submits the input URL, Arrow keys or custom key bindings for navigating table rows).

### Non-Functional
- **Glassmorphism Aesthetic**: Vibrant backdrops, subtle white borders, backdrop-filter blurs, neon/pastel colors (avoiding plain default colors).
- **Typography & Font sizes**: Modern text styles utilizing 'Outfit' for headers and 'Inter' for tables and general readouts.

## Implementation Steps
1. [x] Configure styling parameters and assets inside `lib/core/constants.dart` and `lib/core/theme.dart`:
   - Setup HSL-based color schemes, gradients, border-radius configurations, and custom box-shadow decorations.
2. [x] Implement custom reusable widgets:
   - `lib/views/widgets/glass_card.dart` - Box with backdrop filter blur and translucent borders.
   - `lib/views/widgets/toast_overlay.dart` - Toast manager widget displaying animated alerts.
   - `lib/views/widgets/quantity_selector.dart` - Input block with plus/minus actions.
3. [x] Implement the primary workspace:
   - `lib/views/dashboard_page.dart` - Contains layout grid splitting the input module and the data table.
4. [x] Wire widgets to logic controllers:
   - Connect web scraper hooks to updates in the table state.
   - Hook dialog services to import/export triggers.
5. [x] Write UI unit tests or widget tests in `test/ui_widget_test.dart` to verify that input widgets, live tables, and toast alerts render without overflowing boundaries.

## Files to Create/Modify
- `lib/core/theme.dart` - Global custom glassmorphism theme and styling parameters.
- `lib/views/dashboard_page.dart` - Main dashboard UI.
- `lib/views/widgets/glass_card.dart` - Base glass container.
- `lib/views/widgets/toast_overlay.dart` - Dialog feedback toast system.
- `lib/views/widgets/quantity_selector.dart` - Custom quantity counter controls.
- `test/ui_widget_test.dart` - Flutter Widget test suite.
- `tests/test-phase-04.py` - Python test validator for Phase 04.

## Test Criteria
- Main widgets render successfully during headless widget tests.
- UI elements must comply with styling rules (fonts, blurs).
- Verification script `tests/test-phase-04.py` must run and exit with 0.

## Automated Verification Script
Create a file at `tests/test-phase-04.py` that:
1. Validates source files existence.
2. Inspects `lib/` files using regex to verify the implementation of glass cards, Google Fonts (Outfit & Inter), toasts, and reactive table widgets.
3. Triggers `flutter test test/ui_widget_test.dart` to verify widget integrity.

---
Next Phase: [Phase 05: E2E Testing & Distribution Packaging](./phase-05-e2e-testing.md)
