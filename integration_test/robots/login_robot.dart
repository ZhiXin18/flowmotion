import 'package:flowmotion/core/widget_keys.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_test/flutter_test.dart';

class LoginRobot {
  final WidgetTester tester;

  LoginRobot({required this.tester});

  void verifyBootup() {
    final splashScreen = find.byKey(WidgetKeys.splashScreen);
  }

  void verify() {
    final loginScreen = find.byKey(WidgetKeys.loginScreen);
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(WidgetKeys.loginEmailController);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
    await tester.pump();
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(WidgetKeys.loginPasswordController);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
    await tester.pump();
  }

  Future<void> tapLoginButton() async {
    final loginButton = find.byKey(WidgetKeys.loginButton);
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapOKButton() async {
    final okButton = find.byKey(WidgetKeys.loginErrorOK);
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();
  }

  void verifyError() {
    final errorDialog = find.byKey(WidgetKeys.loginErrorDialog);
    expect(errorDialog, findsOneWidget);
  }

  // Helper function to verify error messages
  Future<void> verifyErrorMessage(String expectedMessage) async {
    verifyError();
    expect(find.text(expectedMessage), findsOneWidget);
    await Future.delayed(const Duration(seconds: 2));
    // Tap the OK button to dismiss the dialog
    await tapOKButton();
  }

  // Clear input fields function
  Future<void> clearInputFields() async {
    await enterEmail('');
    await enterPassword('');
  }

  void verifySuccess() {
    final homeScreen = find.byKey(WidgetKeys.homeScreen);
  }
}