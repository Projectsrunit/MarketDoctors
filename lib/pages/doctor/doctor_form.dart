// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/doctor/availability_calendar.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:market_doctor/pages/doctor/check_inbox.dart';
import 'package:provider/provider.dart';

class DoctorFormPage extends StatefulWidget {
  const DoctorFormPage({
    super.key,
  });

  @override
  State<DoctorFormPage> createState() => _DoctorFormPageState();
}

class _DoctorFormPageState extends State<DoctorFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _yearsOfExperienceController = TextEditingController();
  final _clinicHealthFacilityController = TextEditingController();
  final _specializationController = TextEditingController();
  final _awardsAndRecognitionController = TextEditingController();
  final _languageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;
    if (doctorData != null) {
      _yearsOfExperienceController.text =
          doctorData['yearsOfExperience']?.toString() ?? '';
      _clinicHealthFacilityController.text =
          doctorData['clinicHealthFacility'] ?? '';
      _specializationController.text = doctorData['specialization'] ?? '';
      _languageController.text = doctorData['languages'] ?? '';
      _awardsAndRecognitionController.text =
          doctorData['awardsAndRecognition'] ?? '';
    } else {
      _showSnackBar('No doctor data found.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final doctorData =
          Provider.of<DataStore>(context, listen: false).doctorData;
      String? baseUrl = dotenv.env['API_URL'];
      final uri = Uri.parse('$baseUrl/api/users/${doctorData?['id']}');
      final request = http.MultipartRequest('PUT', uri);
      request.fields['yearsOfExperience'] = _yearsOfExperienceController.text;
      request.fields['clinicHealthFacility'] =
          _clinicHealthFacilityController.text;
      request.fields['specialization'] = _specializationController.text;
      request.fields['languages'] = _languageController.text;
      request.fields['awardsAndRecognition'] =
          _awardsAndRecognitionController.text;

      if (_profileImage != null) {
        final imageFile = await http.MultipartFile.fromPath(
            'profile_picture', _profileImage!.path);
        request.files.add(imageFile);
      }

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          _showSnackBar('User updated successfully!');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DoctorCheckInboxPage(),
            ),
          );
        } else {
          _showSnackBar('Failed to update user: ${response.reasonPhrase}');
        }
      } catch (e) {
        _showSnackBar('Error: $e');
      }
    }
  }

  Widget _buildProfileImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile Image',
          style: TextStyle(
              fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Pick Image'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(width: 16),
            _profileImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _profileImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 40),
                  ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctorData = Provider.of<DataStore>(context).doctorData;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor KYC'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Doctor Form',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!, width: 1.0),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Doctor ${doctorData?['firstName'] ?? ''} ${doctorData?['lastName'] ?? ''}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              _buildLabeledTextField(
                controller: _yearsOfExperienceController,
                labelText: 'Years of Experience',
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                controller: _clinicHealthFacilityController,
                labelText: 'Clinic / Health Facility',
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                controller: _specializationController,
                labelText: 'Specialization',
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                controller: _languageController,
                labelText: 'Languages',
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                controller: _awardsAndRecognitionController,
                labelText: 'Awards & Recognition',
              ),
              const SizedBox(height: 20),
              _buildProfileImagePicker(),
              const SizedBox(height: 30),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }

  Widget _buildLabeledTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: labelText == 'Years of Experience'
                ? TextInputType.number
                : TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
              hintText: labelText == 'Awards & Recognition'
                  ? 'Enter your awards and recognitions'
                  : null,
            ),
            maxLines: labelText == 'Awards & Recognition' ? 4 : 1,
            validator: (value) {
              if (labelText == 'Years of Experience') {
                if (value == null || value.isEmpty) {
                  return 'Please enter your years of experience';
                }
                final int? years = int.tryParse(value);
                if (years == null || years < 0) {
                  return 'Please enter a valid number';
                }
              } else if (labelText == 'Awards & Recognition') {
                if (value == null || value.isEmpty) {
                  return 'Please enter your awards and recognitions';
                }
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: _updateUser, // Disable button when loading
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.blueAccent,
        ),
        child: const Text(
          'Save',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
