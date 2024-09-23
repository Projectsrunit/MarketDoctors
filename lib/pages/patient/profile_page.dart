import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';
import 'package:market_doctor/pages/patient/patient_app_bar.dart';
import 'package:market_doctor/pages/patient/payments_main_widget.dart';
import 'package:market_doctor/pages/patient/update_qualification_patient.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import 'package:market_doctor/pages/choose_action.dart';

class PatientProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(),
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
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }

  Widget _buildGeneralList(context) {
    return Column(
      children: [
        _buildArrowRow(Icons.account_circle, "Profile information", () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => UpdateProfilePatient()));
        }),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildArrowRow(Icons.payment, "Manage payments", () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManagePaymentsPatient()));
        }),
        Divider(color: Colors.grey[300], thickness: 1),
        _buildArrowRow(Icons.school, "Update qualifications", () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UpdateQualificationPatient()));
        }),
      ],
    );
  }

Widget _buildSystemList(BuildContext context) {
  final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

  return Column(
    children: [
      _buildModeToggleRow(
          context, Icons.dark_mode, "Dark mode", themeNotifier.toggleTheme),
      Divider(color: Colors.grey[300], thickness: 1),
      _buildNoArrowRow(context, Icons.lock, "Change password", _showPasswordPopup),
      Divider(color: Colors.grey[300], thickness: 1),
      _buildNoArrowRow(context, Icons.pin, "Change transaction pin", _showPinPopup),
      Divider(color: Colors.grey[300], thickness: 1),
      _buildNotifToggleRow(Icons.notifications, "Allow notifications", () {}),
      Divider(color: Colors.grey[300], thickness: 1),
      _buildNoArrowRow(context, Icons.logout, "Log out", () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ChooseActionPage()), // Replace with your login or welcome page
        );
      }),
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

  Widget _buildNotifToggleRow(
      IconData icon, String label, VoidCallback onToggle) {
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

 // Update this function to use pushReplacement and ensure the user cannot go back
  Widget _buildNoArrowRow(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, // Pass the onTap function
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

class ManagePaymentsPatient extends StatefulWidget {
  @override
  _ManagePaymentsPatientState createState() => _ManagePaymentsPatientState();
}

class _ManagePaymentsPatientState extends State<ManagePaymentsPatient> {
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
    return Scaffold(
      appBar: PatientAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bank accounts',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ImportantRemindersWidget(),
            Divider(thickness: 2),
            Expanded(
              child: SingleChildScrollView(
                child: DottedBorder(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  strokeWidth: 2,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'John Doe',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text('Bank: ABC Bank'),
                            Text('Account Number: 1234567890'),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: _confirmDelete,
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _showAddBankAccountPopup,
                child: Text('Add a new bank account'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }
}

class UpdateProfilePatient extends StatefulWidget {
  @override
  UpdateProfilePatientState createState() => UpdateProfilePatientState();
}

class UpdateProfilePatientState extends State<UpdateProfilePatient> {
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
      appBar: PatientAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Update Profile',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Flex(
                  direction: Axis.vertical,
                  children: [
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
                            SizedBox(height: 20),
                            Center(
                child: ElevatedButton(
                  onPressed: () {
                    // update action
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 32,
                    ),
                    backgroundColor: const Color(0xFF617DEF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                            ),
                            ],
                  ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }
}
