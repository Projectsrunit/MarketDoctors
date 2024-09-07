import 'package:flutter/material.dart';
import 'package:market_doctor/pages/user_type.dart';

class ChooseActionPage extends StatelessWidget {
  const ChooseActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Action'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Company Logo
            Image.asset('assets/images/logo.png'),
            const SizedBox(height: 20),

            // Title Text
            const Text(
              'Welcome to Market Doctor',
              style: TextStyle(
                fontSize: 24, // Large font size
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description Text
            const Text(
              'Please choose an option to continue:',
              style: TextStyle(
                fontSize: 16, // Medium font size
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

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
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.blueGrey[700] // Darker button for dark mode
                    : Color(0xFF617DEF), // Primary color for light mode
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // White text for better contrast
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

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
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.blueGrey[700] // Darker button for dark mode
                    : Color(0xFF617DEF), // Primary color for light mode
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white, // White text for better contrast
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
