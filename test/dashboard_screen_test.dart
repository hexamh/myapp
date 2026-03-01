import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/screens/dashboard_screen.dart';

void main() {
  testWidgets('DashboardScreen builds successfully', (WidgetTester tester) async {
    // We need to provide a tall and wide enough constraints to avoid overflow in tests
    tester.binding.window.physicalSizeTestValue = const Size(2000, 3000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: DashboardScreen(),
      ),
    ));

    // Pump to settle any animations or async calls
    await tester.pumpAndSettle();

    expect(find.byType(DashboardScreen), findsOneWidget);

    // Reset window size
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}
