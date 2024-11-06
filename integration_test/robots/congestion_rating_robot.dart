import 'package:flowmotion/core/widget_keys.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/common_finder.dart';
import '../utils/polling_finder.dart';

class CongestionRatingRobot {
  final WidgetTester tester;

  CongestionRatingRobot({required this.tester});

  Future<void> verifyMap() async {
    // check map view
    final map = await find.byKey(WidgetKeys.congestionMapScreen).wait(tester);
    expect(map, findsOneWidget);
    // check src & destination markers
    final markers = await find.byKey(WidgetKeys.congestionMapMarkers).wait(tester);
    expect(markers, findsOneWidget);
    // check route polyline
    final route = await find.byKey(WidgetKeys.congestionMapRoute).wait(tester);
    expect(route, findsOneWidget);
  }
  
  Future<int> countPrefixed(String prefix) async {
    final cards = find.byKeyPrefix(prefix);
    return cards.evaluate().length;
  }
}
