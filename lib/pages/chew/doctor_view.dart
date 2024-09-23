import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/pages/chew/doctor_card.dart';
import 'dart:convert';

import 'package:market_doctor/pages/chew/view_doc_profile.dart';

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
    if (doctors.isEmpty) {
      fetchDoctors();
    }
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
      appBar: ChewAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            children: [
              SizedBox(
                width: 48,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
              SizedBox( width: 48), 
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
                  return DoctorCard(
                    imageUrl:
                        doc['picture_url'] ?? 'https://via.placeholder.com/120',
                    name: 'Dr. ${doc['firstName']} ${doc['lastName']}',
                    profession: (doc['specialisation'] != null &&
                            doc['specialisation'].isNotEmpty)
                        ? doc['specialisation'][0]
                        : 'General Practice_',
                    rating: 4.5,
                    onChatPressed: () {},
                    onViewProfilePressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ViewDocProfile(doctorCard: doc)));
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
        ]),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class AvailableDocs extends StatelessWidget {
  final String name;
  final int age;
  final String location;

  AvailableDocs(
      {required this.name, required this.age, required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        Text('Age: $age'),
        Text('Location: $location'),
      ],
    );
  }
}

class AvailableDocsDetails extends StatelessWidget {
  final Map<String, dynamic> doctor;

  AvailableDocsDetails({required this.doctor});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChewAppBar(),
      body: Column(
        children: [
          Row(
            children: [
              // Doctor's Image
              Image.network('https://example.com/doctor_image.png', width: 50),
              Column(
                children: [
                  Text(doctor['name']),
                  Text('Specialty: ${doctor['specialty']}'),
                  Row(
                    children: [
                      Icon(Icons.star),
                      Icon(Icons.star),
                      Icon(Icons.star)
                    ], // Star Rating
                  ),
                  // Online indicator
                  Align(
                    alignment: Alignment.topRight,
                    child: Icon(Icons.circle, color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
          // More details
          Row(
            children: [
              Icon(Icons.people),
              Text("1000+ patients"),
              Icon(Icons.timer),
              Text("10 years experience"),
              Icon(Icons.local_hospital),
              Text("Health Clinic"),
            ],
          ),
          Text("About doctor"),
          Text("Doctor's detailed description goes here."),
          Text("Availability"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Mon-Fri"), Text("9:00 AM - 5:00 PM")],
          ),
          Text("Specialisation"),
          Text("Cardiology, Pediatrics, etc."),
          Text("Languages"),
          Text("English, Spanish"),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RealDoctorView(
                          doctor: doctor,
                        ),
                      ),
                    );
                  },
                  child: Text('Send message')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back')),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
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
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Row(
          children: [
            Text(doctor['name']),
            Icon(Icons.circle, color: Colors.green), // Online status
            CircleAvatar(
                backgroundImage:
                    NetworkImage('https://example.com/doctor_image.png')),
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
                // Messages from the doctor and user
              ],
            ),
          ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.add), onPressed: () {}),
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(hintText: "Enter message"))),
              IconButton(icon: Icon(Icons.send), onPressed: () {}),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
