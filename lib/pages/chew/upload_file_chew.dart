import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class UploadFileChew extends StatelessWidget {

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
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save action
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
