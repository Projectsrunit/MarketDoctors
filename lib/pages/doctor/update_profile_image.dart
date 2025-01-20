import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:market_doctor/pages/doctor/profile_page.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorUpdateProfileImage extends StatefulWidget {
  const DoctorUpdateProfileImage({super.key});

  @override
  _DoctorUpdateProfileImagePageState createState() =>
      _DoctorUpdateProfileImagePageState();
}

class _DoctorUpdateProfileImagePageState
    extends State<DoctorUpdateProfileImage> {
  bool _isLoading = false; // To manage loading state

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result == null || result.files.isEmpty) {
        _showSnackBar('No file selected. Please choose a file to upload.');
        return;
      }

      final file = result.files.single;
      final filePath = file.path;

      if (filePath != null) {
        _showSnackBar('File selected: ${file.name}');
        await _uploadFileToFirebase(File(filePath), file.name);
      }
    } catch (e) {
      _showSnackBar('Failed to pick file. Please try again.');
    }
  }

  Future<void> _uploadFileToFirebase(File file, String fileName) async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_pictures/$fileName');

      final uploadTask = storageRef.putFile(file);
      final taskSnapshot = await uploadTask.whenComplete(() {});
      final downloadURL = await taskSnapshot.ref.getDownloadURL();

      // Show success message
      _showSnackBar('Your profile picture has been uploaded successfully!');

      // Send the download URL to the server
      await _sendFileUrlToServer(downloadURL);
    } catch (e) {
      _showSnackBar(
          'Oops! Something went wrong while uploading your picture. Please try again.');
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state
      });
    }
  }

  Future<void> _sendFileUrlToServer(String downloadURL) async {
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;

    try {
      final baseUrl = dotenv.env['API_URL'];
      final url = Uri.parse('$baseUrl/api/users/${doctorData?['id']}');

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'profile_picture': downloadURL}),
      );

      if (response.statusCode == 200) {
        print('File URL sent successfully!');
      } else {
        print('Failed to send file URL: ${response.body}');
      }
    } catch (e) {
      print('Error sending file URL: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DoctorApp(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Upload Profile Picture',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Update Profile Image',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),
                    GestureDetector(
                      onTap: _pickFile,
                      child: DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 2,
                        dashPattern: const [8, 4],
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/arrow_up.png',
                                height: 80,
                                width: 80,
                                color: const Color(0xFF617DEF),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Drag & Drop your files here',
                                style: TextStyle(
                                    fontSize: 18, color: Color(0xFF617DEF)),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'or',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Browse Files',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF617DEF)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: _pickFile,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 50),
                        side: const BorderSide(color: Color(0xFF617DEF)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text(
                        'Select File from Gallery',
                        style:
                            TextStyle(fontSize: 18, color: Color(0xFF617DEF)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              CircularProgressIndicator(), // Show loading indicator
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DoctorProfilePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                backgroundColor: const Color(0xFF617DEF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }
}
