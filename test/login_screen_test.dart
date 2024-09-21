import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flowmotion/screens/loginScreen.dart';

void main() {
  testWidgets('Login Screen smoke test', (WidgetTester tester) async {
    // Build the LoginScreen widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Verify that the "LOGIN" text is present on the screen.
    expect(find.text('LOGIN'), findsOneWidget, reason: 'LOGIN text should be visible on screen');

    // Log statement to track the test's progress
    print("LOGIN text found");

    // Verify that there are two text fields for email and password.
    expect(find.byType(TextField), findsNWidgets(2), reason: 'There should be two text fields (email and password)');

    // Log statement to track the test's progress
    print("Two TextFields found");

    // Enter text into the email and password fields.
    await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    print("Text entered in email and password fields");

    // Tap the login button and trigger a frame.
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // Use pumpAndSettle to wait for any animations to finish.

    // Log statement to confirm that the button was tapped
    print("Login button tapped");

    // Add a placeholder for Firebase authentication response simulation here.
  });

}
