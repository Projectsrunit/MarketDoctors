import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';
import 'package:market_doctor/pages/patient/patient_app_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/pages/patient/doctor_card.dart';
import 'dart:convert';

import 'package:market_doctor/pages/patient/view_doc_profile.dart';

class DoctorView extends StatefulWidget {
  @override
  State<DoctorView> createState() => _DoctorViewState();
}

class _DoctorViewState extends State<DoctorView> {
  List<dynamic> doctors = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url =
        Uri.parse('$baseUrl/api/users?filters[role][\$eq]=3&populate=*');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          doctors = data;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load doctors');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to load doctors',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 48,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Popular Doctors',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 48),
              ],
            ),
            if (isLoading) ...[
              SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ] else if (doctors.isNotEmpty) ...[
              Expanded(
                child: ListView.separated(
                  itemCount: doctors.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final doc = doctors[index];
                    final String baseUrl = dotenv.env['API_URL']!; // Get the base URL again

                     String fullImageUrl = '$baseUrl/uploads/thumbnail_qq_f13aeead91.jpg';  // Default image

                    // Check if profile_picture is not null and has a valid URL
                    if (doc['profile_picture'] != null &&
                        doc['profile_picture']['formats'] != null &&
                        doc['profile_picture']['formats']['thumbnail'] != null &&
                        doc['profile_picture']['formats']['thumbnail']['url'] != null) {
                      fullImageUrl = '$baseUrl${doc['profile_picture']['formats']['thumbnail']['url']}';
                    }

                    return DoctorCard(
                      imageUrl: fullImageUrl,
                      name: 'Dr. ${doc['firstName']} ${doc['lastName']}',
                      profession: (doc['specialisation'] != null &&
                              doc['specialisation'].isNotEmpty)
                          ? doc['specialisation'][0]
                          : 'General Practice',
                      rating: 4.5,
                      onChatPressed: () {},
                      onViewProfilePressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewDocProfile(doctorCard: doc),
                          ),
                        );
                      },
                      onBookAppointmentPressed: () {},
                    );
                  },
                ),
              ),
            ] else ...[
              SizedBox(
                height: 100,
                child: Center(child: Text('No doctors available')),
              )
            ]
          ],
        ),
      ),
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }
}

// Removed the duplicate AvailableDocs class

class AvailableDocsDetails extends StatelessWidget {
  final Map<String, dynamic> doctor;

  AvailableDocsDetails({required this.doctor});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PatientAppBar(),
      body: Column(
        children: [
          Row(
            children: [
              Image.network(doctor['profile_picture']['formats']['thumbnail']['url'], width: 50), // Use the correct image URL
              Column(
                children: [
                  Text('Dr. ${doctor['firstName']} ${doctor['lastName']}'),
                  Text('Specialty: ${doctor['specialisation'] ?? 'N/A'}'),
                  Row(
                    children: [
                      Icon(Icons.star),
                      Icon(Icons.star),
                      Icon(Icons.star),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.circle, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
          // More details...
        ],
      ),
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }
}

class RealDoctorView extends StatelessWidget {
  final Map<String, dynamic> doctor;

  RealDoctorView({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text('Dr. ${doctor['firstName']} ${doctor['lastName']}'),
            Icon(Icons.circle, color: Colors.green), // Online status
            CircleAvatar(
              backgroundImage:
                  NetworkImage(doctor['profile_picture']['formats']['thumbnail']['url']),
            ),
          ],
        ),
        actions: [IconButton(icon: Icon(Icons.phone), onPressed: () {})],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Chat messages UI similar to WhatsApp
              ],
            ),
          ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.add), onPressed: () {}),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(hintText: "Enter message")),
              ),
              IconButton(icon: Icon(Icons.send), onPressed: () {}),
            ],
          ),
        ],
      ),
      bottomNavigationBar: PatientBottomNavBar(),
    );
  }
}
