import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding and decoding
import 'package:market_doctor/pages/patient/success_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv package

class PatientVerificationPage extends StatefulWidget {
  final String reference;  // Accept reference parameter

  const PatientVerificationPage({Key? key, required this.reference}) : super(key: key);

  @override
  State<PatientVerificationPage> createState() => _PatientVerificationPageState();
}

class _PatientVerificationPageState extends State<PatientVerificationPage> {
  final _otpControllers = List.generate(4, (index) => TextEditingController());
  bool _isLoading = false;  // For loading state during API request
  String baseUrl = dotenv.env['API_URL']!; // Get the API baseUrl from environment

  // This function will make a POST request to verify the OTP
  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((controller) => controller.text).join(); // Concatenate OTP

    if (otp.length != 4) {
      // Show error if OTP is not 4 digits long
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 4-digit OTP.')),
      );
      return;
    }

    // Set the loading state
    setState(() {
      _isLoading = true;
    });

    try {
      // Create the body of the request
      final body = jsonEncode({
        "verification_reference": widget.reference,
        "verification_code": otp,
      });

      // Make the API request
      final response = await http.post(
        Uri.parse('$baseUrl/api/otp/verify'), // Use the baseUrl from dotenv
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Handle the response
      if (response.statusCode == 200) {
        // Parse the response (if needed)
        final responseBody = jsonDecode(response.body);

        // Navigate to the success page on success
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const PatientSuccessPage(),
          ),
        );
      } else {
        // Show an error message if the verification failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP verification failed. Please try again.')),
        );
      }
    } catch (error) {
      // Handle any errors during the API call
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    } finally {
      // Stop the loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resendOtp() {
    // Logic to resend OTP (e.g., make an API call)
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
                      maxLength: 1, // Only 1 digit per field
                      decoration: InputDecoration(
                        counterText: '', // Hide the character counter
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Continue Button
              TextButton(
                onPressed: _isLoading ? null : _verifyOtp,  // Disable button when loading
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Continue'),
              ),
              const SizedBox(height: 20),

              // Resend OTP
              GestureDetector(
                onTap: _isLoading ? null : _resendOtp,  // Disable if loading
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
