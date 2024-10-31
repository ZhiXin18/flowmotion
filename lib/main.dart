import 'package:flowmotion/screens/homeScreen.dart';
import 'package:flowmotion/screens/loginScreen.dart';
import 'package:flowmotion/screens/profileScreen.dart';
import 'package:flowmotion/screens/registerScreen.dart';
import 'package:flowmotion/widgets/splashScreen.dart';
import 'package:flowmotion_api/flowmotion_api.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/register': (context) => RegisterScreen(),
          '/login': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/profile': (context) => ProfileScreen(),
        }
    );
  }
}

