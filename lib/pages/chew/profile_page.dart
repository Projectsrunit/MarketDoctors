import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chewAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(width: 8),
                  Text('General',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildGeneralList(context),
            SizedBox(height: 8), // List of rows under "General"
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.settings),
                  SizedBox(width: 8),
                  Text('System',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildSystemList(context), // List of rows under "System"
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _buildGeneralList(context) {
    return Column(
      children: [
        _buildArrowRow(Icons.account_circle, "Profile information", () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UpdateProfileChew()));
        }),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildArrowRow(Icons.payment, "Manage payments", () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManagePaymentsChew()));
        }),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildArrowRow(Icons.school, "Update qualifications", () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdateQualificationChew()));
        }),
      ],
    );
  }

  Widget _buildSystemList(context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return Column(
      children: [
        _buildModeToggleRow(
            context, Icons.dark_mode, "Dark mode", themeNotifier.toggleTheme),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildNoArrowRow(Icons.lock, "Change password", _showPasswordPopup),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildNoArrowRow(Icons.pin, "Change transaction pin", _showPinPopup),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildNotifToggleRow(Icons.notifications, "Allow notifications", () {}),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildNoArrowRow(Icons.logout, "Log out", () {}),
      ],
    );
  }

  Widget _buildModeToggleRow(BuildContext context, IconData icon, String label,
      VoidCallback onToggle) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(label),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (value) {
                  onToggle();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNotifToggleRow(IconData icon, String label,
      VoidCallback onToggle) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(label),
            ),
            Transform.scale(
              scale: 0.8,
              child: Switch(
                value: true,
                onChanged: (value) {
                  onToggle();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildArrowRow(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Text(label),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildNoArrowRow(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  void _showPasswordPopup() {
    // Show dialog for changing password
  }

  void _showPinPopup() {
    // Show dialog for changing transaction pin
  }
}

class UpdateQualificationChew extends StatefulWidget {
  @override
  _UpdateQualificationChewState createState() =>
      _UpdateQualificationChewState();
}

class _UpdateQualificationChewState extends State<UpdateQualificationChew> {
  List<String> qualifications = [
    "B.Sc. Computer Science",
    "M.Sc. Information Technology"
  ];
  final TextEditingController qualificationController = TextEditingController();

  void addQualification() {
    setState(() {
      qualifications.add(qualificationController.text);
      qualificationController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Manage qualifications',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('Qualification', style: TextStyle(fontSize: 18)),
        Column(
          children: qualifications
              .map((qual) => ListTile(title: Text(qual)))
              .toList(),
        ),
        SizedBox(height: 20),
        Text('Add new', style: TextStyle(fontSize: 18)),
        TextField(
          controller: qualificationController,
          decoration: InputDecoration(labelText: 'Qualification'),
        ),
        ElevatedButton(
          onPressed: addQualification,
          child: Text('Save'),
        ),
      ],
    );
  }
}

class ManagePaymentsChew extends StatefulWidget {
  @override
  _ManagePaymentsChewState createState() => _ManagePaymentsChewState();
}

class _ManagePaymentsChewState extends State<ManagePaymentsChew> {
  void _showAddBankAccountPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add a new bank account'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(decoration: InputDecoration(labelText: 'Bank name')),
              TextField(decoration: InputDecoration(labelText: 'Account No.')),
              TextField(decoration: InputDecoration(labelText: 'Account name')),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel')),
            ElevatedButton(onPressed: () {}, child: Text('Save')),
          ],
        );
      },
    );
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm delete'),
          content: Text('Are you sure you want to delete this bank account?'),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel')),
            ElevatedButton(onPressed: () {}, child: Text('Delete')),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bank accounts',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('Important reminders:'),
        Text('1. Payments are disbursed on the last day of the month.'),
        Text('2. All account numbers must match the name of the profile.'),
        Text(
            '3. Earnings must be greater than N20,000 before disbursement is made.'),
        SizedBox(height: 20),
        Divider(thickness: 2),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('John Doe',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('ABC Bank'),
                Text('1234567890'),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _showAddBankAccountPopup,
          child: Text('Add a new bank account'),
        ),
      ],
    );
  }
}

class UpdateProfileChew extends StatefulWidget {
  @override
  UpdateProfileChewState createState() => UpdateProfileChewState();
}

class UpdateProfileChewState extends State<UpdateProfileChew> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void _sendOTP(String type) {
    int otp = _generateOTP();
    // Call API to send OTP (Simulated here)
    print("Sending OTP $otp to $type");

    _showOTPPopup(type);
  }

  int _generateOTP() {
    var random = Random();
    return random.nextInt(900000) + 100000; // Generates a 6-digit OTP
  }

  void _showOTPPopup(String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter the OTP sent to your $type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Enter OTP'),
              ),
              SizedBox(height: 10),
              Text("Did not receive code? Ask for resend"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chewAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Update Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _sendOTP('number'),
                  child: Text('Verify'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _sendOTP('email'),
                  child: Text('Verify'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
