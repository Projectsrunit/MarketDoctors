import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For handling JSON
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/chew/chew_home.dart';
import 'package:market_doctor/pages/chew/signup_page.dart';
import 'package:provider/provider.dart';
import 'package:market_doctor/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:market_doctor/pages/notifications/notifications_page.dart';
import 'package:market_doctor/models/notification_item.dart';

class ChewLoginPage extends StatefulWidget {
  const ChewLoginPage({super.key});

  @override
  State<ChewLoginPage> createState() => _ChewLoginPageState();
}

class _ChewLoginPageState extends State<ChewLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _role = 'chew';
  bool _isLoading = false;
  bool _isPasswordVisible = false;

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
          
          // Check if user is confirmed - using direct true/false check
          if (responseBody['user']['confirmed'] == false) {
            // Send notification email to admin
            try {
              var notifyUrl = Uri.parse('$baseUrl/api/auth/notify-admin');
              await http.post(
                notifyUrl,
                headers: {
                  'Content-Type': 'application/json',
                },
                body: jsonEncode({
                  'userEmail': email,
                  'userName': responseBody['user']['username'] ?? 'New User',
                  'subject': 'New User Approval Required',
                  'message': 'A new user requires approval to access the system.'
                }),
              );
            } catch (e) {
              print('Failed to send admin notification: $e');
            }
            
            _showMessage('Your account is not yet confirmed. Contact Market Doctor Admin');
            return;
          }

          // Store user info
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', responseBody['token']);
          await prefs.setString('userType', _role);
          await prefs.setString('userId', responseBody['user']['id'].toString());

          // Initialize notifications for the logged-in user
          await NotificationService.handleLogin(
            responseBody['user']['id'].toString(),
            _role,
          );

          // Check if we need to redirect to a specific route (from notification)
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args != null && args.containsKey('returnRoute')) {
            // If there was a pending notification, store it
            if (args.containsKey('notification')) {
              final notification = args['notification'] as Map<String, dynamic>;
              await NotificationsPage.addNotification(
                NotificationItem(
                  title: notification['title'],
                  message: notification['body'],
                  timestamp: notification['timestamp'],
                  data: notification['data'],
                ),
              );
            }
            // Navigate to the return route
            Navigator.of(context).pushReplacementNamed(args['returnRoute']);
          } else {
            // Navigate to the default route based on role
            Navigator.pushReplacementNamed(context, '/chew/home');
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
