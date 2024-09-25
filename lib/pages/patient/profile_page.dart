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
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';



class PatientProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     int? patientId; 
    Map? patientData = Provider.of<DataStore>(context).patientData;
     patientId = patientData?['user']['id']; 
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
  final TextEditingController
 phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController
 busStopController = TextEditingController();
  final TextEditingController homeAddressController = TextEditingController();

  int? patientId;

  @override
  void initState() {
    super.initState();

    // Get the patient ID from the context
    Map? patientData = Provider.of<DataStore>(context, listen: false).patientData;
    patientId = patientData?['user']['id'];

    // Check if patient ID is retrieved
    print("Retrieved patient ID: $patientId");

    if (patientId != null) {
      final baseUrl = dotenv.env['API_URL'];
      final url = '$baseUrl/api/users/$patientId?populate=*';
      fetchPatientData(url);
    } else {
      print("Patient ID is null, cannot fetch data.");
    }
  }

  Future<void> fetchPatientData(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      print("Retrieved patient data: $data"); // Log retrieved data
      // Autofill the text fields with the retrieved data
      setState(() {
        firstNameController.text = data['firstName'] ?? '';
        lastNameController.text = data['lastName'] ?? '';
        phoneNumberController.text = data['phone'] ?? '';
        emailController.text = data['email'] ?? '';
        busStopController.text = data['nearestBusStop'] ?? '';
        homeAddressController.text = data['homeAddress'] ?? '';
      });
    } else {
      // Handle the error
      print('Failed to load patient data: ${response.statusCode}');
    }
  }

  void updateProfile() async {
    final url = '${dotenv.env['BASE_URL']}/api/users/$patientId';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'phone': phoneNumberController.text,
        'email': emailController.text,
        'nearestBusStop': busStopController.text,
        'homeAddress': homeAddressController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Handle successful update
      print('Profile updated successfully');
    } else {
      // Handle update error
      print('Failed to update profile: ${response.statusCode}');
    }
  }
    

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
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                borderRadius: BorderRadius.circular(8),
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
                    TextField(
                      controller: phoneNumberController,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: busStopController,
                      decoration: InputDecoration(labelText: 'Nearest Bus Stop'),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: homeAddressController,
                      decoration: InputDecoration(labelText: 'Home Address'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: updateProfile,
                      child: Text('Update Profile'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}