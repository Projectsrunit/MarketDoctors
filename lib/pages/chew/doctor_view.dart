import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/chatting_page.dart';
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
                  return DoctorCard(
                    imageUrl: doc['profile_picture'] ??
                        'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                    name: 'Dr. ${doc['firstName']} ${doc['lastName']}',
                    profession: (doc['specialisation'] != null &&
                            doc['specialisation'].isNotEmpty)
                        ? doc['specialisation']
                        : 'General Practice',
                    rating: 4.5,
                    onChatPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChattingPage(
                                  doctorId: doc['id'],
                                  doctorName:
                                      'Dr. ${doc['firstName']} ${doc['lastName']}',
                                  doctorImage: doc['profile_picture'] ??
                                      'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                                  doctorPhoneNumber: doc['phone'],
                                ))),
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
