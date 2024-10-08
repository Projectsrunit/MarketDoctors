import 'package:flutter/material.dart';
import 'package:market_doctor/pages/user_type.dart';
import 'package:market_doctor/pages/user_type2.dart';

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

            const SizedBox(
                height: 20), // Increased space between title and description

            // Increased space before the buttons

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
                    : const Color.fromARGB(255, 226, 234, 238),
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
                    builder: (context) => const ChooseUserTypePageTwo(),
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
                    :const Color.fromARGB(255, 226, 234, 238),
              ),
              child: const Text(
                'Create an account',
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
