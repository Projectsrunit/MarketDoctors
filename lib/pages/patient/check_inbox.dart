import 'package:flutter/material.dart';
import 'package:market_doctor/pages/patient/verification_page.dart';

class PatientCheckInboxPage extends StatelessWidget {
  const PatientCheckInboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Check your inbox',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            const Text(
              'An OTP has been sent to your email and phone number.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Image.asset('assets/images/email-campaign.png',
                height: 300), // Replace with your own image

            const SizedBox(height: 40),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PatientVerificationPage(),
                  ),
                );
              },
              child: const Text('Next'),
              style: TextButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
