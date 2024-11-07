import 'package:flowmotion/core/widget_keys.dart';
import 'package:flowmotion/widgets/congestionPointView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/common_finder.dart';
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

  Future<int> countSavedPlaces() async {
    final cards = find.byKeyPrefix(WidgetKeys.savedPlaceCardPrefix);
    return cards.evaluate().length;
  }

  Future<void> tapSavedPlace(int index) async {
    final card =
        await find.byKey(WidgetKeys.savedPlaceCard(index)).wait(tester);
    expect(card, findsOneWidget);
    await tester.tap(card);
    await tester.pumpAndSettle();
  }

  Future<void> verifyFullMap() async {
    await find.byKey(WidgetKeys.fullMapScreen).wait(tester);
  }

  Future<void> verifyFullMapMarkers() async {
    // Check the marker count on the map screen is at least 1
    expect(find.byIcon(Icons.circle),
        findsAtLeastNWidgets(1));
  }

  Future<void> verifyMarkerPopup() async {
    // Find the marker icon and tap it
    final markerIcon =
        find.byIcon(Icons.circle).first; // Assuming the marker is a circle icon
    await tester.tap(markerIcon);

    // Rebuild the widget after the state has changed
    await tester.pumpAndSettle();

    // Verify that the modal bottom sheet is displayed
    expect(find.text('Close'), findsOneWidget); // Check for the Close button

    // Check for the presence of the CongestionPointView
    expect(find.byType(CongestionPointView), findsOneWidget); // Check if CongestionPointView is instantiated

    // Close the modal by tapping the Close button
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle(); // Allow the modal to close

    // Verify that the modal is no longer displayed
    expect(find.text('Close'), findsNothing);  }
}
