import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/views/dashboard_page.dart';
import 'package:drugs_maker/services/mock_dialog_service.dart';
import 'package:drugs_maker/models/drug_item.dart';

void main() {
  testWidgets('Manual Input UI Tests - Tab Switching and Field Verification', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(1280, 800));

    final mockDialogService = MockDialogService(
      mockImportPath: '/mock/path/import.xlsx',
      mockSavePath: '/mock/path/export.xlsx',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(dialogService: mockDialogService),
      ),
    );

    // Verify initial state: Smart Import mode is active
    expect(find.byKey(const ValueKey('tabSmartImport')), findsOneWidget);
    expect(find.byKey(const ValueKey('tabManualInput')), findsOneWidget);
    expect(find.byKey(const ValueKey('urlField')), findsOneWidget);
    expect(find.byKey(const ValueKey('fetchAddButton')), findsOneWidget);

    // Verify manual input fields do not exist yet
    expect(find.byKey(const ValueKey('nameField')), findsNothing);
    expect(find.byKey(const ValueKey('brandField')), findsNothing);
    expect(find.byKey(const ValueKey('quyCachField')), findsNothing);
    expect(find.byKey(const ValueKey('addManuallyButton')), findsNothing);

    // Switch to Manual Input
    await tester.tap(find.byKey(const ValueKey('tabManualInput')));
    await tester.pumpAndSettle();

    // Verify Smart Import fields are hidden
    expect(find.byKey(const ValueKey('urlField')), findsNothing);
    expect(find.byKey(const ValueKey('fetchAddButton')), findsNothing);

    // Verify Manual Input fields are now visible
    expect(find.byKey(const ValueKey('nameField')), findsOneWidget);
    expect(find.byKey(const ValueKey('brandField')), findsOneWidget);
    expect(find.byKey(const ValueKey('quyCachField')), findsOneWidget);
    expect(find.byKey(const ValueKey('addManuallyButton')), findsOneWidget);
  });

  testWidgets('Manual Input UI Tests - Validation and Add Logic', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(1280, 800));

    final mockDialogService = MockDialogService(
      mockImportPath: '/mock/path/import.xlsx',
      mockSavePath: '/mock/path/export.xlsx',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(dialogService: mockDialogService),
      ),
    );

    // Switch to Manual Input
    await tester.tap(find.byKey(const ValueKey('tabManualInput')));
    await tester.pumpAndSettle();

    // Try to add empty name, should show warning toast
    await tester.tap(find.byKey(const ValueKey('addManuallyButton')));
    await tester.pumpAndSettle();

    expect(find.text('Tên thuốc không được để trống'), findsOneWidget);

    // Enter valid details
    await tester.enterText(find.byKey(const ValueKey('nameField')), 'Panadol Extra');
    await tester.enterText(find.byKey(const ValueKey('brandField')), 'GSK');
    await tester.enterText(find.byKey(const ValueKey('quyCachField')), 'Hộp 12 vỉ x 10 viên');

    // Tap add
    await tester.tap(find.byKey(const ValueKey('addManuallyButton')));
    await tester.pumpAndSettle();

    // Verify success toast and table record
    expect(find.text('Added "Panadol Extra" successfully!'), findsOneWidget);
    expect(find.text('Panadol Extra'), findsOneWidget);
    expect(find.text('GSK'), findsOneWidget);
    expect(find.text('Hộp 12 vỉ x 10 viên'), findsOneWidget);

    // Verify fields were cleared
    expect(tester.widget<TextField>(find.byKey(const ValueKey('nameField'))).controller?.text, isEmpty);
    expect(tester.widget<TextField>(find.byKey(const ValueKey('brandField'))).controller?.text, isEmpty);
    expect(tester.widget<TextField>(find.byKey(const ValueKey('quyCachField'))).controller?.text, isEmpty);

    // Add duplicate and verify quantity accumulates
    await tester.enterText(find.byKey(const ValueKey('nameField')), 'Panadol Extra');
    await tester.enterText(find.byKey(const ValueKey('brandField')), 'GSK');
    await tester.enterText(find.byKey(const ValueKey('quyCachField')), 'Hộp 12 vỉ x 10 viên');

    await tester.tap(find.byKey(const ValueKey('addManuallyButton')));
    await tester.pumpAndSettle();

    // The count of units (quantity selector values) should be 2
    expect(find.text('2'), findsWidgets);
  });
}
