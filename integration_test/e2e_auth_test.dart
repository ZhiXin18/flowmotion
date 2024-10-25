import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flowmotion/main.dart' as app;
import 'package:patrol/patrol.dart';
import 'package:patrol_finders/patrol_finders.dart';

import '../test_auth_info.dart';
import 'robots/home_robot.dart';
import 'robots/login_robot.dart';

Future<void> allowNativePermissionIfDisplayed(PatrolIntegrationTester $) async {
  print('Wait for permissions dialog and grant permissions');

  if (await $.native.isPermissionDialogVisible()) {
    print('Found permissions dialog');

    // Use a Selector instead of a Finder
    //await $.native.tap(Selector(text: 'While using the app'));

    await $.native.tap(Selector(text: "Don't allow"));
    //await $.native.grantPermissionWhenInUse();
  }

  await $.pumpAndSettle();
}

void main() {
  //IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late LoginRobot loginRobot;
  late HomeRobot homeRobot;

  //group('E2E - ', () {
  patrolTest("Authorized Login Flow", (PatrolIntegrationTester $) async {
    final WidgetTester tester = $.tester;
    await tester.pumpWidget(const app.MyApp());
    loginRobot = LoginRobot(tester: tester);

    await tester.pumpAndSettle(const Duration(seconds: 4));
    await loginRobot.verify();
    await loginRobot.enterEmail(TestAuthInfo.authTestEmailEnv);
    await loginRobot.enterPassword(TestAuthInfo.authTestPasswordEnv);
    await loginRobot.tapLoginButton();
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await loginRobot.verifySuccess();
    // handle native location permission request dialog
    await $.native.selectFineLocation();
    //await $.native.grantPermissionWhenInUse();
    //await $.native2.denyPermission();
    await allowNativePermissionIfDisplayed($);
  });

  patrolTest("Authorized Login To Map Flow", (PatrolIntegrationTester $) async {
    final WidgetTester tester = $.tester;
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
    // handle native location permission request dialog
    await $.native.selectFineLocation();
    //await $.native.grantPermissionWhenInUse();
    //await $.native2.denyPermission();
    //await allowNativePermissionIfDisplayed($);

    //click view full map
    await homeRobot.tapFullMapButton();
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await homeRobot.verifyFullMap();
    // handle native location permission request dialog
    await $.native.selectFineLocation();
    //await $.native.grantPermissionWhenInUse();
    //await $.native2.denyPermission();
    //await allowNativePermissionIfDisplayed($);

    await tester.pumpAndSettle(const Duration(seconds: 10));
  });
  //});
}