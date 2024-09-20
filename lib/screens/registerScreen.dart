import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flowmotion/screens/homeScreen.dart';
import 'package:flowmotion/screens/savedPlaceScreen.dart';
import 'package:flutter/material.dart';

import '../components/background.dart';
import '../firebase_options.dart';
import 'loginScreen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> main() async {
  //make sure native code is set up correctly, need initialise native app before initialising firebase
  WidgetsFlutterBinding.ensureInitialized(); //auto called inside runApp, but need do before runApp so need do this codes
  await Firebase.initializeApp( //start firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const RegisterScreen());
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _success = false;
  late String _userEmail;

  // Validation method
  bool _validateInputs() {
    if (_usernameController.text.isEmpty) {
      _showErrorDialog('Please enter your name.');
      return false;
    }
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

  // Show error dialog if inputs are missing
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _register() async {
    if (!_validateInputs()) {
      return; // Stop registration if inputs are not valid
    }

    String email = _emailController.text;

    try {
      // Check if email is already in use
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        _showErrorDialog('Email is already in use. Please use a different email.');
        return;
      }

      // Proceed with registration if email is not in use
      final User? user = (
          await _auth.createUserWithEmailAndPassword(
            email: email,
            password: _passwordController.text,
          )
      ).user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email!;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => //SavedPlaceScreen(
                //userId: user.uid,
                //userEmail: user.email!,
              //),
              const HomeScreen(),
            ),
          );
        });
      } else {
        setState(() {
          _success = false;
          _showErrorDialog('Failed to register. Please try again.');
        });
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                '01.',
                style: TextStyle(
                  color: Color(0xFFD4543C),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Hello! Nice to meet you.',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30),
            _buildTextField(
              controller: _usernameController,
              hintText: 'Your Name',
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              hintText: 'Your Email',
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _passwordController,
              hintText: 'Password',
              isPassword: true,
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Action for "Next" button
                  _register();
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.grey),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: Text(
                  'Next',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
