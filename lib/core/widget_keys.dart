import 'package:flutter/foundation.dart';

class WidgetKeys {
  //splash screen widgets
  static const Key splashScreen = Key('splashScreen');

  //login screen widgets
  static const Key loginScreen = Key('loginScreen');
  static const Key loginEmailController = Key('loginEmailController');
  static const Key loginPasswordController = Key('loginPasswordController');
  static const Key loginButton = Key('loginButton');
  static const Key loginErrorSnackbar = Key('loginErrorSnackbar');
  static const Key loginErrorDialog = Key('loginErrorDialog');
  static const Key loginErrorOK = Key('loginErrorOK');

  //register screen widgets
  static const Key goRegisterButton = Key('goRegisterButton');
  static const Key registerScreen = Key('registerScreen');
  static const Key registerNameController = Key('registerNameController');
  static const Key registerEmailController = Key('registerEmailController');
  static const Key registerPasswordController = Key('registerPasswordController');
  static const Key registerButton = Key('registerButton');
  static const Key registerErrorDialog = Key('registerErrorDialog');
  static const Key registerErrorOK = Key('registerErrorOK');

  //saved place screen widgets
  static const Key savedPlaceScreen = Key('savedPlaceScreen');
  static const Key addMoreButton = Key('addMoreButton');
  static const Key addMoreDialog = Key('addMoreDialog');
  static final Key addressNameTextField = Key('addressNameTextField');
  static final Key addMoreCancelButton = Key('addMoreCancelButton');
  static final Key addButton = Key('addButton');
  static const Key getStartedButton = Key('getStartedButton');
  static final Key termsCheckbox = Key('termsCheckbox');
  static final Key notificationsCheckbox = Key('notificationsCheckbox');
  static final Key dismissKeyboard = Key('dismissKeyboard');
  static final Key savedPlaceScreenBackButton = Key('savedPlaceScreenBackButton');

  // For address fields
  static Key addressField(int index) => Key('addressField_$index');
  static Key addressPostalCodeField(int index) => Key('addressPostalCodeField_$index');


  //home screen widgets
  static const Key homeScreen = Key('homeScreen');
  static const Key goMapButton = Key('goMapButton');
  static const Key fullMapScreen = Key('fullMapScreen');
}