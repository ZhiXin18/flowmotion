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

  //home screen widgets
  static const Key homeScreen = Key('homeScreen');
}