import 'package:flutter/material.dart';
import 'package:market_doctor/services/notification_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminNotificationsPage extends StatefulWidget {
  @override
  _AdminNotificationsPageState createState() => _AdminNotificationsPageState();
}

class _AdminNotificationsPageState extends State<AdminNotificationsPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedUserType = 'all';
  String? _selectedUser;
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final baseUrl = dotenv.env['API_URL']!;
      final response = await http.get(Uri.parse('$baseUrl/api/users'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _users = List<Map<String, dynamic>>.from(data['data']);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching users: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_selectedUserType == 'all') {
        await NotificationService.sendNotificationBySegment(
          heading: _titleController.text,
          content: _messageController.text,
          segment: 'All',
        );
      } else if (_selectedUserType == 'role') {
        await NotificationService.sendNotificationBySegment(
          heading: _titleController.text,
          content: _messageController.text,
          segment: _selectedUserType == 'doctor' ? 'Doctors' : 
                  _selectedUserType == 'chew' ? 'CHEWs' : 'Patients',
        );
      } else if (_selectedUser != null) {
        await NotificationService.sendNotification(
          heading: _titleController.text,
          content: _messageController.text,
          playerIds: [_selectedUser!],
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification sent successfully')),
      );

      _titleController.clear();
      _messageController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send notification: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notifications'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedUserType,
                      decoration: InputDecoration(
                        labelText: 'Select Target Users',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: 'all', child: Text('All Users')),
                        DropdownMenuItem(value: 'doctor', child: Text('All Doctors')),
                        DropdownMenuItem(value: 'chew', child: Text('All CHEWs')),
                        DropdownMenuItem(value: 'patient', child: Text('All Patients')),
                        DropdownMenuItem(value: 'specific', child: Text('Specific User')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedUserType = value!;
                          _selectedUser = null;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    if (_selectedUserType == 'specific') ...[
                      DropdownButtonFormField<String>(
                        value: _selectedUser,
                        decoration: InputDecoration(
                          labelText: 'Select User',
                          border: OutlineInputBorder(),
                        ),
                        items: _users.map((user) {
                          return DropdownMenuItem(
                            value: user['id'].toString(),
                            child: Text('${user['firstName']} ${user['lastName']} (${user['email']})'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedUser = value);
                        },
                        validator: (value) {
                          if (_selectedUserType == 'specific' && value == null) {
                            return 'Please select a user';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Notification Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Notification Message',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _sendNotification,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        _isLoading ? 'Sending...' : 'Send Notification',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }
} 