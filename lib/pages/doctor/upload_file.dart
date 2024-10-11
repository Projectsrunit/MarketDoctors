// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:market_doctor/pages/doctor/doctor_form.dart';

class DoctorsUploadCredentialsPage extends StatelessWidget {
  const DoctorsUploadCredentialsPage({super.key});

  Future<void> _pickFile(BuildContext context) async {
    try {
      // Pick a single file
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        final filePath = file.path;

        if (filePath != null) {
          // Show file selected
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('File selected: ${file.name}'),
            ),
          );

          // Upload to Firebase Storage
          await _uploadFileToFirebase(context, File(filePath), file.name);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No file selected.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick file: $e'),
        ),
      );
    }
  }

  Future<void> _uploadFileToFirebase(
      BuildContext context, File file, String fileName) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = storageRef.putFile(file);
      final taskSnapshot = await uploadTask.whenComplete(() {});
      final downloadURL = await taskSnapshot.ref.getDownloadURL();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('File uploaded successfully! Download URL: $downloadURL'),
        ),
      );
    } catch (e) {
      print('this is the response $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload file: $e'),
          
        ),
      );
    }
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 30), // Added margin at the top
                    const Text(
                      'Upload Credentials',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Regulation requires you to upload a certificating document as a doctor. Your data will stay safe and private with us.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 50),

                    // Drag and Drop Container
                    GestureDetector(
                      onTap: () {
                        _pickFile(context);
                      },
                      child: DottedBorder(
                        color: Colors.grey,
                        strokeWidth: 2,
                        dashPattern: [8, 4],
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
                                  fontSize: 18,
                                  color: Color(0xFF617DEF),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'or',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Browse Files',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF617DEF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Select File from Gallery Button
                    OutlinedButton(
                      onPressed: () {
                        _pickFile(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 50,
                        ),
                        side: const BorderSide(color: Color(0xFF617DEF)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Select File from Gallery',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF617DEF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Submit Button at the Bottom
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const DoctorFormPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 50,
                ),
                backgroundColor: const Color(0xFF617DEF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
