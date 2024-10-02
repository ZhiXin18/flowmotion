import 'package:flowmotion/core/widget_keys.dart';
import 'package:flowmotion/models/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import '../utils/polling_finder.dart';

class RegisterRobot {
  final WidgetTester tester;

  RegisterRobot({required this.tester});

  Future<void> verifyBootup() async {
    await find.byKey(WidgetKeys.splashScreen).wait(tester);
  }

  Future<void> verify() async {
    await find.byKey(WidgetKeys.loginScreen).wait(tester);
  }

  Future<void> enterName(String name) async {
    final nameField =
        await find.byKey(WidgetKeys.registerNameController).wait(tester);
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, name);
    await tester.pump();
  }

  Future<void> enterEmail(String email) async {
    final emailField =
        await find.byKey(WidgetKeys.registerEmailController).wait(tester);
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, email);
    await tester.pump();
  }

  Future<void> enterPassword(String password) async {
    final passwordField =
        await find.byKey(WidgetKeys.registerPasswordController).wait(tester);
    expect(passwordField, findsOneWidget);
    await tester.enterText(passwordField, password);
    await tester.pump();
  }

  Future<void> tapRegisterButton() async {
    final registerButton =
        await find.byKey(WidgetKeys.registerButton).wait(tester);
    expect(registerButton, findsOneWidget);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapOKButton() async {
    final okButton = await find.byKey(WidgetKeys.registerErrorOK).wait(tester);
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();
  }

  Future<void> verifyError() async {
    final errorDialog =
        await find.byKey(WidgetKeys.registerErrorDialog).wait(tester);
    expect(errorDialog, findsOneWidget);
  }

  // Helper function to verify error messages
  Future<void> verifyErrorMessage(String expectedMessage) async {
    await verifyError();
    expect(await find.text(expectedMessage).wait(tester), findsOneWidget);
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
    final postalCodeField = await find
        .byKey(WidgetKeys.addressPostalCodeField(indexToClear))
        .wait(tester);
    final addressField =
        await find.byKey(WidgetKeys.addressField(indexToClear)).wait(tester);

    expect(postalCodeField, findsOneWidget);
    await tester.enterText(postalCodeField, "");
    await tester.pump();

    expect(addressField, findsOneWidget);
    await tester.enterText(addressField, "");
    await tester.pump();
  }

  Future<void> verifyPartSuccess() async {
    await find.byKey(WidgetKeys.savedPlaceScreen).wait(tester);
  }

  Future<void> enterAddress(List<Address> addresses) async {
    for (int i = 0; i < 2; i++) {
      final postalCodeField =
          await find.byKey(WidgetKeys.addressPostalCodeField(i)).wait(tester);
      final addressField =
          await find.byKey(WidgetKeys.addressField(i)).wait(tester);

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
      final postalCodeField = await .wait(tester)find.byKey(WidgetKeys.addressPostalCodeField(i)).wait(tester);
      final addressField = await find.byKey(WidgetKeys.addressField(i)).wait(tester);

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
    final postalCodeField =
        await find.byKey(WidgetKeys.addressPostalCodeField(index)).wait(tester);
    final specifiedAddressField = await find.byKey(WidgetKeys.addressField(index)).wait(tester);

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
    await tester.tap(
        // Change this to an appropriate widget if needed
        await find.byKey(WidgetKeys .dismissKeyboard).wait(tester));
    await tester
        .pumpAndSettle(const Duration(seconds: 5)); // Wait for the UI to settle
  }

  Future<void> tapAddMoreButton() async {
    await tester.tap(await find.byKey(WidgetKeys.addMoreButton).wait(tester));
    await tester.pumpAndSettle(); // Wait for the UI to settle
  }

  Future<void> verifyAddMore() async {
    final addMoreDialog = await find.byKey(WidgetKeys.addMoreDialog).wait(tester);
    expect(addMoreDialog,
        findsOneWidget); // Verify that dialog shows to add address
    final newAddressName = await find.byKey(WidgetKeys.addressNameTextField).wait(tester);
    expect(newAddressName, findsOneWidget);
    await tester.enterText(newAddressName, "School"); // Enter new address name
    await tester.pump();
    await tapAddButton();
  }

  Future<void> tapCancelButton() async {
    await tester.tap(await find.byKey(WidgetKeys.addMoreCancelButton).wait(tester));
    await tester.pumpAndSettle(); // Wait for the UI to settle
  }

  Future<void> tapAddButton() async {
    await tester.tap(await find.byKey(WidgetKeys.addButton).wait(tester));
    await tester.pumpAndSettle(); // Wait for the UI to settle
  }

  Future<void> tapTermsCheckbox() async {
    final termsCheckbox = await find.byKey(WidgetKeys.termsCheckbox).wait(tester);
    expect(termsCheckbox, findsOneWidget);
    await tester.tap(termsCheckbox);
    await tester.pumpAndSettle();
  }

  Future<void> tapNotificationCheckbox() async {
    final notificationsCheckbox = await find.byKey(WidgetKeys.notificationsCheckbox).wait(tester);
    expect(notificationsCheckbox, findsOneWidget);
    await tester.tap(notificationsCheckbox);
    await tester.pumpAndSettle();
  }

  Future<void> tapGetStartedButton() async {
    final getStartedButton =
        await find.byKey(WidgetKeys.getStartedButton).wait(tester);
    expect(getStartedButton, findsOneWidget);
    await tester.tap(getStartedButton);
    await tester.pumpAndSettle();
  }

  Future<void> verifyRegisterSuccess() async {
    await find.byKey(WidgetKeys.homeScreen).wait(tester);
  }

  Future<void> tapBackButton() async {
    final savedPlaceScreenBackButton =
        await find.byKey(WidgetKeys.savedPlaceScreenBackButton).wait(tester);
    expect(savedPlaceScreenBackButton, findsOneWidget);
    await tester.tap(savedPlaceScreenBackButton);
    await tester.pumpAndSettle(); // Wait for the UI to settle
  }
}

