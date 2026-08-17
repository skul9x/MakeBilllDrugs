import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/views/dashboard_page.dart';
import 'package:drugs_maker/services/mock_dialog_service.dart';
import 'package:drugs_maker/views/widgets/glass_card.dart';
import 'package:drugs_maker/views/widgets/quantity_selector.dart';

void main() {
  testWidgets('DashboardPage renders correctly with key UI components', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(1280, 800));

    final mockDialogService = MockDialogService(
      mockImportPath: '/mock/path/import.xlsx',
      mockSavePath: '/mock/path/export.xlsx',
    );

    // Build the DashboardPage inside a MaterialApp
    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(dialogService: mockDialogService),
      ),
    );

    // Verify header and page titles exist
    expect(find.text('Drugs Maker'), findsOneWidget);
    expect(find.text('Premium Glassmorphism Manager'), findsOneWidget);
    expect(find.text('Add Drug Source'), findsOneWidget);

    // Verify text field exists
    expect(find.byKey(const ValueKey('urlField')), findsOneWidget);

    // Verify quantity selector exists
    expect(find.byType(QuantitySelector), findsWidgets);

    // Verify buttons exist
    expect(find.text('Fetch & Add'), findsOneWidget);
    expect(find.text('Import Excel'), findsOneWidget);
    expect(find.text('Export Excel'), findsOneWidget);
    expect(find.text('Clear All'), findsOneWidget);

    // Verify initial state table message
    expect(find.text('No drug items parsed yet.'), findsOneWidget);
  });
}
