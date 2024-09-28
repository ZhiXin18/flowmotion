import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flowmotion/main.dart' as app;
import '../test_auth_info.dart';
import 'robots/login_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late LoginRobot loginRobot;

  group('E2E - ', () {
    testWidgets('Login form validation - empty fields', (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);

      await tester.pumpAndSettle(const Duration(seconds: 4)); // Wait for splash screen
      loginRobot.verify(); // Verify it's at login screen

      await loginRobot.tapLoginButton();
      await loginRobot.verifyErrorMessage('Please enter your email.'); // Expect email error message first

      // Test 2: Password field empty, email filled
      await loginRobot.enterEmail(TestAuthInfo.unauthTestEmailEnv);
      await loginRobot.tapLoginButton();
      await loginRobot.verifyErrorMessage('Please enter your password.');

      // Clear input fields after closing the dialog
      await loginRobot.clearInputFields();

      // Test 3: Email field empty, password filled
      await loginRobot.enterPassword(TestAuthInfo.unauthTestPasswordEnv);
      await loginRobot.tapLoginButton();
      await loginRobot.verifyErrorMessage('Please enter your email.');

      // Clear input fields after closing the dialog
      await loginRobot.clearInputFields();
    });

    testWidgets("Unauthorized Login Flow", (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);

      await tester.pumpAndSettle(const Duration(seconds: 4)); //wait for splash screen
      loginRobot.verify(); //verify its at login screen
      await loginRobot.enterEmail(TestAuthInfo.unauthTestEmailEnv);
      await loginRobot.enterPassword(TestAuthInfo.unauthTestPasswordEnv);
      await loginRobot.tapLoginButton();
      await loginRobot.verifyErrorMessage('The supplied credentials are incorrect. Please try again.');
    });
  });
}