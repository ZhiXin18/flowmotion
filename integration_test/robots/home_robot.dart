import 'package:flowmotion/core/widget_keys.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_test/flutter_test.dart';
import '../utils/polling_finder.dart';

class HomeRobot {
  final WidgetTester tester;

  HomeRobot({required this.tester});

  Future<void> tapFullMapButton() async {
    final goMapButton = await find.byKey(WidgetKeys.goMapButton).wait(tester);
    expect(goMapButton, findsOneWidget);
    await tester.tap(goMapButton);
    await tester.pumpAndSettle();
  }

  Future<void> verifyFullMap() async {
    await find.byKey(WidgetKeys.fullMapScreen).wait(tester);
  }
}
