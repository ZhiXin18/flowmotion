import 'package:flowmotion/core/widget_keys.dart';
import 'package:flutter/material.dart';
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
        findsAtLeastNWidgets(1)); // Check for the two circle icons
  }

  Future<void> verifyMarkerPopup() async {
    // Find the marker icon and tap it
    final markerIcon =
        find.byIcon(Icons.circle).first; // Assuming the marker is a circle icon
    await tester.tap(markerIcon);

    // Rebuild the widget after the state has changed
    await tester.pumpAndSettle();

    // Verify if the AlertDialog shows up
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.pumpAndSettle(const Duration(seconds: 6));
    expect(find.byType(Image),
        findsOneWidget); // Check for the presence of an Image widget

    // Check if the Image widget is a NetworkImage
    final imageWidget = tester.widget<Image>(find.byType(Image).first);
    expect(imageWidget.image,
        isInstanceOf<NetworkImage>()); // Check if it's a NetworkImage
  }
}
