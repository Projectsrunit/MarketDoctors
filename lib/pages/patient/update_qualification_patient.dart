import 'package:flutter/material.dart';
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';
import 'package:market_doctor/pages/patient/patient_app_bar.dart';
import 'package:market_doctor/pages/patient/upload_file_patient.dart';

class UpdateQualificationPatient extends StatefulWidget {
  @override
  UpdateQualificationPatientState createState() =>
      UpdateQualificationPatientState();
}
Widget buildUploadFilePatient() {
  return UploadFilePatient();
}

class UpdateQualificationPatientState extends State<UpdateQualificationPatient> {
  List<String> qualifications = [
    "B.Sc. Computer Science",
    "M.Sc. Information Technology"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: patientAppBar(''),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Manage qualifications',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Qualification', style: TextStyle(fontSize: 18)),
            Column(
        children: qualifications.map((qual) => _buildQualificationRow(context, qual)).toList(),
      ),
            SizedBox(height: 20),
            Text('Add new', style: TextStyle(fontSize: 18)),
            buildUploadFilePatient()
          ],
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }

    Widget _buildQualificationRow(BuildContext context, String qualification) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[700] : Colors.grey[300]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(qualification),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                  )
                ),
                onPressed: () => _navigateToViewingPage(context),
                child: Text('View'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToViewingPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewingDocPage(),
      ),
    );
  }
}

class ViewingDocPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Viewing')),
      body: Center(
        child: Text('Viewing'),
      ),
    );
  }
}
