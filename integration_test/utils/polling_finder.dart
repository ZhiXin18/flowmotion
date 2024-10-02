//
// Flowmotion
// Integration Test
// Pooling Finder Extension
//

import 'package:flutter_test/flutter_test.dart';

/// Defines a extension to Finder that polls a for a nonempty result.
extension PollingFinder on Finder {
  /// Waits for the Finder to evaluate to an nonempty result.
  /// If no results match on evaluation, perform [tester]'s `.pumpAndSettle()` 
  /// and poll the Finder again after waiting for [interval].
  /// Throws `Exception` Upon reaching [timeout] without evaluating to a nonempty result.
  /// Returns the Finder to support chaining (eg. `find.byKey(...).wait(tester)`).
  Future<Finder> wait(
    WidgetTester tester, {
    Duration timeout = const Duration(seconds: 20),
    Duration interval = const Duration(milliseconds: 100),
  }) async {
    /// use the tester's clock
    final clock = tester.binding.clock;
    final deadline = clock.now().add(timeout);

    while (evaluate().isEmpty) {
      if (clock.now().isAfter(deadline)) {
        throw Exception('Timed out waiting for Finder: $this');
      }
      // pump animation frames to get result(s) to appear
      await tester.pumpAndSettle();
      await Future.delayed(interval);
    }

    return this;
  }
}
