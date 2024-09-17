import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/pages/chew/check_inbox.dart';
import 'package:market_doctor/pages/chew/login_page.dart';
import 'package:market_doctor/data/countries.dart';

class ChewSignUpPage extends StatefulWidget {
  const ChewSignUpPage({Key? key}) : super(key: key);

  @override
  State<ChewSignUpPage> createState() => _ChewSignUpPageState();
}

class _ChewSignUpPageState extends State<ChewSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

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
          "role": 4
        };

        try {
          // Make the POST request
          http.Response response = await http.post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: json.encode(signUpData),
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            _showSnackBar('Sign up successful');
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const ChewCheckInboxPage()),
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Let’s get you signed up',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
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
        const Text(
          "Already Signed Up? ",
          style: TextStyle(color: Colors.black, fontSize: 16),  // Changed to black
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ChewLoginPage()),
            );
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
    return _buildTextField(
      controller: _passwordController,
      labelText: 'Password',
      obscureText: true,
      prefixIcon: const Icon(Icons.lock),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return Row(
      children: [
        Expanded(
          flex: 2,
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
                    Text('(${country['code']})'),
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
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [LengthLimitingTextInputFormatter(10)],
            decoration: InputDecoration(
              prefixText: '$_selectedCountryCode ',
              labelText: 'Phone Number',
              fillColor: Colors.grey[200],
              filled: true,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
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
        child: TextFormField(
          controller: _dobController,
          decoration: const InputDecoration(
            labelText: 'Date of Birth',
            prefixIcon: Icon(Icons.calendar_today),
            fillColor: Color.fromARGB(255, 247, 244, 244),
            filled: true,
            border: InputBorder.none,
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
        const Expanded(
          child: Text(
            'I accept the terms and conditions',
            style: TextStyle(fontSize: 16),
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
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200], // Light grey background
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),  // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,  // Bold label text
          ),
          prefixIcon: prefixIcon,
          fillColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[850]
            : Colors.white,
          border: InputBorder.none,  // Removes the border
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        ),
        validator: validator,
      ),
    );
  }
}
