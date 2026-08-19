import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/main.dart';

void main() {
  group('App Naming Verification Tests', () {
    testWidgets('MaterialApp has title "Tạo bill thuốc"', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.title, 'Tạo bill thuốc');
    });

    testWidgets('DashboardPage header displays "Tạo bill thuốc"', (WidgetTester tester) async {
      final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
      await binding.setSurfaceSize(const Size(1280, 800));

      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.text('Tạo bill thuốc'), findsOneWidget);
    });
  });
}
