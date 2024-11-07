import 'package:flowmotion/core/widget_keys.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_test/flutter_test.dart';
import '../utils/polling_finder.dart';

class LoginRobot {
  final WidgetTester tester;

  LoginRobot({required this.tester});

  Future<void> verifyBootup() async {
    await find.byKey(WidgetKeys.splashScreen).wait(tester);
  }

  Future<void> verify() async {
    await find.byKey(WidgetKeys.loginScreen).wait(tester);
  }

  Future<void> enterEmail(String email) async {
    final emailField =
        await find.byKey(WidgetKeys.loginEmailController).wait(tester);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
    await tester.pump();
  }

  Future<void> enterPassword(String password) async {
    final passwordField =
        await find.byKey(WidgetKeys.loginPasswordController).wait(tester);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
    await tester.pump();
  }

  Future<void> tapLoginButton() async {
    final loginButton = await find.byKey(WidgetKeys.loginButton).wait(tester);
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  }

  Future<void> tapOKButton() async {
    final okButton = await find.byKey(WidgetKeys.loginErrorOK).wait(tester);
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapRegisterAccButton() async {
    final goRegisterButton =
        await find.byKey(WidgetKeys.goRegisterButton).wait(tester);
    expect(goRegisterButton, findsOneWidget);
    await tester.tap(goRegisterButton);
    await tester.pumpAndSettle();
  }

  Future<void> verifyLoginError() async {
    final loginErrorDialog =
        await find.byKey(WidgetKeys.loginErrorDialog).wait(tester);
    expect(loginErrorDialog, findsOneWidget);
  }

  // Helper function to verify error messages
  Future<void> verifyErrorMessage(String expectedMessage) async {
    await verifyLoginError();
    expect(find.text(expectedMessage), findsOneWidget);
    // Tap the OK button to dismiss the dialog
    await tapOKButton();
  }

  // Clear input fields function
  Future<void> clearInputFields() async {
    await enterEmail('');
    await enterPassword('');
  }

  Future<void> verifySuccess() async {
    await find.byKey(WidgetKeys.homeScreen).wait(tester);
  }

  Future<void> verifyStartRegister() async {
    await find.byKey(WidgetKeys.registerScreen).wait(tester);
  }
}
