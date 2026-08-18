import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/views/dashboard_page.dart';
import 'package:drugs_maker/services/mock_dialog_service.dart';

void main() {
  testWidgets('Responsive UI - Desktop view (1200x800) renders side-by-side layout without mobile tabs', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(dialogService: MockDialogService()),
      ),
    );
    await tester.pumpAndSettle();

    // Desktop should have both Smart Import fields and table visible simultaneously
    expect(find.byKey(const ValueKey('mobileTabInput')), findsNothing);
    expect(find.byKey(const ValueKey('mobileTabTable')), findsNothing);
    expect(find.byKey(const ValueKey('tabSmartImport')), findsOneWidget);
    expect(find.text('No drug items parsed yet.'), findsOneWidget);
  });

  testWidgets('Responsive UI - Mobile view (390x800) renders mobile tab switcher and toggles views', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: DashboardPage(dialogService: MockDialogService()),
      ),
    );
    await tester.pumpAndSettle();

    // Mobile tabs should be present
    expect(find.byKey(const ValueKey('mobileTabInput')), findsOneWidget);
    expect(find.byKey(const ValueKey('mobileTabTable')), findsOneWidget);

    // Initial tab is Input -> should find input form
    expect(find.byKey(const ValueKey('tabSmartImport')), findsOneWidget);
    expect(find.text('No drug items parsed yet.'), findsNothing);

    // Switch to Table tab
    await tester.tap(find.byKey(const ValueKey('mobileTabTable')));
    await tester.pumpAndSettle();

    // Table view should now be visible
    expect(find.text('No drug items parsed yet.'), findsOneWidget);
    expect(find.byKey(const ValueKey('tabSmartImport')), findsNothing);

    // Switch back to Input tab
    await tester.tap(find.byKey(const ValueKey('mobileTabInput')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('tabSmartImport')), findsOneWidget);
  });
}
