import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/theme/app_theme.dart';

void main() {
  testWidgets('Benchmark theme creation', (WidgetTester tester) async {
    // Warmup
    var theme1 = AppTheme.darkTheme;
    var theme2 = AppTheme.lightTheme;
    // Use the variables to avoid warnings
    expect(theme1.brightness, isNotNull);
    expect(theme2.brightness, isNotNull);

    final sw1 = Stopwatch()..start();
    for (int i = 0; i < 1000; i++) {
      var t = AppTheme.darkTheme;
      expect(t.brightness, isNotNull);
    }
    sw1.stop();
    debugPrint('Baseline darkTheme (1000 iterations): ${sw1.elapsedMicroseconds} us');

    final sw2 = Stopwatch()..start();
    for (int i = 0; i < 1000; i++) {
      var t = AppTheme.lightTheme;
      expect(t.brightness, isNotNull);
    }
    sw2.stop();
    debugPrint('Baseline lightTheme (1000 iterations): ${sw2.elapsedMicroseconds} us');
  });
}

// Simple debugPrint mock to avoid analyzer warnings about print
void debugPrint(String message) {
  // do nothing or print
}
