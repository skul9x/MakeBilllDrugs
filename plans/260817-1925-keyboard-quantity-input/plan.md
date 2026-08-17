# Plan: Keyboard Input for Quantity in Smart & Manual Input

Created: 2026-08-17 19:25
Status: ✅ Completed

## Overview
Enable direct keyboard numeric input for the `Quantity` field across the application—specifically in **Smart Import**, **Manual Input**, and the editable table rows. Currently, users are restricted to incrementing and decrementing via mouse clicks on `+` and `-` buttons. This plan introduces an editable numeric text field within `QuantitySelector` while retaining the `+` / `-` buttons, complete with input filtering, automatic clamping/validation, focus handling, and comprehensive unit/UI/E2E tests.

## Tech Stack
- Framework: Flutter Desktop (Linux/Windows)
- State Management: Stateful Widgets (`StatefulWidget`, `TextEditingController`, `FocusNode`)
- Testing: Flutter Test (`flutter test`) & Python Test Runners (`subprocess`)

## Phases

| Phase | Name | Status | Progress |
|-------|------|--------|----------|
| 01 | [Phase 01: QuantitySelector Keyboard Input Widget](./phase-01-quantity-selector-keyboard-input.md) | ✅ Completed | 100% |
| 02 | [Phase 02: Smart & Manual Input Integration](./phase-02-smart-and-manual-input-integration.md) | ✅ Completed | 100% |
| 03 | [Phase 03: End-to-End & Table Verification](./phase-03-e2e-and-table-verification.md) | ✅ Completed | 100% |

## Verification Strategy
Each phase includes:
1. Dedicated Flutter unit or widget test in `test/`.
2. Dedicated automated test verification script in `tests/test-quantity-phase-XX.py`.
3. All tests must execute cleanly and return green exit codes.

## Quick Commands
- Execute Phase 1: `/code phase-01`
- Execute Phase 2: `/code phase-02`
- Execute Phase 3: `/code phase-03`
