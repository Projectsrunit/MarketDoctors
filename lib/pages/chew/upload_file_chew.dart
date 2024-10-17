// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/chew/update_qualification_chew.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UploadFileChew extends StatelessWidget {
  // Function to upload the file to Firebase and get its download URL
  Future<String?> _uploadFileToFirebase(PlatformFile file) async {
    try {
      final firebaseStorageRef =
          FirebaseStorage.instance.ref().child('uploads/${file.name}');
      final uploadTask = firebaseStorageRef.putData(file.bytes!);

      // Await for the upload task to complete
      await uploadTask.whenComplete(() => null);

      // Get the download URL
      final fileUrl = await firebaseStorageRef.getDownloadURL();
      return fileUrl;
    } catch (e) {
      print('Error uploading to Firebase: $e');
      return null;
    }
  }

  // Function to send the file URL to the backend
  Future<void> _sendFileUrlToServer(
      BuildContext context, String fileUrl, String fileName) async {
    final chewData = Provider.of<DataStore>(context, listen: false).chewData;

    if (chewData == null || chewData['id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No doctor data available. Please log in again.')));
      return;
    }

    try {
      final baseUrl = dotenv.env['API_URL'];
      final url = Uri.parse('$baseUrl/api/qualifications');

      final body = jsonEncode({
        "data": {
          "name": fileName, // Use the dynamic file name here
          "file_url": fileUrl,
          "user": chewData['id'],
        }
      });

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File URL sent successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to send file URL. Status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending file URL: ${e.toString()}')));
    }
  }

  // Function to pick and upload the file, then send its URL
  Future<void> _pickFile(BuildContext context) async {
    try {
      // Pick a single file
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;

        // Show file details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File selected: ${file.name}')),
        );

        // Upload the file to Firebase
        final fileUrl = await _uploadFileToFirebase(file);

        if (fileUrl != null) {
          // If upload is successful, send the file URL and the file name to the backend
          await _sendFileUrlToServer(context, fileUrl, file.name);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File upload failed.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No file selected.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to pick file.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>  UpdateQualificationChew(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 32,
              ),
              backgroundColor: const Color(0xFF617DEF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
