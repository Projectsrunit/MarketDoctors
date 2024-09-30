import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:provider/provider.dart';

class DoctorInformation extends StatefulWidget {
  const DoctorInformation({Key? key}) : super(key: key);

  @override
  State<DoctorInformation> createState() => _DoctorInformationPageState();
}

class _DoctorInformationPageState extends State<DoctorInformation> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
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
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(doctorData?['profileImage'] ?? 'https://via.placeholder.com/150'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Dr. ${doctorData?['firstName'] ?? ''} ${doctorData?['lastName'] ?? ''}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Email and Phone Number Row
                  _buildInfoRow('Email', doctorData?['email'] ?? ''),
                  const SizedBox(height: 10),
                  _buildInfoRow('Phone Number', doctorData?['phone'] ?? ''),
                  const SizedBox(height: 20),

                  // Overall Rating Row
                  Row(
                    children: [
                      Text(
                        'Overall Rating: ',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      Row(
                        children: List.generate(4, (index) => Icon(Icons.star, color: Colors.yellow)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Languages
                  _buildInfoRow('Languages', doctorData?["languages"] ?? ''),
                  const SizedBox(height: 10),

                  // Awards
                  _buildInfoRow('Awards & Recognition', doctorData?['awards'] ?? ''),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (_isEditing) _buildEditableFields(),
            const SizedBox(height: 20),
            _buildActionButton(),
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
          // Add any editable fields here
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: _toggleEditing,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          ),
          child: Text(_isEditing ? 'Cancel' : 'Update'),
        ),
        if (_isEditing)
          ElevatedButton(
            onPressed: _updateUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: const Text('Save'),
          ),
      ],
    );
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _updateUser() async {
    if (_formKey.currentState!.validate()) {
      // Update logic here
      _showSnackBar('User data updated!');
      _toggleEditing();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
