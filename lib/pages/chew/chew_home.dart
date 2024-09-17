import 'package:flutter/material.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/cases_page.dart';
import 'package:market_doctor/pages/chew/doctor_view.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/pages/chew/doctor_card.dart';

class ChewHome extends StatelessWidget {
  final int cases = 0;
  final int doctorsOnline = 0;
  final int users = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chewAppBar(),
      //detect a back button press and dont log out the person
      body: ChewHomeBody(),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

class ChewHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search doctor, field, drugs",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // Add search functionality here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context)
                            .textButtonTheme
                            .style
                            ?.backgroundColor
                            ?.resolve({}) ??
                        Color(0xFF617DEF),
                    foregroundColor: Theme.of(context)
                            .textButtonTheme
                            .style
                            ?.foregroundColor
                            ?.resolve({}) ??
                        Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text('Search'),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CasesPage()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.local_hospital,
                            size: 80, color: Colors.red),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Cases',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DoctorView()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.person, size: 80, color: Colors.blue),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Doctors',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CasesPage()));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.person_outline,
                            size: 80, color: Colors.green),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Patients',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            height: 130,
            color: Color(0xFF617DEF),
            child: Center(
              child: Text(
                'for advertisement',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Doctors',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DoctorView()));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  'See all',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Populars(),
        ],
      ),
    );
  }
}

class Populars extends StatefulWidget {
  @override
  PopularsState createState() => PopularsState();
}

class PopularsState extends State<Populars> {
  List<dynamic> doctors = [];
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse(
        '$baseUrl/api/users?filters[role][\$eq]=3&populate=*&pagination[pageSize]=0start=0&limit=2');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        doctors = data;
        isLoading = false;
      });
    } else {
      print('Failed to load doctors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isLoading) ...[
            SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ] else if (doctors.isNotEmpty) ...[
          DoctorCard(
            imageUrl: doctors[0]['picture_url'] ??
                'https://via.placeholder.com/120',
            name: 'Dr. ${doctors[0]['firstName']} ${doctors[0]['lastName']}',
            profession: (doctors[0]['specialisation'] != null &&
                    doctors[0]['specialisation'].isNotEmpty)
                ? doctors[0]['specialisation'][0]
                : 'General Practice_',
            rating: 4.5,
            onChatPressed: () {},
            onViewProfilePressed: () {},
            onBookAppointmentPressed: () {},
          ),
          SizedBox(height: 16.0),
          if (doctors.length > 1) ...[
            DoctorCard(
              imageUrl: doctors[1]['picture_url'] ??
                  'https://via.placeholder.com/120',
              name: 'Dr. ${doctors[1]['firstName']} ${doctors[1]['lastName']}',
              profession: (doctors[1]['specialisation'] != null &&
                      doctors[1]['specialisation'].isNotEmpty)
                  ? doctors[1]['specialisation'][0]
                  : 'General Practice_',
              rating: 4.0,
              onChatPressed: () {},
              onViewProfilePressed: () {},
              onBookAppointmentPressed: () {},
            ),
          ],
        ] else ...[
          Center(child: Text('No doctors available')) // Display message if no doctors are found
        ]
      ],
    );
  }
}
