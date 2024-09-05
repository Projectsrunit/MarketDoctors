import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:market_doctor/pages/success_page.dart';

class UploadCredentialsPage extends StatelessWidget {
  const UploadCredentialsPage({super.key});

  Future<void> _pickFile(BuildContext context) async {
    try {
      // Pick a single file
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;

        // Show file details or use the file
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File selected: ${file.name}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No file selected.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to pick file.'),
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
                    // Heading Text
                    const Text(
                      'Upload Credentials',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),

                    // Subheading Text
                    const Text(
                      'Regulation requires you to upload a certificate as a community health worker. Your data will stay safe and private with us.',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Upload Folder Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle folder upload action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Folder upload not implemented.'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 50,
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.folder_open),
                      label: const Text(
                        'Upload Folder',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
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
                        padding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 50,
                        ),
                        side: const BorderSide(color: Colors.blue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Select File from Gallery',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
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
                    builder: (context) => const SuccessPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 50,
                ),
                backgroundColor: Colors.blue,
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
