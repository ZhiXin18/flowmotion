//
// Flowmotion
// Integration Test
// Common Finders Extension
//

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Extends Common Finders with additional methods.
extension CommonFinderExtension on CommonFinders {
  /// Finder locating widgets assigned key starting with the given prefix.
  Finder byKeyPrefix(String prefix) {
    return find.byWidgetPredicate((widget) {
      final key = widget.key;
      return key is ValueKey<String> && key.value.startsWith(prefix);
    });
  }
}
