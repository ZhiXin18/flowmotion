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

  group('E2E - Registrations', () {
    testWidgets("Start Register Flow", (tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);

      await tester.pumpAndSettle(const Duration(seconds: 4)); //wait for splash screen
      loginRobot.verify(); //verify its at login screen

      await loginRobot.tapRegisterAccButton();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      loginRobot.verifyStartRegister();
    });

    testWidgets('Register form validation - empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);
      registerRobot = RegisterRobot(tester: tester);

      await tester.pumpAndSettle(const Duration(seconds: 4)); // Wait for splash screen
      loginRobot.verify(); // Verify its at login screen

      await loginRobot.tapRegisterAccButton();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      loginRobot.verifyStartRegister(); // Verify its at register screen

      // Test 1: All fields empty
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage('Please enter your name.'); // Expect name error message first

      // Test 2: Name field empty
      await registerRobot.enterEmail(TestAuthInfo.unauthTestEmailEnv);
      await registerRobot.enterPassword(TestAuthInfo.unauthTestPasswordEnv);
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage('Please enter your name.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();

      // Test 3: Email field empty
      await registerRobot.enterName("Johnny");
      await registerRobot.enterPassword(TestAuthInfo.unauthTestPasswordEnv);
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage('Please enter your email.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();

      // Test 4: Password field empty
      await registerRobot.enterName("Johnny");
      await registerRobot.enterEmail(TestAuthInfo.unauthTestEmailEnv);
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage('Please enter your password.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();
    });

    testWidgets("Unsuccessful Register Flow", (tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);
      registerRobot = RegisterRobot(tester: tester);

      await tester.pumpAndSettle(const Duration(seconds: 4)); // Wait for splash screen
      loginRobot.verify(); // Verify its at login screen

      await loginRobot.tapRegisterAccButton();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      loginRobot.verifyStartRegister(); // Verify its at register screen

      // Test 1: Invalid email
      await registerRobot.enterName("Johnny");
      await registerRobot.enterEmail(TestAuthInfo.testInvalidEmailEnv);
      await registerRobot.enterPassword(TestAuthInfo.unauthTestPasswordEnv);
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage('Please enter a valid email address.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();

      // Test 2: Short Password
      await registerRobot.enterName("Johnny");
      await registerRobot.enterEmail(TestAuthInfo.unauthTestEmailEnv);
      await registerRobot.enterPassword(TestAuthInfo.shortPassword);
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage('Password must be 5-12 characters and include at least one special character.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();

      // Test 3: Password no special character
      await registerRobot.enterName("Johnny");
      await registerRobot.enterEmail(TestAuthInfo.unauthTestEmailEnv);
      await registerRobot.enterPassword(TestAuthInfo.passwordWithoutSpecialChar);
      await registerRobot.tapRegisterButton();
      await registerRobot.verifyErrorMessage('Password must be 5-12 characters and include at least one special character.');

      // Clear input fields after closing the dialog
      await registerRobot.clearInputFields();
    });
  });
}