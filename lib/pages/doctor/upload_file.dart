import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:market_doctor/data_store.dart';
import 'package:market_doctor/pages/doctor/doctor_form.dart';
import 'package:provider/provider.dart';

class DoctorsUploadCredentialsPage extends StatefulWidget {
  const DoctorsUploadCredentialsPage({super.key});

  @override
  _DoctorsUploadCredentialsPageState createState() =>
      _DoctorsUploadCredentialsPageState();
}

class _DoctorsUploadCredentialsPageState
    extends State<DoctorsUploadCredentialsPage> {
  bool _isLoading = false;

  String? _fileName; // To store the file name dynamically

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result == null || result.files.isEmpty) {
        _showSnackBar('No file selected.');
        return;
      }

      final file = result.files.single;
      final filePath = file.path;

      if (filePath != null) {
        setState(() {
          _fileName = file.name; // Store the dynamic file name
        });

        _showSnackBar('File selected: $_fileName');
        await _uploadFileToFirebase(File(filePath), _fileName!);
      }
    } catch (e) {
      _showSnackBar('Failed to pick file: ${e.toString()}');
    }
  }

  Future<void> _uploadFileToFirebase(File file, String fileName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('certifying_docs/$fileName');

      final uploadTask = storageRef.putFile(file);
      final taskSnapshot = await uploadTask.whenComplete(() {});
      final downloadURL = await taskSnapshot.ref.getDownloadURL();

      _showSnackBar('Document uploaded successfully!');
      await _sendFileUrlToServer(
          downloadURL, fileName); // Send file URL with dynamic name
    } catch (e) {
      _showSnackBar('Error during file upload. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendFileUrlToServer(String fileUrl, String fileName) async {
    final doctorData =
        Provider.of<DataStore>(context, listen: false).doctorData;

    if (doctorData == null || doctorData['id'] == null) {
      _showSnackBar('No doctor data available. Please log in again.');
      return;
    }
    try {
      final baseUrl = dotenv.env['API_URL'];
      final url = Uri.parse('$baseUrl/api/qualifications');
      final body = jsonEncode({
        "data": {
          "name": fileName,
          "file_url": fileUrl,
          "user": doctorData['id'],
        }
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        _showSnackBar('File URL sent successfully!');
      } else {
        _showSnackBar(
            'Failed to send file URL. Status: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error sending file URL: ${e.toString()}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      'Upload Credentials',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Upload a certifying document as a doctor. Your data will be kept safe and private.',
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
            if (_isLoading) ...[
              const SizedBox(height: 10),
              Column(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    'Uploading... Please wait',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DoctorFormPage(),
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
    );
  }
}
