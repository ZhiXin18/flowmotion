import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flowmotion/main.dart' as app;
import 'package:flowmotion/globals.dart' as globals;

import '../test_auth_info.dart';
import 'robots/home_robot.dart';
import 'robots/login_robot.dart';

void main() {
  // Initialize integration testing
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Set testing environment and disable debug banner
  globals.testingActive = true;
  WidgetsApp.debugAllowBannerOverride = false;

  // Declare robots
  late LoginRobot loginRobot;
  late HomeRobot homeRobot;

  group('E2E Tests', () {
    testWidgets("Authorized Login To Map Flow", (WidgetTester tester) async {
      globals.testingActive = true; // Set testing flag before starting the app
      // Start the app
      await tester.pumpWidget(const app.MyApp());

      // Initialize robots with the tester
      loginRobot = LoginRobot(tester: tester);
      homeRobot = HomeRobot(tester: tester);

      await tester.pumpAndSettle(const Duration(seconds: 4));
      await loginRobot.verify();
      await loginRobot.enterEmail(TestAuthInfo.authTestEmailEnv);
      await loginRobot.enterPassword(TestAuthInfo.authTestPasswordEnv);
      await loginRobot.tapLoginButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await loginRobot.verifySuccess();

      // Navigate to the full map and verify
      await homeRobot.tapFullMapButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await homeRobot.verifyFullMap();
      await homeRobot.verifyFullMapMarkers();
      await homeRobot.verifyMarkerPopup();
    });
  });
}
