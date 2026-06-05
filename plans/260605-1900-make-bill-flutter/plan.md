# Plan: Drugs Maker Flutter - Desktop App for Drug Billing
Created: 2026-06-05
Status: 🟡 In Progress
Current Phase: Phase 01: Setup Environment

## 1. Overview
The **Drugs Maker Flutter** application is a cross-platform desktop application (targeting Linux and Windows) written in Dart and Flutter. It provides the same functionality as the original `Make-Bill` Wails-based application:
- **Input:** URL of a drug page (online Central Pharmacy or offline local HTML copies) along with quantity inputs.
- **Processing:** Extracts the **Drug Name** (using HTML parser selectors), **Packaging Specification (Quy Cách)** (via table parsing, leaf node scanning, and regex fallback), and **Brand** (CS brand selector or table row parser).
- **Interactive State:** A premium glassmorphism dashboard containing a live reactive table of drug items. STT (index) is dynamically recalculated, and rows can be added, updated, or removed with real-time recalculations.
- **Output:** Exports the drug list as an enterprise-grade formatted Excel spreadsheet (.xlsx) using the system save dialog, auto-fitting column widths and styling headers.
- **Import:** Imports an existing spreadsheet matching the template to restore the table state.

## 2. Tech Stack
- **Framework:** [Flutter Desktop](https://flutter.dev/multi-platform/desktop) (Dart)
- **HTML Parsing:** [`html`](https://pub.dev/packages/html) package (CSS selector and DOM parsing)
- **Excel Generation:** [`excel`](https://pub.dev/packages/excel) package (creating and formatting spreadsheets)
- **HTTP Client:** [`http`](https://pub.dev/packages/http) package (handling requests with custom User-Agent headers)
- **File Dialogs:** [`file_picker`](https://pub.dev/packages/file_picker) package (native save/open dialogs)
- **State Management:** Flutter standard state management (or `provider` if required for premium UI components)
- **UI Design:** Vanilla Flutter Widgets with custom design tokens, backdrop filters for glassmorphism, Outfit and Inter Google Fonts.

## 3. Progress Tracker

| Phase | Name | Status | Progress | Description |
|-------|------|--------|----------|-------------|
| [01](./phase-01-setup.md) | Setup Environment | ⬜ Pending | 0% | Install Flutter SDK, initialize the Flutter desktop skeleton, configure dependencies, and verify compilation. |
| [02](./phase-02-core-logic.md) | Core Parser & Excel Logic | ⬜ Pending | 0% | Implement drug info scraper (HTTP/Local HTML extraction) & Excel export/import module in Dart. |
| [03](./phase-03-platform-dialogs.md) | Native Platform Integration | ⬜ Pending | 0% | Connect file picking, folder choosing, and saving APIs for Windows and Linux. |
| [04](./phase-04-frontend-ui.md) | Premium Glassmorphism UI | ⬜ Pending | 0% | Build the responsive glassmorphism dashboard, reactive live table, and user notification toasts. |
| [05](./phase-05-e2e-testing.md) | E2E Testing & Distribution Packaging | ⬜ Pending | 0% | E2E Python verification scripts, automated builds for Windows and Linux (.deb package and portable zip). |

## 4. Quick Commands
- Start Phase 1 Verification: `python3 tests/test-phase-01.py`
- Check progress: `/next`
- Save context: `/save-brain`
