import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';
import 'package:market_doctor/pages/patient/patient_app_bar.dart';
import 'package:market_doctor/pages/patient/payments_main_widget.dart';
import 'package:provider/provider.dart';
import 'package:market_doctor/pages/choose_action.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:market_doctor/chat_store.dart';


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
        _buildArrowRow(Icons.payment, "Payments History", () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ManagePaymentsPatient()));
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
      _buildNotifToggleRow(Icons.notifications, "Allow notifications", () {}),
      Divider(color: Colors.grey[300], thickness: 1),
      _buildNoArrowRow(context, Icons.logout, "Log out", () {
        context.read<DataStore>().updatePatientData(null);
          context.read<ChatStore>().resetStore();
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
  final TextEditingController busStopController = TextEditingController();
  final TextEditingController homeAddressController = TextEditingController();

  int? patientId;

  @override
  void initState() {
    super.initState();

    // Get the patient ID from the context
    Map? patientData = Provider.of<DataStore>(context, listen: false).patientData;
    patientId = patientData?['id'];

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
      setState(() {
        firstNameController.text = data['firstName'] ?? '';
        lastNameController.text = data['lastName'] ?? '';
        phoneNumberController.text = data['phone'] ?? '';
        emailController.text = data['email'] ?? '';
        busStopController.text = data['nearest_bus_stop'] ?? '';
        homeAddressController.text = data['home_address'] ?? '';
      });
    } else {
      print('Failed to load patient data: ${response.statusCode}');
    }
  }

  void updateProfile() async {
    final url = '${dotenv.env['API_URL']}/api/users/$patientId';
    final response = await http.put(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'phone': phoneNumberController.text,
        'email': emailController.text,
        'nearest_bus_stop': busStopController.text,
        'home_address': homeAddressController.text,
      }),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
       Fluttertoast.showToast(
        msg: "Record Updated successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      print('Failed to update profile: ${response.statusCode}');
    }
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: PatientAppBar(),
  
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(firstNameController, 'First Name'),
              SizedBox(height: 10),
              _buildTextField(lastNameController, 'Last Name'),
              SizedBox(height: 10),
              _buildTextField(phoneNumberController, 'Phone Number'),
              SizedBox(height: 10),
              _buildTextField(emailController, 'Email'),
              SizedBox(height: 10),
              _buildTextField(busStopController, 'Nearest Bus Stop'),
              SizedBox(height: 10),
              _buildTextField(homeAddressController, 'Home Address'),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: updateProfile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue,
                  ),
                  child: Text('Update Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the text field
        borderRadius: BorderRadius.circular(8), // Rounded corners
        border: Border.all(color: Colors.blueAccent), // Blue border
        boxShadow: [
          BoxShadow(
            color: Colors.lightBlue.withOpacity(0.2), // Light blue shadow
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Changes position of shadow
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none, // No inner border
          contentPadding: EdgeInsets.all(16), // Padding for text
        ),
      ),
    );
    
  }
  

}
