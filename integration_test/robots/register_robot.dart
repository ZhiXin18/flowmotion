import 'package:flowmotion/core/widget_keys.dart';
import 'package:flowmotion/models/address.dart';
import 'package:flutter/cupertino.dart';
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
    await Future.delayed(const Duration(seconds: 2));
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

  // Clear input address fields function
  Future<void> clearAddressInputFields(int indexToClear) async {
      final postalCodeField = find.byKey(WidgetKeys.addressPostalCodeField(indexToClear));
      final addressField = find.byKey(WidgetKeys.addressField(indexToClear));

      expect(postalCodeField, findsOneWidget);
      await tester.enterText(postalCodeField, "");
      await tester.pump();

      expect(addressField, findsOneWidget);
      await tester.enterText(addressField, "");
      await tester.pump();
  }


  void verifyPartSuccess() {
    final savedPlaceScreen = find.byKey(WidgetKeys.savedPlaceScreen);
  }

  Future<void> enterAddress(List<Address> addresses) async {
    for (int i = 0; i < 2; i++) {
      final postalCodeField = find.byKey(WidgetKeys.addressPostalCodeField(i));
      final addressField = find.byKey(WidgetKeys.addressField(i));

      // Verify postal code field
      expect(postalCodeField, findsOneWidget);
      await tester.enterText(postalCodeField, addresses[i].postalCode);
      await tester.pump();

      // Verify address field
      expect(addressField, findsOneWidget);
      await tester.enterText(addressField, addresses[i].address);
      await tester.pump();
    }
  }

  Future<void> enterAdditionalAddress(List<Address> addresses) async {
    for (int i = 2; i < addresses.length; i++) {
      final postalCodeField = find.byKey(WidgetKeys.addressPostalCodeField(i));
      final addressField = find.byKey(WidgetKeys.addressField(i));

      // Verify postal code field
      expect(postalCodeField, findsOneWidget);
      await tester.enterText(postalCodeField, addresses[i].postalCode);
      await tester.pump();

      // Verify address field
      expect(addressField, findsOneWidget);
      await tester.enterText(addressField, addresses[i].address);
      await tester.pump();
    }
  }

  Future<void> enterSpecifiedAddress(List<Address> addresses, int index) async {
    final postalCodeField = find.byKey(WidgetKeys.addressPostalCodeField(index));
    final specifiedAddressField = find.byKey(WidgetKeys.addressField(index));

    // Verify postal code field
    expect(postalCodeField, findsOneWidget);
    await tester.enterText(postalCodeField, addresses[index].postalCode);
    await tester.pump();

    // Verify address field
    expect(specifiedAddressField, findsOneWidget);
    await tester.enterText(specifiedAddressField, addresses[index].address);
    await tester.pump();
  }

  // Method to dismiss the keyboard
  Future<void> dismissKeyboard() async {
    // Tap in the center of the screen or another area not covered by inputs
    await tester.tap(find.byKey(WidgetKeys.dismissKeyboard)); // Change this to an appropriate widget if needed
    await tester.pumpAndSettle(const Duration(seconds: 5)); // Wait for the UI to settle
  }

  Future<void> tapAddMoreButton() async {
    await tester.tap(find.byKey(WidgetKeys.addMoreButton));
    await tester.pumpAndSettle(); // Wait for the UI to settle
  }

  Future<void> verifyAddMore() async {
    final addMoreDialog = find.byKey(WidgetKeys.addMoreDialog);
    expect(addMoreDialog, findsOneWidget); // Verify that dialog shows to add address
    final newAddressName = find.byKey(WidgetKeys.addressNameTextField);
    expect(newAddressName, findsOneWidget);
    await tester.enterText(newAddressName, "School"); // Enter new address name
    await tester.pump();
    await tapAddButton();
  }

  Future<void> tapCancelButton() async {
    await tester.tap(find.byKey(WidgetKeys.addMoreCancelButton));
    await tester.pumpAndSettle(); // Wait for the UI to settle
  }

  Future<void> tapAddButton() async {
    await tester.tap(find.byKey(WidgetKeys.addButton));
    await tester.pumpAndSettle(); // Wait for the UI to settle
  }

  Future<void> tapTermsCheckbox() async {
    final termsCheckbox = find.byKey(WidgetKeys.termsCheckbox);
    expect(termsCheckbox, findsOneWidget);
    await tester.tap(termsCheckbox);
    await tester.pumpAndSettle();
  }

  Future<void> tapNotificationCheckbox() async {
    final notificationsCheckbox = find.byKey(WidgetKeys.notificationsCheckbox);
    expect(notificationsCheckbox, findsOneWidget);
    await tester.tap(notificationsCheckbox);
    await tester.pumpAndSettle();
  }

  Future<void> tapGetStartedButton() async {
    final getStartedButton = find.byKey(WidgetKeys.getStartedButton);
    expect(getStartedButton, findsOneWidget);
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();
  }

  void verifyRegisterSuccess() {
    final homeScreen = find.byKey(WidgetKeys.homeScreen);
  }

  Future<void> tapBackButton() async{
    await tester.tap(find.byKey(WidgetKeys.savedPlaceScreenBackButton));
    await tester.pumpAndSettle(); // Wait for the UI to settle
  }
}