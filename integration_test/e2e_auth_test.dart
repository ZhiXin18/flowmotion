import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flowmotion/main.dart' as app;

import '../test_auth_info.dart';
import 'robots/login_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late LoginRobot loginRobot;

  group('E2E - ', () {
    testWidgets("Authorized Login Flow", (tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);

      await tester.pumpAndSettle(const Duration(seconds: 4));
      loginRobot.verify();
      await loginRobot.enterEmail(TestAuthInfo.authTestEmailEnv);
      await Future.delayed(const Duration(seconds: 2));
      await loginRobot.enterPassword(TestAuthInfo.authTestPasswordEnv);
      await Future.delayed(const Duration(seconds: 2));
      await loginRobot.tapLoginButton();
      await Future.delayed(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      loginRobot.verifySuccess();
    });
  });
}