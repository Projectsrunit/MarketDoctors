// ignore_for_file: unused_local_variable, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/pages/doctor/upload_file.dart';
import 'dart:convert'; // For JSON encoding and decoding
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv package

class DoctorVerificationPage extends StatefulWidget {
  final String reference;

  const DoctorVerificationPage({super.key, required this.reference});

  @override
  State<DoctorVerificationPage> createState() => _DoctorVerificationPageState();
}

class _DoctorVerificationPageState extends State<DoctorVerificationPage> {
  final _otpControllers = List.generate(4, (index) => TextEditingController());
  final _focusNodes =
      List.generate(4, (index) => FocusNode()); // Create FocusNodes
  bool _isLoading = false;
  String baseUrl = dotenv.env['API_URL']!;

  // This function will make a POST request to verify the OTP
  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length != 4) {
      // Show error if OTP is not 4 digits long
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please enter a valid 4-digit OTP sent to your Email.')),
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
        "email": widget.reference,
        "otp": otp,
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

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const DoctorsUploadCredentialsPage(),
          ),
        );
      } else {
        // Show an error message if the verification failed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('OTP verification failed. Please try again.')),
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
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'Enter the OTP sent to your email',
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
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
                      focusNode: _focusNodes[index], // Assign FocusNode
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1, // Only 1 digit per field
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 3) {
                          // Move to the next field when a digit is entered
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          // Move to the previous field on backspace
                          _focusNodes[index - 1].requestFocus();
                        }
                      },
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
                onPressed: _isLoading
                    ? null
                    : _verifyOtp, // Disable button when loading
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
                onTap: _isLoading ? null : _resendOtp, // Disable if loading
                child: Text(
                  'Check your Inbox / Spam folder for the code',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.blue,
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
