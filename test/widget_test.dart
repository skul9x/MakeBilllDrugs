import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/main.dart';
import 'package:drugs_maker/views/dashboard_page.dart';

void main() {
  testWidgets('App launches and displays DashboardPage', (WidgetTester tester) async {
    final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(1280, 800));

    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that DashboardPage is displayed by checking for its main header.
    expect(find.text('Tạo bill thuốc'), findsOneWidget);
    expect(find.text('Premium Glassmorphism Manager'), findsOneWidget);
    expect(find.byType(DashboardPage), findsOneWidget);
  });
}
