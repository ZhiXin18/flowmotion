import 'package:flowmotion/core/widget_keys.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_test/flutter_test.dart';

class HomeRobot {
  final WidgetTester tester;

  HomeRobot({required this.tester});

  Future<void> tapFullMapButton() async {
    final goMapButton = find.byKey(WidgetKeys.goMapButton);
    expect(goMapButton, findsOneWidget);
    await tester.tap(goMapButton);
    await tester.pumpAndSettle();
  }

  void verifyFullMap() {
    final fullMapScreen = find.byKey(WidgetKeys.fullMapScreen);
  }
}