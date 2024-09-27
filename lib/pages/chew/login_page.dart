import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For handling JSON
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/chew/chew_home.dart';
import 'package:market_doctor/pages/chew/signup_page.dart';
import 'package:provider/provider.dart';

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
          //to get full user record with profile picture etc
          var url = Uri.parse('$baseUrl/api/users/${responseBody['user']['id']}?populate=*');
          final fullRecord = await http.get(url);
          if (fullRecord.statusCode == 200) {
            var recordBody = jsonDecode(fullRecord.body);
            _showMessage('Welcome Back!', isError: false);
            context.read<DataStore>().updateChewData(recordBody);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChewHome()));
          }
        } else {
          var errorResponse = jsonDecode(response.body);
          String errorMessage = errorResponse['error']?['message'] ??
              'Login failed. Please try again.';

          // Check if the error message is 'Role does not match'
          if (errorMessage == 'Role does not match') {
            _showMessage('Please log in with a different user type.');
          } else {
            _showMessage(errorMessage);
          }
        }
      } catch (error) {
        _showMessage('An error occurred. Please try again.');
        print('$error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    return;
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 160),
              Text(
                'Welcome Back,',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Text(
                'Login to your account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don’t have an account? ",
                    style: TextStyle(fontSize: 18),
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
                        obscureText: true,
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
