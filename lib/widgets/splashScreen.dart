import 'dart:async';
import 'package:flowmotion/core/widget_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core.
import '../firebase_options.dart'; // Ensure you have this file.
import 'package:flowmotion/screens/loginScreen.dart';
import 'package:flowmotion/screens/registerScreen.dart';
import 'package:flowmotion/screens/homeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initializeFirebaseAndStartSplash();
  }

  /// Initialize Firebase before starting the splash screen timer.
  Future<void> initializeFirebaseAndStartSplash() async {
    try {
      // Initialize Firebase.
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      // Once Firebase is initialized, start the splash screen timer.
      startSplashScreenTimer();
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }

  /// Start a timer for the splash screen duration.
  startSplashScreenTimer() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigateToPage);
  }

  /// Navigate to the login screen after the splash screen timer completes.
  void navigateToPage() {
    if (!mounted) return;
    Navigator.pushReplacement(
      (context),
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    return Container(
      key:  WidgetKeys.splashScreen,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.fitHeight,
          image: ExactAssetImage("images/motto.png"),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }
}
