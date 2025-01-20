// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
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

  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _languagesController;
  late TextEditingController _awardsController;
  late TextEditingController _specializationController;
  late TextEditingController _aboutDoctorController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _doctorIdController;
  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;
    _firstNameController =
        TextEditingController(text: doctorData?['firstName'] ?? '');
    _doctorIdController =
        TextEditingController(text: doctorData?['id']?.toString() ?? '');
    _lastNameController =
        TextEditingController(text: doctorData?['lastName'] ?? '');
    _emailController = TextEditingController(text: doctorData?['email'] ?? '');
    _aboutDoctorController =
        TextEditingController(text: doctorData?['about'] ?? '');
    _phoneController = TextEditingController(text: doctorData?['phone'] ?? '');
    _yearsOfExperienceController = TextEditingController(
      text: doctorData?['years_of_experience']?.toString() ?? '',
    );
    _languagesController =
        TextEditingController(text: doctorData?['languages'] ?? 'English');
    _awardsController = TextEditingController(
        text: doctorData?['awards'] ?? 'Bachelor in Medicine');
    _specializationController = TextEditingController(
        text: doctorData?['specialisation'] ?? 'General Practice');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _yearsOfExperienceController.dispose();
    _languagesController.dispose();
    _awardsController.dispose();
    _specializationController.dispose();
    _aboutDoctorController.dispose();
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
            _buildProfileContainer(doctorData?.cast<String, dynamic>()),
            const SizedBox(height: 30),
            _buildActionButton(),
            if (_isLoading) Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }

  Widget _buildProfileContainer(Map<String, dynamic>? doctorData) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(doctorData),
          const SizedBox(height: 20),
          _isEditing ? _buildEditableFields() : _buildStaticFields(doctorData),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic>? doctorData) {
    return Row(
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
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStaticFields(Map<String, dynamic>? doctorData) {
    return Column(
      children: [
        _buildInfoRow('Email', doctorData?['email'] ?? ''),
        _buildInfoRow('Phone Number', doctorData?['phone'] ?? ''),
        _buildInfoRow('Specialisation', doctorData?['specialisation'] ?? ''),
        _buildInfoRow('Years of Experience',
            doctorData?['years_of_experience']?.toString() ?? ''),
        _buildInfoRow('Languages', doctorData?['languages'] ?? ''),
        _buildInfoRow('Awards & Recognition', doctorData?['awards'] ?? ''),
        Row(
          children: [
            const Text('Overall Rating: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 5),
            Row(
                children: List.generate(4,
                    (index) => const Icon(Icons.star, color: Colors.yellow))),
          ],
        ),
        _buildInfoRow('About Doctor', doctorData?['about'] ?? ''),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildEditableFields() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEditableField(_yearsOfExperienceController,
              'Years of Experience', TextInputType.number),
          _buildEditableField(_languagesController, 'Languages'),
          _buildEditableField(_awardsController, 'Awards & Recognition'),
          _buildEditableField(_specializationController, 'Specialization'),
          _buildEditableField(_aboutDoctorController, 'About Doctor'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 5),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget _buildEditableField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        minLines: label == 'About Doctor' ? 3 : 1,
        maxLines: label == 'About Doctor' ? null : 1,
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
                  borderRadius: BorderRadius.circular(8.0)),
              elevation: 5,
            ),
            child: Text(
              _isEditing ? 'Cancel' : 'Edit',
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
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
                    borderRadius: BorderRadius.circular(8.0)),
                elevation: 5,
              ),
              child: const Text(
                'Save',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _initializeControllers();
      }
    });
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState?.validate() != true) return;
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;
    print('Updating doctor with ID: ${doctorData?['id']}');
    setState(() {
      _isLoading = true;
    });

    try {
      final doctorData =
          Provider.of<DataStore>(context, listen: false).doctorData;

      final userData = {
        'firstName': doctorData?['firstName'] ?? '',
        'lastName': doctorData?['lastName'] ?? '',
        'email': _emailController.text,
        'phone': _phoneController.text,
        'years_of_experience': _yearsOfExperienceController.text,
        'languages': _languagesController.text,
        'awards': _awardsController.text,
        'specialisation': _specializationController.text,
        'about': _aboutDoctorController.text,
      };

      if (_profileImage != null) {
        final profileImageUrl = await _uploadProfileImage();
        userData['profile_picture'] = profileImageUrl;
      } else {
        userData['profile_picture'] = doctorData?['profile_picture'];
      }

      print('User Data to update: $userData'); // Debugging line

      final response = await _updateDoctorData(userData);
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Update state with new data from the server
        final updatedData = jsonDecode(response.body);
        Provider.of<DataStore>(context, listen: false)
            .updateDoctorData(updatedData);
        _showSuccessDialog();
      } else {
        _showErrorDialog('Failed to update data. Please try again.');
      }
    } catch (e) {
      _showErrorDialog('An error occurred: $e');
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _uploadProfileImage() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('doctor_profiles/${DateTime.now().millisecondsSinceEpoch}');
    await storageRef.putFile(_profileImage!);
    return await storageRef.getDownloadURL();
  }

  Future<http.Response> _updateDoctorData(Map<String, dynamic> userData) {
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;
    String? baseUrl = dotenv.env['API_URL'];
    print('Doctor Id: ${doctorData?['id']}');
    final uri = Uri.parse('$baseUrl/api/users/${doctorData?['id']}');
    return http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userData),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Doctor information updated successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isEditing = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
