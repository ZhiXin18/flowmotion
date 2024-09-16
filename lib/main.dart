import 'package:flowmotion/screens/home.dart';
import 'package:flowmotion/screens/login.dart';
import 'package:flowmotion/screens/register.dart';
import 'package:flowmotion/widgets/splash_page.dart';
import 'package:flutter/material.dart';

void main() {
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
          '/': (context) => SplashPage(),
          'register': (context) => const RegisterScreen(),
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
        }
    );
  }
}

