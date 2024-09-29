import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/savedPlaceScreen.dart';
import '../core/widget_keys.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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
  String _userEmail = '';
  String _username = '';

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

    final email = _emailController.text;
    if (!_isValidEmail(email)) {
      _showErrorDialog('Please enter a valid email address.');
      return false;
    }

    if (_passwordController.text.isEmpty) {
      _showErrorDialog('Please enter your password.');
      return false;
    }

    final password = _passwordController.text;
    final passwordRegex = RegExp(r'^(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{5,12}$');
    if (!passwordRegex.hasMatch(password)) {
      _showErrorDialog('Password must be 5-12 characters and include at least one special character.');
      return false;
    }

    return true; // All validations passed
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void _register() async {
    if (!_validateInputs()) {
      return;
    }

    String email = _emailController.text;

    try {
      final signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        _showErrorDialog('Failed to register. Please try again.');
        return;
      }

      // Proceed with registration
      final User? user = (
          await _auth.createUserWithEmailAndPassword(
            email: email,
            password: _passwordController.text,
          )
      ).user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email!; // Initialize _userEmail
          _username = _usernameController.text;
        });

        // Navigate to SavedPlaceScreen after successful registration and email initialization
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SavedPlaceScreen(userId: user.uid, username: _username, userEmail: _userEmail),
          ),
        );
      } else {
        _showErrorDialog('Failed to register. Please try again.');
      }
    } on FirebaseAuthException catch (e) {
      // Catch Firebase specific authentication errors
      if (e.code == 'email-already-in-use') {
        _showErrorDialog('Failed to register. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: WidgetKeys.registerErrorDialog,
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            key: WidgetKeys.registerErrorOK,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
      key: WidgetKeys.registerScreen,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                key: WidgetKeys.registerNameController,
                controller: _usernameController,
                hintText: 'Your Name',
              ),
              SizedBox(height: 20),
              _buildTextField(
                key: WidgetKeys.registerEmailController,
                controller: _emailController,
                hintText: 'Your Email',
              ),
              SizedBox(height: 20),
              _buildTextField(
                key: WidgetKeys.registerPasswordController,
                controller: _passwordController,
                hintText: 'Password',
                isPassword: true,
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  key: WidgetKeys.registerButton,
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.grey),
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required Key key,
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return TextField(
      key: key,
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
    );
  }
}
