import 'dart:math';

import 'package:flowmotion/models/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flowmotion/main.dart' as app;
import 'package:flowmotion/globals.dart' as globals;

import '../test_auth_info.dart';
import 'robots/login_robot.dart';
import 'robots/register_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  globals.testingActive = true; // Set testing flag before starting the app


  late LoginRobot loginRobot;
  late RegisterRobot registerRobot;

  // Function to generate both a username and email using the same base
  Map<String, String> generateUsernameAndEmail() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    String base = 'user$timestamp${random.nextInt(1000)}'; // Generate base
    String email = '$base@example.com'; // Generate email
    return {'username': base, 'email': email}; // Return both as a Map
  }

  group('E2E - Registrations', () {
    testWidgets("Successful Register Flow(2 addresses)",
        (WidgetTester tester) async {
      globals.testingActive = true; // Set testing flag before starting the app
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);
      registerRobot = RegisterRobot(tester: tester);

      await tester
          .pumpAndSettle(const Duration(seconds: 4)); // Wait for splash screen
      await loginRobot.verify(); // Verify its at login screen

      await loginRobot.tapRegisterAccButton();
      await tester.pumpAndSettle();
      await loginRobot.verifyStartRegister(); // Verify its at register screen

      // Generate both username and email
      var userDetails = generateUsernameAndEmail();
      String username = userDetails['username']!; // Extract username
      String randomEmail = userDetails['email']!; // Extract email

      await registerRobot.enterName(username); // Enter the generated username
      await registerRobot.enterEmail(randomEmail); // Enter the generated email
      await registerRobot.enterPassword(TestAuthInfo.registerTestPasswordEnv);
      await registerRobot.dismissKeyboard();
      await registerRobot.tapRegisterButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await registerRobot
          .verifyPartSuccess(); // Verify its at saved place screen
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Define your addresses
      List<Address> addresses = [
        Address(postalCode: '554369', address: '23A Serangoon North Ave 5'),
        Address(postalCode: '819642', address: 'Changi Airport Terminal 1, Airport Boulevard'),
      ];

      // Call enterAddress to fill in the addresses
      await registerRobot.enterAddress(addresses);
      await registerRobot.dismissKeyboard();
      final scrollableFinder = find.byType(SingleChildScrollView);
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapTermsCheckbox();
      await registerRobot.tapNotificationCheckbox();
      await registerRobot.tapGetStartedButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await registerRobot.verifyRegisterSuccess();
    });

    testWidgets("Successful Register Flow(3 addresses)",
        (WidgetTester tester) async {
      globals.testingActive = true; // Set testing flag before starting the app
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);
      registerRobot = RegisterRobot(tester: tester);

      await tester
          .pumpAndSettle(const Duration(seconds: 4)); // Wait for splash screen
      await loginRobot.verify(); // Verify its at login screen

      await loginRobot.tapRegisterAccButton();
      await tester.pumpAndSettle();
      await loginRobot.verifyStartRegister(); // Verify its at register screen

      // Generate both username and email
      var userDetails = generateUsernameAndEmail();
      String username = userDetails['username']!; // Extract username
      String randomEmail = userDetails['email']!; // Extract email

      await registerRobot.enterName(username); // Enter the generated username
      await registerRobot.enterEmail(randomEmail); // Enter the generated email
      await registerRobot.enterPassword(TestAuthInfo.registerTestPasswordEnv);
      await registerRobot.dismissKeyboard();
      final scrollableFinder = find.byType(SingleChildScrollView);
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapRegisterButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await registerRobot
          .verifyPartSuccess(); // Verify its at saved place screen
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Define your addresses
      List<Address> addresses = [
        Address(postalCode: '554369', address: '23A Serangoon North Ave 5'),
        Address(postalCode: '819642', address: 'Changi Airport Terminal 1, Airport Boulevard'),
        Address(postalCode: '758966', address: '22 Jln Tampang'),
      ];

      // Call enterAddress to fill in the addresses
      await registerRobot.enterAddress(addresses);
      await registerRobot.dismissKeyboard();
      await registerRobot.tapAddMoreButton();
      await registerRobot.verifyAddMore();
      await registerRobot.enterAdditionalAddress(addresses);
      await registerRobot.dismissKeyboard();
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapTermsCheckbox();
      await registerRobot.tapNotificationCheckbox();
      await registerRobot.tapGetStartedButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await registerRobot.verifyRegisterSuccess();
    });
  });
}
