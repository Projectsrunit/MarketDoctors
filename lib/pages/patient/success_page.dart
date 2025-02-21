import 'package:flutter/material.dart';
import 'package:market_doctor/pages/patient/login_page.dart';

class PatientSuccessPage extends StatelessWidget {
  const PatientSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular Tick Icon
              const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 150,
              ),
              const SizedBox(height: 20),

              // Success Message
              const Text(
                'Verification Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Additional Information
             
              const SizedBox(height: 30),

              // Go to Login Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PatientLoginPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 50), // Full-width button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Proceed to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
