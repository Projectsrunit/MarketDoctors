import 'package:flutter/material.dart';
import 'package:market_doctor/pages/patient/success_page.dart';

class PatientVerificationPage extends StatefulWidget {
  const PatientVerificationPage({Key? key}) : super(key: key);

  @override
  State<PatientVerificationPage> createState() => _PatientVerificationPageState();
}

class _PatientVerificationPageState extends State<PatientVerificationPage> {
  final _otpControllers = List.generate(4, (index) => TextEditingController());

  void _verifyOtp() {
    // Concatenate the four input values to form the OTP
    final otp = _otpControllers.map((controller) => controller.text).join();
    print("Entered OTP: $otp");
    // Handle OTP verification logic here, e.g., make an API call to verify OTP
  }

  void _resendOtp() {
    // Handle OTP resend logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP has been resent to your email and phone number.'),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Verification',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter the OTP sent to your mail and phone number',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Four TextFields for the OTP input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _otpControllers[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,  // Only 1 digit per field
                      decoration: InputDecoration(
                        counterText: '',  // Hide the character counter
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _verifyOtp();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PatientSuccessPage(),
                    ),
                  );
                },
                child: const Text('Continue'),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _resendOtp,
                child: const Text(
                  'Did not receive Code? Ask for Resend',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
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
