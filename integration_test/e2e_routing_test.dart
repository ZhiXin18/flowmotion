//
// Flowmotion
// Integration Test
// Routing E2e Test
//

import 'package:flowmotion/core/widget_keys.dart';
import 'package:flowmotion/globals.dart' as globals;
import 'package:flowmotion/main.dart' as app;
import 'package:flowmotion/utilities/firebase_calls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test_auth_info.dart';
import 'robots/congestion_rating_robot.dart';
import 'robots/home_robot.dart';
import 'robots/login_robot.dart';

void main() {
  // Initialize integration testing
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Set testing environment and disable debug banner
  globals.testingActive = true;
  WidgetsApp.debugAllowBannerOverride = false;

  group('E2E Routing Tests', () {
    testWidgets("Routing Save Route Flow", (WidgetTester tester) async {
      globals.testingActive = true; // Set testing flag before starting the app
      // Start the app
      await tester.pumpWidget(const app.MyApp());

      // login with test account
      final LoginRobot loginRobot = LoginRobot(tester: tester);
      await loginRobot.verify();
      await loginRobot.enterEmail(TestAuthInfo.authTestEmailEnv);
      await loginRobot.enterPassword(TestAuthInfo.authTestPasswordEnv);

      await loginRobot.tapLoginButton();
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      await loginRobot.verifySuccess();

      // obtain logged in user data
      final firebase = FirebaseCalls();
      final user = await firebase.getUserData();

      // transition: login screen -> home screen
      final HomeRobot homeRobot = HomeRobot(tester: tester);
      // check save place cards have been drawn for each address
      final nSavedCards = await homeRobot.countSavedPlaces();
      expect(nSavedCards, equals(user?["addresses"].length));
      // tap first saved place card
      await homeRobot.tapSavedPlace(0);
    });
  });
}
