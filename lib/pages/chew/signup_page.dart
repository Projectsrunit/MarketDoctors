import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/pages/check_inbox.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:market_doctor/pages/chew/login_page.dart';

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
              MaterialPageRoute(builder: (context) => const CheckInboxPage()),
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
          style: TextStyle(color: Color(0xFFb8b8b8), fontSize: 16),
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
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: CountryCodePicker(
            onChanged: (countryCode) {
              setState(() {
                _selectedCountryCode = countryCode.toString();
              });
            },
            initialSelection: 'NG',
            favorite: ['+234', 'NG'],
            showFlag: true,
            showDropDownButton: true,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your phone number';
        }
        return null;
      },
    );
  }

  Widget _buildDobField() {
    return _buildTextField(
      controller: _dobController,
      labelText: 'Date of Birth',
      readOnly: true,
      prefixIcon: const Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your date of birth';
        }
        return null;
      },
    );
  }

  Widget _buildTermsAndConditions() {
    return CheckboxListTile(
      value: _termsAccepted,
      onChanged: (bool? newValue) {
        setState(() {
          _termsAccepted = newValue ?? false;
        });
      },
      title: const Text('I accept the terms and conditions'),
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
      subtitle: !_termsAccepted
          ? const Text(
              'You need to accept terms and conditions to proceed',
              style: TextStyle(color: Colors.red),
            )
          : null,
    );
  }

  Widget _buildSignUpButton() {
    return TextButton(
      onPressed: _signUp,
      child: const Text('Sign Up'),
      style: TextButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    Icon? prefixIcon,
    bool obscureText = false,
    bool readOnly = false,
    void Function()? onTap,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: prefixIcon,
      ),
      validator: validator,
    );
  }
}
