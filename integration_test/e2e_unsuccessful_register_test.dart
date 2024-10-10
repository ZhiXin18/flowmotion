import 'dart:math';

import 'package:flowmotion/models/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flowmotion/main.dart' as app;
import '../test_auth_info.dart';
import 'robots/login_robot.dart';
import 'robots/register_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
    testWidgets("Start Register Flow", (tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);

      await tester
          .pumpAndSettle(const Duration(seconds: 4)); //wait for splash screen
      await loginRobot.verify(); //verify its at login screen

      await loginRobot.tapRegisterAccButton();
      await tester.pumpAndSettle();
      await loginRobot.verifyStartRegister();
    });

    testWidgets('Register form validation - empty fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);
      registerRobot = RegisterRobot(tester: tester);

      await tester
          .pumpAndSettle(const Duration(seconds: 4)); // Wait for splash screen
      await loginRobot.verify(); // Verify its at login screen

      await loginRobot.tapRegisterAccButton();
      await tester.pumpAndSettle();
      await loginRobot.verifyStartRegister(); // Verify its at register screen

      // Test 1: All fields empty
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage(
          'Please enter your name.'); // Expect name error message first

      // Test 2: Name field empty
      await registerRobot.enterEmail(TestAuthInfo.unauthTestEmailEnv);
      await registerRobot.enterPassword(TestAuthInfo.unauthTestPasswordEnv);
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      final scrollableFinder = find.byType(SingleChildScrollView);
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage('Please enter your name.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();

      // Test 3: Email field empty
      await registerRobot.enterName("Johnny");
      await registerRobot.enterPassword(TestAuthInfo.unauthTestPasswordEnv);
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage('Please enter your email.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();

      // Test 4: Password field empty
      await registerRobot.enterName("Johnny");
      await registerRobot.enterEmail(TestAuthInfo.unauthTestEmailEnv);
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage('Please enter your password.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();
    });

    testWidgets("Unsuccessful Register Flow", (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);
      registerRobot = RegisterRobot(tester: tester);

      await tester
          .pumpAndSettle(const Duration(seconds: 4)); // Wait for splash screen
      await loginRobot.verify(); // Verify its at login screen

      await loginRobot.tapRegisterAccButton();
      await tester.pumpAndSettle();
      await loginRobot.verifyStartRegister(); // Verify its at register screen

      // Test 1: Invalid email
      await registerRobot.enterName("Johnny");
      await registerRobot.enterEmail(TestAuthInfo.testInvalidEmailEnv);
      await registerRobot.enterPassword(TestAuthInfo.unauthTestPasswordEnv);
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      final scrollableFinder = find.byType(SingleChildScrollView);
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapRegisterButton();
      await registerRobot
          .verifyErrorMessage('Please enter a valid email address.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();

      // Test 2: Short Password
      await registerRobot.enterName("Johnny");
      await registerRobot.enterEmail(TestAuthInfo.unauthTestEmailEnv);
      await registerRobot.enterPassword(TestAuthInfo.shortPassword);
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage(
          'Password must be 5-12 characters and include at least one special character.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();

      // Test 3: Password no special character
      await registerRobot.enterName("Johnny");
      await registerRobot.enterEmail(TestAuthInfo.unauthTestEmailEnv);
      await registerRobot
          .enterPassword(TestAuthInfo.passwordWithoutSpecialChar);
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage(
          'Password must be 5-12 characters and include at least one special character.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();

      await registerRobot.enterName("Johnny");
      await registerRobot.enterEmail(TestAuthInfo.authTestEmailEnv);
      await registerRobot
          .enterPassword(TestAuthInfo.unauthTestPasswordEnv);
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage(
          'Failed to register. Please try again.');

    });

    testWidgets("Unsuccessful Address Register Flow",
        (WidgetTester tester) async {
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
      await tester.pumpAndSettle(const Duration(seconds: 4));
      final scrollableFinder = find.byType(SingleChildScrollView);
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapRegisterButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await registerRobot
          .verifyPartSuccess(); // Verify its at saved place screen

      // Test 1: All fields empty
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapGetStartedButton();
      await registerRobot
          .verifyErrorMessage('Please fill in the Home address.');

      // Define your addresses
      List<Address> addresses = [
        Address(postalCode: '068805', address: '3 Shenton Way'),
        Address(postalCode: '048424', address: '8 Cross Street'),
      ];

      // Test 2: Work Address field empty
      await registerRobot.enterSpecifiedAddress(addresses, 0);
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await registerRobot.tapGetStartedButton();
      await registerRobot
          .verifyErrorMessage('Please fill in the Work address.');

      // Clear input fields after closing the dialog
      await registerRobot.clearAddressInputFields(0);

      // Test 3: Home Address field empty
      await registerRobot.enterSpecifiedAddress(addresses, 1);
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await registerRobot.tapGetStartedButton();
      await registerRobot
          .verifyErrorMessage('Please fill in the Home address.');

      // Clear input fields after closing the dialog
      await registerRobot.clearAddressInputFields(1);

      // Test 4: Checkboxes not checked
      await registerRobot.enterAddress(addresses);
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await registerRobot.tapGetStartedButton();
      await registerRobot.verifyErrorMessage(
          'Please accept the terms and conditions and allow notifications.');

      // Test 5: Only one checkbox is checked
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await registerRobot.tapTermsCheckbox();
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapGetStartedButton();
      await registerRobot.verifyErrorMessage(
          'Please accept the terms and conditions and allow notifications.');

      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapTermsCheckbox();
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapNotificationCheckbox();
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.dismissKeyboard();
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await registerRobot.tapGetStartedButton();
      await registerRobot.verifyErrorMessage(
          'Please accept the terms and conditions and allow notifications.');
    });

    testWidgets("Click back before saving address",
        (WidgetTester tester) async {
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
      await tester.pumpAndSettle(const Duration(seconds: 4));
      final scrollableFinder = find.byType(SingleChildScrollView);
      await tester.fling(
          scrollableFinder, Offset(0, -300), 1500); // Fling upwards
      await tester.pumpAndSettle(); // Allow time for scrolling to finish
      await registerRobot.tapRegisterButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await registerRobot
          .verifyPartSuccess(); // Verify its at saved place screen

      await registerRobot.tapBackButton();
      await loginRobot.verifyStartRegister();
    });
  });
}
