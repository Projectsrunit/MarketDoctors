import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DoctorPharmacy {
  final int id;
  final String name;
  final String location;
  final String phone;
  final String email;

  DoctorPharmacy({
    required this.id,
    required this.name,
    required this.location,
    required this.phone,
    required this.email,
  });

  factory DoctorPharmacy.fromJson(Map<String, dynamic> json) {
    final attributes = json['attributes'];
    return DoctorPharmacy(
      id: json['id'],
      name: attributes['name'] ?? 'Unknown Name', // Provide default value
      location: attributes['location'] ?? 'Unknown Location',
      phone: attributes['phone'] ?? 'No Contact', // Handle possible nulls
      email: attributes['email'] ?? 'No Email', // Handle possible nulls
    );
  }
}

Future<List<DoctorPharmacy>> fetchPharmacies() async {
  final String baseUrl = dotenv.env['API_URL']!;
  final response = await http.get(Uri.parse('$baseUrl/api/pharmacies'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body)['data'] as List;
    return data
        .map((pharmacyJson) => DoctorPharmacy.fromJson(pharmacyJson))
        .toList();
  } else {
    throw Exception('Failed to load pharmacies');
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
      title: 'Pharmacies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DoctorPharmacyListPage(),
    );
  }
}

class DoctorPharmacyListPage extends StatefulWidget {
  @override
  _DoctorPharmacyListPageState createState() => _DoctorPharmacyListPageState();
}

class _DoctorPharmacyListPageState extends State<DoctorPharmacyListPage> {
  late Future<List<DoctorPharmacy>> futurePharmacies;

  @override
  void initState() {
    super.initState();
    futurePharmacies = fetchPharmacies();
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
      appBar: DoctorAppBar(),
      body: FutureBuilder<List<DoctorPharmacy>>(
        future: futurePharmacies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Pharmacies available.'));
          }

          final pharmacies = snapshot.data!;
          return ListView.builder(
            itemCount: pharmacies.length,
            itemBuilder: (context, index) {
              final pharmacy = pharmacies[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                        pharmacy.name,
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
                              pharmacy.location,
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
                            onTap: () => _makePhoneCall(pharmacy.phone),
                            child: Text(
                              pharmacy.phone,
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
                              pharmacy.email,
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
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }
}
