// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/main.dart';

class DoctorAvailability extends StatefulWidget {
  const DoctorAvailability({super.key});

  @override
  State<DoctorAvailability> createState() => _DoctorAvailabilityState();
}

class _DoctorAvailabilityState extends State<DoctorAvailability> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _yearsOfExperienceController = TextEditingController();
  final TextEditingController _clinicHealthFacilityController = TextEditingController();
  final TextEditingController _specializationController = TextEditingController();
  final TextEditingController _awardsAndRecognitionController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final doctorData = Provider.of<DataStore>(context, listen: false).doctorData;
    if (doctorData != null) {
      _yearsOfExperienceController.text = doctorData['yearsOfExperience']?.toString() ?? '';
      _clinicHealthFacilityController.text = doctorData['clinicHealthFacility'] ?? '';
      _specializationController.text = doctorData['specialization'] ?? '';
      _languageController.text = doctorData['languages'] ?? '';
      _awardsAndRecognitionController.text = doctorData['awardsAndRecognition'] ?? '';
    } else {
      _showSnackBar('No doctor data found.');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildDoctorProfile() {
    final doctorData = Provider.of<DataStore>(context, listen: false).doctorData;
    final name = doctorData != null
        ? '${doctorData['firstName']} ${doctorData['lastName']}'
        : 'Unknown Doctor';
    final specialization = doctorData?['specialisation'] ?? 'Not Specified';
    final profilePic = doctorData?['profile_picture'];
    final availabilities = doctorData?['doctor_availabilities'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile section
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: profilePic != null
                    ? NetworkImage(profilePic)
                    : const AssetImage('assets/images/placeholder.png') as ImageProvider,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(specialization,
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Availability section
          const Text('Availability:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...availabilities.map<Widget>((availability) {
            final date = availability['date'];
            final availableTimes = availability['available_time'];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date: $date',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    availableTimes != null && availableTimes.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: availableTimes.map<Widget>((time) {
                              return Text('Time: ${time['start_time']} - ${time['end_time']}');
                            }).toList(),
                          )
                        : const Text('No available time'),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorApp(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Doctor Availability',
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Add more form fields and logic here
              _buildDoctorProfile(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }
}
