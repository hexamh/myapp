import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/screens/apps_screen.dart';

void main() {
  testWidgets('AppsScreen benchmark', (WidgetTester tester) async {
    final stopwatch = Stopwatch()..start();
    for (int i = 0; i < 1000; i++) {
      await tester.pumpWidget(
        MaterialApp(
          home: AppsScreen(),
        ),
      );
    }
    stopwatch.stop();
    print('Time elapsed: ${stopwatch.elapsedMilliseconds}ms');
  });
}
