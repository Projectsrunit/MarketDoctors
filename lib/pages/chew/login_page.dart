import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For handling JSON
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/pages/chew/chew_home.dart';
import 'package:market_doctor/pages/chew/signup_page.dart';

class ChewLoginPage extends StatefulWidget {
  const ChewLoginPage({super.key});

  @override
  State<ChewLoginPage> createState() => _ChewLoginPageState();
}

class _ChewLoginPageState extends State<ChewLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _role = 4;
  bool _isLoading = false;

  // Function to handle login
  Future<void> _loginUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text;
      String password = _passwordController.text;
      String? baseUrl = dotenv.env['API_URL'];
      if (baseUrl == null) {
        _showMessage('Error: API URL not configured');
        return;
      }

      try {
        var url = Uri.parse('$baseUrl/api/auth/login');
        var response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
            'role': _role,
          }),
        );

        if (response.statusCode == 200) {
          var responseBody = jsonDecode(response.body);

          // Navigate to the dashboard page after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ChewHome(), // Replace with your actual page
            ),
          );

          _showMessage('Login successful!', isError: false);
        } else {
          var errorResponse = jsonDecode(response.body);
          _showMessage('Login failed: ${errorResponse['message']}');
        }
      } catch (error) {
        _showMessage('An error occurred. Please try again.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to show success or error message
  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Welcome Back Text
                Text(
                  'Welcome Back,',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 36,
                      ),
                ),
                Text(
                  'Login to your account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don’t have an account? ",
                      style: TextStyle(
                        color: Color(0xFFb8b8b8),
                        fontSize: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChewSignUpPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4672ff),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.email),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.lock),
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
                      const SizedBox(height: 20),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : TextButton(
                              onPressed: _loginUser,
                              child: const Text('Log In'),
                              style: TextButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
