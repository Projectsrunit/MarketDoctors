import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/pages/doctor/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class DoctorInformation extends StatefulWidget {
  const DoctorInformation({super.key});

  @override
  State<DoctorInformation> createState() => _DoctorInformationPageState();
}

class _DoctorInformationPageState extends State<DoctorInformation> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  File? _profileImage;
  bool _isLoading = false;

  // Controllers for editable fields
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _languagesController;
  late TextEditingController _awardsController;
  late TextEditingController _specializationController;
  late TextEditingController _clinicHealthFacilityController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current data
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;

    _emailController = TextEditingController(text: doctorData?['email'] ?? '');
    _phoneController = TextEditingController(text: doctorData?['phone'] ?? '');
    _yearsOfExperienceController = TextEditingController(
      text: doctorData?['years_of_experience'] != null
          ? doctorData!['years_of_experience'].toString()
          : '',
    );
    _languagesController = TextEditingController(
      text: doctorData?['languages'] ?? 'English',
    );
    _awardsController = TextEditingController(
        text: doctorData?['awards'] ?? 'Bachelor in Medicine');
    _specializationController = TextEditingController(
        text: doctorData?['specialisation'] ?? 'General Practice');
  }

  @override
  void dispose() {
    // Dispose of controllers
    _emailController.dispose();
    _phoneController.dispose();
    _yearsOfExperienceController.dispose();
    _languagesController.dispose();
    _awardsController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorData = Provider.of<DataStore>(context).doctorData;

    return Scaffold(
      appBar: DoctorApp(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture and Name Row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _isEditing ? _pickImage : null,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : NetworkImage(
                                  doctorData?['profile_picture'] ??
                                      'https://via.placeholder.com/150',
                                ) as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Dr. ${doctorData?['firstName'] ?? ''} ${doctorData?['lastName'] ?? ''}',
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildInfoRow('Email', doctorData?['email'] ?? ''),
                  _buildInfoRow('Phone Number', doctorData?['phone'] ?? ''),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Text(
                        'Overall Rating: ',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      Row(
                        children: List.generate(4,
                            (index) => Icon(Icons.star, color: Colors.yellow)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Editable or Static Fields based on _isEditing
                  _isEditing
                      ? _buildEditableFields()
                      : Column(
                          children: [
                            _buildInfoRow('Specialisation',
                                doctorData?['specialisation'] ?? ''),
                            const SizedBox(height: 10),
                            _buildInfoRow(
                                'Years of Experience',
                                doctorData?['years_of_experience']
                                        ?.toString() ??
                                    ''),
                            const SizedBox(height: 10),
                            _buildInfoRow(
                                'Languages', doctorData?['languages'] ?? ''),
                            const SizedBox(height: 10),
                            _buildInfoRow('Awards & Recognition',
                                doctorData?['awards'] ?? ''),
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildActionButton(),
            // Show loading indicator
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }

  Widget _buildEditableFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 10),
          TextFormField(
            controller: _yearsOfExperienceController,
            decoration: const InputDecoration(labelText: 'Years of Experience'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _languagesController,
            decoration: const InputDecoration(labelText: 'Languages'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _awardsController,
            decoration:
                const InputDecoration(labelText: 'Awards & Recognition'),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: _toggleEditing,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _isEditing ? Colors.redAccent : Colors.blueAccent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 5,
            ),
            child: Text(
              _isEditing ? 'Cancel' : 'Edit',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (_isEditing)
            ElevatedButton(
              onPressed: _updateUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 5,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final doctorData =
          Provider.of<DataStore>(context, listen: false).doctorData;

      // Upload image to Firebase Storage if it's selected
      String? profileImageUrl;
      if (_profileImage != null) {
        try {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('profile_pictures/${doctorData?['id']}.jpg');
          await storageRef.putFile(_profileImage!); // Upload image
          profileImageUrl =
              await storageRef.getDownloadURL(); // Get download URL
        } catch (e) {
          _showSnackBar('Error uploading image: $e');
          return; // Exit if the image upload fails
        }
      }

      // Prepare API request
      String? baseUrl = dotenv.env['API_URL'];
      final uri = Uri.parse('$baseUrl/api/users/${doctorData?['id']}');
      final request = http.MultipartRequest('PUT', uri);
      request.fields['yearsOfExperience'] = _yearsOfExperienceController.text;
      request.fields['clinicHealthFacility'] =
          _clinicHealthFacilityController.text;
      request.fields['specialization'] = _specializationController.text;
      request.fields['languages'] = _languagesController.text;
      request.fields['awards'] = _awardsController.text;

      // Include profile image URL in the request if available
      if (profileImageUrl != null) {
        request.fields['profile_picture'] = profileImageUrl;
      }

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          _showSnackBar('User updated successfully!');
          setState(() {
            _isEditing = false;
          });
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DoctorProfilePage(),
            ),
          );
        } else {
          _showSnackBar('Failed to update user: ${response.reasonPhrase}');
          setState(() {
            _isLoading = false;
          });
        }
      } catch (e) {
        _showSnackBar('Error: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
