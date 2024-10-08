import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flowmotion/main.dart' as app;

import '../test_auth_info.dart';
import 'robots/home_robot.dart';
import 'robots/login_robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late LoginRobot loginRobot;
  late HomeRobot homeRobot;

  group('E2E - ', () {
    testWidgets("Authorized Login Flow", (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);

      await tester.pumpAndSettle(const Duration(seconds: 4));
      await loginRobot.verify();
      await loginRobot.enterEmail(TestAuthInfo.authTestEmailEnv);
      await loginRobot.enterPassword(TestAuthInfo.authTestPasswordEnv);
      await loginRobot.tapLoginButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await loginRobot.verifySuccess();
    });

    testWidgets("Authorized Login To Map Flow", (WidgetTester tester) async {
      await tester.pumpWidget(const app.MyApp());
      loginRobot = LoginRobot(tester: tester);
      homeRobot = HomeRobot(tester: tester);

      await tester.pumpAndSettle(const Duration(seconds: 4));
      await loginRobot.verify();
      await loginRobot.enterEmail(TestAuthInfo.authTestEmailEnv);
      await loginRobot.enterPassword(TestAuthInfo.authTestPasswordEnv);
      await loginRobot.tapLoginButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await loginRobot.verifySuccess();

      //click view full map
      await homeRobot.tapFullMapButton();
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await homeRobot.verifyFullMap();
    });
  });
}
