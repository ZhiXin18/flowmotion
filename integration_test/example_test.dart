/*import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'counter state is the same after going to Home and switching apps',
    nativeAutomatorConfig: NativeAutomatorConfig(
      packageName: 'com.example.flowmotion',
      bundleId: 'com.example.flowmotion',
    ),
        ($) async {
      // Replace later with your app's main widget
      await $.pumpWidgetAndSettle(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('app')),
            backgroundColor: Colors.blue,
          ),
        ),
      );

      expect($('app'), findsOneWidget);
      if (!Platform.isMacOS) {
        await $.native.pressHome();
      }
    },
  );
}*/

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'counter state is the same after going to home and switching apps',
        ($) async {
      // Replace with your app's main widget
      await $.pumpWidgetAndSettle(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Counter App')),
            body: Center(child: Text('0', style: TextStyle(fontSize: 24))),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
        ),
      );

      // Verify initial counter value is 0
      expect(find.text('0'), findsOneWidget);

      // Simulate pressing the button to increment counter
      await $.tap(find.byType(FloatingActionButton));
      await $.pumpAndSettle();

      // Verify the counter is now 1
      expect(find.text('1'), findsOneWidget);

      // Switch to home screen and back to app
      await $.native.pressHome();
      await $.native.openApp();

      // Verify the counter value is still 1 after app switch
      expect(find.text('1'), findsOneWidget);
    },
  );
}
