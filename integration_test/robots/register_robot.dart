import 'package:flowmotion/core/widget_keys.dart';
import 'package:flutter_test/flutter_test.dart';

class RegisterRobot {
  final WidgetTester tester;

  RegisterRobot({required this.tester});

  void verifyBootup() {
    final splashScreen = find.byKey(WidgetKeys.splashScreen);
  }

  void verify() {
    final loginScreen = find.byKey(WidgetKeys.loginScreen);
  }

  Future<void> enterName(String name) async {
    final nameField = find.byKey(WidgetKeys.registerNameController);
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, name);
    await tester.pump();
  }

  Future<void> enterEmail(String email) async {
    final emailField = find.byKey(WidgetKeys.registerEmailController);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
    await tester.pump();
  }

  Future<void> enterPassword(String password) async {
    final passwordField = find.byKey(WidgetKeys.registerPasswordController);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
    await tester.pump();
  }

  Future<void> tapRegisterButton() async {
    final registerButton = find.byKey(WidgetKeys.registerButton);
    expect(registerButton, findsOneWidget);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapOKButton() async {
    final okButton = find.byKey(WidgetKeys.registerErrorOK);
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();
  }

  void verifyError() {
    final errorDialog = find.byKey(WidgetKeys.registerErrorDialog);
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
    await enterName('');
    await enterEmail('');
    await enterPassword('');
  }

  void verifySuccess() {
    final homeScreen = find.byKey(WidgetKeys.homeScreen);
  }
}