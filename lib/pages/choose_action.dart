import 'package:flutter/material.dart';
import 'package:market_doctor/pages/user_type.dart';

class ChooseActionPage extends StatelessWidget {
  const ChooseActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
            24.0), // Increased padding around the whole body
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Stretch buttons to full width
          children: [
            // Company Logo
            Image.asset(
              'assets/images/logo.png',
              height: 150, // Adjusted logo height for better scaling
            ),
            const SizedBox(height: 40), // Increased space between logo and text

            // Title Text
            const Text(
              'Welcome to Market Doctor',
              style: TextStyle(
                fontSize: 26, // Larger font size for title
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
                height: 20), // Increased space between title and description

            // Description Text
            const Text(
              'Please choose an option to continue:',
              style: TextStyle(
                fontSize:
                    18, // Slightly larger font size for better readability
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40), // Increased space before the buttons

            // Login Button (ElevatedButton)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChooseUserTypePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 20), // Increased vertical padding
                elevation: 16, // Slightly more elevation for a raised effect
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(19), // More rounded corners
                ),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.blueGrey[10],
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20), // Increased space between buttons

            // Signup Button (ElevatedButton)
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChooseUserTypePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.blueGrey[10],
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
