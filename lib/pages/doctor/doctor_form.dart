// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/doctor/availability_calendar.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/pages/doctor/doctor_appointment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
              builder: (context) => AvailabilityCalendar(),
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
        const Text('Profile Image',
            style: TextStyle(fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Pick Image'),
            ),
            const SizedBox(width: 16),
            _profileImage != null
                ? Image.file(_profileImage!,
                    width: 100, height: 100, fit: BoxFit.cover)
                : Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: const Icon(Icons.camera_alt, color: Colors.white),
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
      appBar: DoctorApp(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                child: Text(
                  'Doctor Form',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
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
              const SizedBox(height: 20),
              _buildLabeledTextField(
                controller: _yearsOfExperienceController,
                labelText: 'Years of Experience',
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                controller: _clinicHealthFacilityController,
                labelText: 'Clinic / Health Facility',
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                controller: _specializationController,
                labelText: 'Specialization',
              ),
              const SizedBox(height: 20),
              _buildLabeledTextField(
                controller: _languageController,
                labelText: 'Languages',
              ),
              const SizedBox(height: 16),
              _buildLabeledTextField(
                controller: _awardsAndRecognitionController,
                labelText: 'Awards & Recognition',
              ),
              const SizedBox(height: 16),
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            labelText,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            keyboardType: labelText == 'Years of Experience'
                ? TextInputType.number
                : TextInputType.text,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
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
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _updateUser,
        child: const Text('Save'),
      ),
    );
  }
}
