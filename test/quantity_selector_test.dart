import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drugs_maker/views/widgets/quantity_selector.dart';

void main() {
  testWidgets('QuantitySelector displays initial value correctly', (WidgetTester tester) async {
    int currentValue = 5;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return QuantitySelector(
                value: currentValue,
                onChanged: (val) {
                  setState(() {
                    currentValue = val;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    final inputFinder = find.byKey(const ValueKey('quantity_selector_input'));
    expect(inputFinder, findsOneWidget);
    expect(find.widgetWithText(TextField, '5'), findsOneWidget);
  });

  testWidgets('QuantitySelector increments and decrements correctly via buttons', (WidgetTester tester) async {
    int currentValue = 2;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return QuantitySelector(
                value: currentValue,
                min: 1,
                onChanged: (val) {
                  setState(() {
                    currentValue = val;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    final incFinder = find.byKey(const ValueKey('quantity_selector_increment'));
    final decFinder = find.byKey(const ValueKey('quantity_selector_decrement'));

    // Increment
    await tester.tap(incFinder);
    await tester.pump();
    expect(currentValue, 3);
    expect(find.widgetWithText(TextField, '3'), findsOneWidget);

    // Decrement
    await tester.tap(decFinder);
    await tester.pump();
    expect(currentValue, 2);
    expect(find.widgetWithText(TextField, '2'), findsOneWidget);

    // Decrement to min (1)
    await tester.tap(decFinder);
    await tester.pump();
    expect(currentValue, 1);
    expect(find.widgetWithText(TextField, '1'), findsOneWidget);

    // Decrement at min (should not change)
    await tester.tap(decFinder);
    await tester.pump();
    expect(currentValue, 1);
  });

  testWidgets('QuantitySelector handles keyboard input', (WidgetTester tester) async {
    int currentValue = 1;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return QuantitySelector(
                value: currentValue,
                min: 1,
                onChanged: (val) {
                  setState(() {
                    currentValue = val;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    final inputFinder = find.byKey(const ValueKey('quantity_selector_input'));

    await tester.enterText(inputFinder, '25');
    await tester.pump();
    expect(currentValue, 25);
  });

  testWidgets('QuantitySelector validates on blur or submit when empty or below min', (WidgetTester tester) async {
    int currentValue = 10;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  QuantitySelector(
                    value: currentValue,
                    min: 1,
                    onChanged: (val) {
                      setState(() {
                        currentValue = val;
                      });
                    },
                  ),
                  const TextField(key: ValueKey('other_field')),
                ],
              );
            },
          ),
        ),
      ),
    );

    final inputFinder = find.byKey(const ValueKey('quantity_selector_input'));
    final otherField = find.byKey(const ValueKey('other_field'));

    // Clear text (empty) and move focus away
    await tester.enterText(inputFinder, '');
    await tester.pump();
    await tester.tap(otherField);
    await tester.pump();

    // Should reset to min (1)
    expect(currentValue, 1);
    expect(find.widgetWithText(TextField, '1'), findsOneWidget);

    // Submit with 0
    await tester.enterText(inputFinder, '0');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Should reset to min (1)
    expect(currentValue, 1);
    expect(find.widgetWithText(TextField, '1'), findsOneWidget);
  });

  testWidgets('QuantitySelector updates text when external value changes', (WidgetTester tester) async {
    int currentValue = 1;
    late StateSetter setParentState;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              setParentState = setState;
              return QuantitySelector(
                value: currentValue,
                min: 1,
                onChanged: (val) {
                  setState(() {
                    currentValue = val;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    expect(find.widgetWithText(TextField, '1'), findsOneWidget);

    setParentState(() {
      currentValue = 42;
    });
    await tester.pump();

    expect(find.widgetWithText(TextField, '42'), findsOneWidget);
  });
}
