import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/patient/patient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';

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
    Map? patientData =
        Provider.of<DataStore>(context, listen: false).patientData;
    patientId = patientData?['id'];

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PatientAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(firstNameController, 'First Name', isDarkMode),
              const SizedBox(height: 10),
              _buildTextField(lastNameController, 'Last Name', isDarkMode),
              const SizedBox(height: 10),
              _buildTextField(
                  phoneNumberController, 'Phone Number', isDarkMode),
              const SizedBox(height: 10),
              _buildTextField(emailController, 'Email', isDarkMode),
              const SizedBox(height: 10),
              _buildTextField(
                  busStopController, 'Nearest Bus Stop', isDarkMode),
              const SizedBox(height: 10),
              _buildTextField(
                  homeAddressController, 'Home Address', isDarkMode),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: updateProfile,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Update Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDarkMode ? Colors.grey : Colors.blueAccent),
        boxShadow: [
          BoxShadow(
            color:
                isDarkMode ? Colors.black45 : Colors.lightBlue.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
