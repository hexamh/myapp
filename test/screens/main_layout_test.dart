import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/screens/main_layout.dart';

void main() {
  Widget createTestWidget() {
    return MaterialApp(
      home: MainLayout(
        screens: [
          Container(key: const Key('screen_0'), color: Colors.red),
          Container(key: const Key('screen_1'), color: Colors.green),
          Container(key: const Key('screen_2'), color: Colors.blue),
          Container(key: const Key('screen_3'), color: Colors.yellow),
          Container(key: const Key('screen_4'), color: Colors.purple),
        ],
      ),
    );
  }

  testWidgets('MainLayout initializes properly and renders bottom navigation', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Initial load, IndexedStack index should be 0
    final indexedStack = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(indexedStack.index, 0);

    // Verify nav items exist
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Device'), findsOneWidget);
    expect(find.text('System'), findsOneWidget);
    expect(find.text('Battery'), findsOneWidget);
    expect(find.text('Network'), findsOneWidget);
  });

  testWidgets('MainLayout changes screens when bottom navigation items are tapped', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Tap on Device (index 1)
    await tester.tap(find.text('Device'));
    await tester.pumpAndSettle();

    var indexedStack = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(indexedStack.index, 1);

    // Tap on System (index 2)
    await tester.tap(find.text('System'));
    await tester.pumpAndSettle();

    indexedStack = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(indexedStack.index, 2);

    // Tap on Battery (index 3)
    await tester.tap(find.text('Battery'));
    await tester.pumpAndSettle();

    indexedStack = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(indexedStack.index, 3);

    // Tap on Network (index 4)
    await tester.tap(find.text('Network'));
    await tester.pumpAndSettle();

    indexedStack = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(indexedStack.index, 4);

    // Tap on Dashboard (index 0)
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    indexedStack = tester.widget<IndexedStack>(find.byType(IndexedStack));
    expect(indexedStack.index, 0);
  });
}
