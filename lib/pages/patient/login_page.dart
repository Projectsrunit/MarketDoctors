import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For handling JSON
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/patient/patient_home.dart';
import 'package:market_doctor/pages/patient/signup_page.dart';
import 'package:provider/provider.dart';
import 'package:market_doctor/services/notification_service.dart';
import 'package:market_doctor/services/subscription_service.dart';
import 'package:market_doctor/pages/patient/subscription_page.dart';

class PatientLoginPage extends StatefulWidget {
  const PatientLoginPage({super.key});

  @override
  State<PatientLoginPage> createState() => _PatientLoginPageState();
}

class _PatientLoginPageState extends State<PatientLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _role = 5;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        var url = Uri.parse('${dotenv.env['API_URL']}/api/auth/login');
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text,
            'password': _passwordController.text,
            'role': _role,
          }),
        );

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);
          var userId = responseBody['user']['id'].toString();

          // First get the full user record
          var userUrl = Uri.parse(
              '${dotenv.env['API_URL']}/api/users/$userId?populate=*');
          final fullRecord = await http.get(userUrl);
          var recordBody = jsonDecode(fullRecord.body);

          // Store user data first
          context.read<DataStore>().updatePatientData(recordBody);
          
          // Register for notifications
          await NotificationService.handleLogin(userId, 'patient');

          // Navigate to subscription page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SubscriptionPage(userId: userId),
            ),
          );
        } else {
          var errorResponse = jsonDecode(response.body);
          String errorMessage = errorResponse['error']?['message'] ??
              'Login failed. Please try again.';

          if (errorMessage == 'Role does not match') {
            _showMessage('Please log in with a different user type.');
          } else {
            _showMessage(errorMessage);
          }
        }
      } catch (e) {
        _showMessage('An error occurred: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 160),
              Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Text('Login to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PatientSignUpPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 111, 136, 223),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4), // Shadow color
                            spreadRadius: 1, // How much the shadow spreads
                            blurRadius: 5, // How blurry the shadow is
                            offset: const Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          filled: true,
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[850]
                                  : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.email),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold, // Make label text bold
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4), // Shadow color
                            spreadRadius: 1, // How much the shadow spreads
                            blurRadius: 5, // How blurry the shadow is
                            offset: const Offset(0, 3), // Shadow position
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[850]
                                  : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none, // Remove border
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          labelStyle: const TextStyle(
                            fontWeight: FontWeight.bold, // Make label text bold
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                    ),
                    const SizedBox(
                        height: 40), // Increased spacing before login button
                    _isLoading
                        ? const CircularProgressIndicator()
                        : TextButton(
                            onPressed: _loginUser,
                            style: TextButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 111, 136, 223),
                            ),
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
