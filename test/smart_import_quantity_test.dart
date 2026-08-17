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
      name: 'Panadol Advance',
      brand: 'GSK',
      quyCach: 'Hộp 12 vỉ x 10 viên',
    );
  }
}

void main() {
  group('Smart Import Quantity Integration Tests', () {
    testWidgets('Types quantity in Smart Import and verifies added item quantity & reset to 1', (WidgetTester tester) async {
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

      // Verify smart import quantity selector is visible
      final smartQtyFinder = find.byKey(const ValueKey('smartImportQuantity'));
      expect(smartQtyFinder, findsOneWidget);

      final inputFinder = find.descendant(
        of: smartQtyFinder,
        matching: find.byKey(const ValueKey('quantity_selector_input')),
      );
      expect(inputFinder, findsOneWidget);
      expect(tester.widget<TextField>(inputFinder).controller?.text, '1');

      // Type quantity 25
      await tester.enterText(inputFinder, '25');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(inputFinder).controller?.text, '25');

      // Enter URL and click Fetch & Add
      await tester.enterText(find.byKey(const ValueKey('urlField')), 'https://nhathuoclongchau.com.vn/thuoc/panadol-advance');
      await tester.tap(find.byKey(const ValueKey('fetchAddButton')));
      await tester.pumpAndSettle();

      // Verify item was added with quantity 25
      expect(find.text('Panadol Advance'), findsOneWidget);
      expect(find.text('25'), findsWidgets);

      // Verify form reset: URL field is empty and quantity selector is reset to 1
      expect(tester.widget<TextField>(find.byKey(const ValueKey('urlField'))).controller?.text, isEmpty);
      expect(tester.widget<TextField>(inputFinder).controller?.text, '1');
    });

    testWidgets('Adding duplicate via Smart Import accumulates typed quantity correctly', (WidgetTester tester) async {
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

      final smartQtyFinder = find.byKey(const ValueKey('smartImportQuantity'));
      final inputFinder = find.descendant(
        of: smartQtyFinder,
        matching: find.byKey(const ValueKey('quantity_selector_input')),
      );

      // 1. First add with quantity 15
      await tester.enterText(inputFinder, '15');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('urlField')), 'https://nhathuoclongchau.com.vn/thuoc/panadol-advance');
      await tester.tap(find.byKey(const ValueKey('fetchAddButton')));
      await tester.pumpAndSettle();

      expect(find.text('Panadol Advance'), findsOneWidget);
      expect(find.text('15'), findsWidgets);

      // 2. Second add with quantity 30
      await tester.enterText(inputFinder, '30');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const ValueKey('urlField')), 'https://nhathuoclongchau.com.vn/thuoc/panadol-advance');
      await tester.tap(find.byKey(const ValueKey('fetchAddButton')));
      await tester.pumpAndSettle();

      // Total quantity should now be 45 (15 + 30)
      expect(find.text('45'), findsWidgets);
      // Input should be reset back to 1
      expect(tester.widget<TextField>(inputFinder).controller?.text, '1');
    });

    testWidgets('Smart Import increment and decrement buttons work alongside typed input', (WidgetTester tester) async {
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

      final smartQtyFinder = find.byKey(const ValueKey('smartImportQuantity'));
      final incButton = find.descendant(
        of: smartQtyFinder,
        matching: find.byKey(const ValueKey('quantity_selector_increment')),
      );
      final decButton = find.descendant(
        of: smartQtyFinder,
        matching: find.byKey(const ValueKey('quantity_selector_decrement')),
      );
      final inputFinder = find.descendant(
        of: smartQtyFinder,
        matching: find.byKey(const ValueKey('quantity_selector_input')),
      );

      // Tap increment twice: 1 -> 2 -> 3
      await tester.tap(incButton);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(inputFinder).controller?.text, '2');

      await tester.tap(incButton);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(inputFinder).controller?.text, '3');

      // Type 10
      await tester.enterText(inputFinder, '10');
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(inputFinder).controller?.text, '10');

      // Tap decrement: 10 -> 9
      await tester.tap(decButton);
      await tester.pumpAndSettle();
      expect(tester.widget<TextField>(inputFinder).controller?.text, '9');
    });
  });
}
