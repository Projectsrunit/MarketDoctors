import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Hospital Model
class Hospital {
  final int id;
  final String name;
  final String location;
  final String contact;
  final String email;

  Hospital({
    required this.id,
    required this.name,
    required this.location,
    required this.contact,
    required this.email,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    return Hospital(
      id: json['id'],
      name: attributes['name'],
      location: attributes['location'],
      contact: attributes['contact'],
      email: attributes['email'],
    );
  }
}


Future<List<Hospital>> fetchHospitals() async {
  final String baseUrl = dotenv.env['API_URL']!;
  final response = await http.get(Uri.parse('$baseUrl/api/hospitals'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'] as List;
    return data.map((hospitalJson) => Hospital.fromJson(hospitalJson)).toList();
  } else {
    throw Exception('Failed to load hospitals');
  }
}

// Main App
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospitals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HospitalListPage(),
    );
  }
}

// Hospital List Page
class HospitalListPage extends StatefulWidget {
  @override
  _HospitalListPageState createState() => _HospitalListPageState();
}

class _HospitalListPageState extends State<HospitalListPage> {
  late Future<List<Hospital>> futureHospitals;

  @override
  void initState() {
    super.initState();
    futureHospitals = fetchHospitals();
  }

  // Function to launch phone dialer
  void _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      print('Could not launch $phoneNumber');
    }
  }

  // Function to launch email application





  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(
  title: Text(
    'Hospitals',
    style: TextStyle(color: Colors.white),  // Change text to white
  ),
  backgroundColor: Colors.blue.shade900,
  iconTheme: IconThemeData(color: Colors.white),  // Change back arrow to white
),

      body: FutureBuilder<List<Hospital>>(
        future: futureHospitals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hospitals available.'));
          }

          final hospitals = snapshot.data!;
          return ListView.builder(
            itemCount: hospitals.length,
            itemBuilder: (context, index) {
              final hospital = hospitals[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                shadowColor: Colors.grey.shade200,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hospital.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue.shade400),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              hospital.location,
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.blue.shade400),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _makePhoneCall(hospital.contact),
                            child: Text(
                              hospital.contact,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.email, color: Colors.blue.shade400),
                          SizedBox(width: 8),
                          GestureDetector(
                         
                            child: Text(
                              hospital.email,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
