import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/models/drug_info.dart';
import 'package:drugs_maker/services/drug_parser.dart';
import 'package:drugs_maker/services/mock_dialog_service.dart';
import 'package:drugs_maker/views/dashboard_page.dart';

class FakeDrugParser extends DrugParser {
  final Map<String, DrugInfo> responses;

  FakeDrugParser({this.responses = const {}});

  @override
  Future<DrugInfo> fetchAndParse(String source) async {
    if (responses.containsKey(source)) {
      return responses[source]!;
    }
    return DrugInfo(
      name: 'Panadol Extra',
      brand: 'GSK',
      quyCach: 'Hộp 100 viên',
    );
  }
}

void main() {
  group('Table Row Quantity Edit and End-to-End Verification Tests', () {
    testWidgets('Edits table row quantity using direct keyboard input and verifies state', (WidgetTester tester) async {
      final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
      await binding.setSurfaceSize(const Size(1280, 800));

      final mockDialogService = MockDialogService();
      final fakeDrugParser = FakeDrugParser();

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardPage(
            dialogService: mockDialogService,
            drugParser: fakeDrugParser,
          ),
        ),
      );

      // Add first item via Smart Import
      await tester.enterText(find.byKey(const ValueKey('urlField')), 'https://nhathuoclongchau.com.vn/thuoc/panadol-extra');
      await tester.tap(find.byKey(const ValueKey('fetchAddButton')));
      await tester.pumpAndSettle();

      // Verify item row is present in the table
      expect(find.text('Panadol Extra'), findsOneWidget);

      // Find the row QuantitySelector input field
      final tableQtyFinder = find.descendant(
        of: find.byType(ListView),
        matching: find.byKey(const ValueKey('quantity_selector_input')),
      );
      expect(tableQtyFinder, findsOneWidget);
      expect(tester.widget<TextField>(tableQtyFinder).controller?.text, '1');

      // Edit row quantity to 75 via direct keyboard input
      await tester.enterText(tableQtyFinder, '75');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      expect(tester.widget<TextField>(tableQtyFinder).controller?.text, '75');
    });

    testWidgets('Table row increment and decrement buttons update row quantity and sync with keyboard input', (WidgetTester tester) async {
      final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
      await binding.setSurfaceSize(const Size(1280, 800));

      final mockDialogService = MockDialogService();
      final fakeDrugParser = FakeDrugParser();

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardPage(
            dialogService: mockDialogService,
            drugParser: fakeDrugParser,
          ),
        ),
      );

      // Switch to Manual Input tab
      await tester.tap(find.byKey(const ValueKey('tabManualInput')));
      await tester.pumpAndSettle();

      // Add item via Manual Input
      await tester.enterText(find.byKey(const ValueKey('nameField')), 'Vitamin C');
      await tester.enterText(find.byKey(const ValueKey('brandField')), 'DHG');
      await tester.enterText(find.byKey(const ValueKey('quyCachField')), 'Hộp 20 ống');

      // Set manual quantity to 5 before adding
      final manualQtyInput = find.descendant(
        of: find.byKey(const ValueKey('manualInputQuantity')),
        matching: find.byKey(const ValueKey('quantity_selector_input')),
      );
      await tester.enterText(manualQtyInput, '5');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('addManuallyButton')));
      await tester.pumpAndSettle();

      expect(find.text('Vitamin C'), findsOneWidget);

      // Table row QuantitySelector buttons and input
      final rowQtyInput = find.descendant(
        of: find.byType(ListView),
        matching: find.byKey(const ValueKey('quantity_selector_input')),
      );
      final rowIncButton = find.descendant(
        of: find.byType(ListView),
        matching: find.byKey(const ValueKey('quantity_selector_increment')),
      );
      final rowDecButton = find.descendant(
        of: find.byType(ListView),
        matching: find.byKey(const ValueKey('quantity_selector_decrement')),
      );

      expect(tester.widget<TextField>(rowQtyInput).controller?.text, '5');

      // Increment row quantity: 5 -> 6
      await tester.tap(rowIncButton);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(rowQtyInput).controller?.text, '6');

      // Decrement row quantity twice: 6 -> 5 -> 4
      await tester.tap(rowDecButton);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(rowQtyInput).controller?.text, '5');

      await tester.tap(rowDecButton);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(rowQtyInput).controller?.text, '4');

      // Direct keyboard input change to 50
      await tester.enterText(rowQtyInput, '50');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(rowQtyInput).controller?.text, '50');
    });

    testWidgets('Multiple table rows each maintain independent quantity state with direct input edits', (WidgetTester tester) async {
      final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
      await binding.setSurfaceSize(const Size(1280, 800));

      final mockDialogService = MockDialogService();
      final fakeDrugParser = FakeDrugParser(responses: {
        'https://url1': DrugInfo(name: 'Medicine A', brand: 'Brand A', quyCach: 'Hộp 10 viên'),
        'https://url2': DrugInfo(name: 'Medicine B', brand: 'Brand B', quyCach: 'Hộp 20 viên'),
      });

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardPage(
            dialogService: mockDialogService,
            drugParser: fakeDrugParser,
          ),
        ),
      );

      // Add Medicine A
      await tester.enterText(find.byKey(const ValueKey('urlField')), 'https://url1');
      await tester.tap(find.byKey(const ValueKey('fetchAddButton')));
      await tester.pumpAndSettle();

      // Add Medicine B
      await tester.enterText(find.byKey(const ValueKey('urlField')), 'https://url2');
      await tester.tap(find.byKey(const ValueKey('fetchAddButton')));
      await tester.pumpAndSettle();

      expect(find.text('Medicine A'), findsOneWidget);
      expect(find.text('Medicine B'), findsOneWidget);

      final rowInputs = find.descendant(
        of: find.byType(ListView),
        matching: find.byKey(const ValueKey('quantity_selector_input')),
      );
      expect(rowInputs, findsNWidgets(2));

      // Edit row 1 to 12
      await tester.enterText(rowInputs.at(0), '12');
      await tester.pumpAndSettle();

      // Edit row 2 to 34
      await tester.enterText(rowInputs.at(1), '34');
      await tester.pumpAndSettle();

      expect(tester.widget<TextField>(rowInputs.at(0)).controller?.text, '12');
      expect(tester.widget<TextField>(rowInputs.at(1)).controller?.text, '34');
    });
  });
}
