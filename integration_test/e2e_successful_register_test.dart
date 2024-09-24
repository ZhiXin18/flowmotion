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
    testWidgets("Authorized Login Flow", (tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);
      registerRobot = RegisterRobot(tester: tester);

      await tester.pumpAndSettle(const Duration(seconds: 4)); // Wait for splash screen
      loginRobot.verify(); // Verify its at login screen

      await loginRobot.tapRegisterAccButton();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      loginRobot.verifyStartRegister(); // Verify its at register screen

      await registerRobot.enterName("Johnny");
      await Future.delayed(const Duration(seconds: 2));
      await registerRobot.enterEmail(TestAuthInfo.registerTestEmailEnv);
      await Future.delayed(const Duration(seconds: 2));
      await registerRobot.enterPassword(TestAuthInfo.registerTestPasswordEnv);
      await Future.delayed(const Duration(seconds: 2));
      await registerRobot.tapRegisterButton();
      await Future.delayed(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      registerRobot.verifySuccess();
    });
  });
}