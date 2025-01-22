import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:market_doctor/pages/patient/check_inbox.dart';
import 'package:market_doctor/data/countries.dart';
import 'package:market_doctor/pages/terms.dart';
import 'package:market_doctor/pages/patient/verification_page.dart';

class PatientSignUpPage extends StatefulWidget {
  const PatientSignUpPage({super.key});

  @override
  State<PatientSignUpPage> createState() => _PatientSignUpPage();
}

class _PatientSignUpPage extends State<PatientSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  bool _isPasswordVisible = false;

  String _selectedCountryCode = '+234';
  bool _termsAccepted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_termsAccepted) {
        _showSnackBar('Please accept the terms and conditions');
      } else {
        setState(() {
          _isLoading = true;
        });

        // API request setup
        String baseUrl = dotenv.env['API_URL']!;
        String url = '$baseUrl/api/auth/register';

        // Prepare the data to be sent to the backend
        Map<String, dynamic> signUpData = {
          "firstName": _firstNameController.text.trim(),
          "lastName": _lastNameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text,
          "dateOfBirth": _dobController.text,
          "phone": '$_selectedCountryCode${_phoneController.text.trim()}',
          "role": 5
        };

        try {
          // Make the POST request
          http.Response response = await http.post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: json.encode(signUpData),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            // Parse the response
            Map<String, dynamic> responseData = json.decode(response.body);

            // Check if the OTP was sent successfully
            if (responseData['message'] == "OTP sent successfully") {
              // Show a message to the user
              _showSnackBar(
                  'OTP message was sent to your email, check your inbox or spam');
            }

            // Get the reference from the response
            String reference =
                responseData['sendchampResponse']['data']['reference'];

            // Navigate to PatientVerificationPage with the reference
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    PatientVerificationPage(reference: reference),
              ),
            );
          } else {
            _showSnackBar('Sign up failed: ${response.body}');
          }
        } catch (e) {
          _showSnackBar('Error: $e');
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black // Dark mode background
          : Colors.white, // Light mode background
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Let’s get you signed up',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    )),
                const SizedBox(height: 10),
                _buildLoginPrompt(),
                const SizedBox(height: 20),
                _buildSignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already Signed Up? ",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white // White text in dark mode
                : Colors.black, // Black text in light mode
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(builder: (context) => const PatientLoginPage()),
            // );
          },
          child: const Text(
            'Log In',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4672ff),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildNameFields(),
          const SizedBox(height: 16),
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 16),
          _buildPhoneField(),
          const SizedBox(height: 16),
          _buildDobField(),
          const SizedBox(height: 16),
          _buildTermsAndConditions(),
          const SizedBox(height: 20),
          _buildSignUpButton(),
        ],
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: _buildTextField(
            controller: _firstNameController,
            labelText: 'First Name',
            validator: _validateName,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTextField(
            controller: _lastNameController,
            labelText: 'Last Name',
            validator: _validateName,
          ),
        ),
      ],
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: _emailController,
      labelText: 'Email',
      keyboardType: TextInputType.emailAddress,
      prefixIcon: const Icon(Icons.email),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850] // Dark mode background
            : Colors.grey[300], // Light mode grey background
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold, // Make the label text bold
          ),
          prefixIcon: const Icon(Icons.lock),
          filled: true,
          fillColor: Colors.transparent, // Set fill color to transparent
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none, // Remove border in light mode
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none, // Remove border in light mode
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          } else if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPhoneField() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[850] // Dark mode background
                  : Colors.grey[300], // Light mode grey background

              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2), // Shadow position
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedCountryCode,
              items: countryCodes.map((country) {
                return DropdownMenuItem<String>(
                  value: country['code'],
                  child: Row(
                    children: [
                      Image.network(
                        country['flagUrl'] ?? 'https://flagcdn.com/w320/ng.png',
                        width: 32,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.flag);
                        },
                      ),
                      const SizedBox(width: 8),
                      Text('(${country['code']})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          )),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCountryCode = value!;
                });
              },
              decoration: InputDecoration(
                fillColor: Colors.transparent, // Set fill color to transparent
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Remove border in light mode
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Remove border in light mode
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[850] // Dark mode background
                  : Colors.grey[300], // Light mode grey background
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2), // Shadow position
                ),
              ],
            ),
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              decoration: InputDecoration(
                prefixText: '$_selectedCountryCode ',
                labelText: 'Phone Number',
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold, // Make the label text bold
                ),
                filled: true,
                fillColor: Colors.transparent, // Set fill color to transparent
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Remove border in light mode
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none, // Remove border in light mode
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDobField() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          _dobController.text = formattedDate;
        }
      },
      child: AbsorbPointer(
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey[850] // Dark mode background
                : Colors.grey[300], // Light mode grey background
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2), // Shadow position
              ),
            ],
          ),
          child: TextFormField(
            controller: _dobController,
            decoration: InputDecoration(
              labelText: 'Date of Birth',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold, // Make the label text bold
              ),
              prefixIcon: const Icon(Icons.calendar_today),
              filled: true,
              fillColor: Colors.transparent, // Set fill color to transparent
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none, // Remove border in light mode
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none, // Remove border in light mode
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Row(
      children: [
        Checkbox(
          value: _termsAccepted,
          onChanged: (value) {
            setState(() {
              _termsAccepted = value ?? false;
            });
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TermsAndConditions(),
                ),
              );
            },
            child: const Text(
              'I accept the terms and conditions',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4672ff), // Make the text blue and clickable
                decoration:
                    TextDecoration.underline, // Add underline for emphasis
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _signUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue, // Background color
        padding: const EdgeInsets.symmetric(vertical: 16),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isLoading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text(
              'Sign Up',
              style: TextStyle(
                color: Colors.white, // Text color
                fontWeight: FontWeight.bold, // Bold text
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    Widget? prefixIcon,
    String? Function(String?)? validator,
    double height = 60.0, // Default height, adjust as needed
  }) {
    return Container(
      height: height, // Set the height of the container
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850] // Dark mode background
            : Colors.grey[300], // Light mode grey background
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold, // Make the label text bold
          ),
          prefixIcon: prefixIcon,
          filled: true,
          fillColor: Colors.transparent, // Set fill color to transparent
          contentPadding: const EdgeInsets.symmetric(
              vertical: 16, horizontal: 12), // Increased vertical padding
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none, // Remove border in light mode
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none, // Remove border in light mode
          ),
        ),
        validator: validator,
      ),
    );
  }
}
