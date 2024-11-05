import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../core/widget_keys.dart';
import '../firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import '../screens/registerScreen.dart';
import '../components/background.dart';
import 'forgetPasswordScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  // Make sure native code is set up correctly, need to initialize native app before initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(LoginScreen());
}

class LoginScreen extends StatefulWidget {
  final FirebaseAuth? auth;

  LoginScreen({Key? key, this.auth}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  int _success = 1;
  String _userEmail = "";

  bool _validateInputs() {
    if (_emailController.text.isEmpty) {
      _showErrorDialog('Please enter your email.');
      return false;
    }
    if (_passwordController.text.isEmpty) {
      _showErrorDialog('Please enter your password.');
      return false;
    }
    return true;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: WidgetKeys.loginErrorDialog,
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            key: WidgetKeys.loginErrorOK,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _signIn() async {
    if (!_validateInputs()) return;

    try {
      final User? user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      if (user != null) {
        setState(() {
          _success = 2;
          _userEmail = user.email!;
          Navigator.of(context).pushNamed('/home');
        });
      } else {
        setState(() {
          _success = 3;
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      _showErrorDialog('The supplied credentials are incorrect. Please try again.');
    } catch (e) {
      _showErrorDialog('The supplied credentials are incorrect. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: WidgetKeys.loginScreen,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA),
                    fontSize: 36,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
          
              SizedBox(height: size.height * 0.03),
          
              // Email TextField with opacity
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Set opacity here
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  key: WidgetKeys.loginEmailController,
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                ),
              ),
          
              SizedBox(height: size.height * 0.03),
          
              // Password TextField with opacity
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Set opacity here
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  key: WidgetKeys.loginPasswordController,
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  ),
                ),
              ),
          
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ForgetPasswordScreen();
                  }));
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: Text(
                    "Forgot your password?",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          
              SizedBox(height: size.height * 0.05),
          
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: ElevatedButton(
                  key: WidgetKeys.loginButton,
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                    padding: EdgeInsets.all(0),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 136, 34),
                          Color.fromARGB(255, 255, 177, 41),
                        ],
                      ),
                    ),
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "LOGIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  key: WidgetKeys.goRegisterButton,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                  },
                  child: Text(
                    "Don't Have an Account? Sign up",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2661FA),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
