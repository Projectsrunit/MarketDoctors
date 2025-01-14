import 'package:flutter/material.dart';
import 'package:market_doctor/pages/chew/view_doc_profile.dart';
import 'dart:convert';
import 'package:market_doctor/pages/chew/chatting_page.dart';
import 'package:http/http.dart' as http;
import 'package:market_doctor/pages/chew/doctor_card.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      print('this is the error: $e');
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
            id: doctors[0]['id'],
            imageUrl: doctors[0]['profile_picture'] ??
                'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
            name: 'Dr. ${doctors[0]['firstName']} ${doctors[0]['lastName']}',
            profession: (doctors[0]['specialisation'] != null &&
                    doctors[0]['specialisation'].isNotEmpty)
                ? doctors[0]['specialisation']
                : 'General Practice',
            rating: 4.5,
            onChatPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChattingPage(
                          doctorName:
                              'Dr. ${doctors[0]['firstName']} ${doctors[0]['lastName']}',
                          doctorImage: doctors[0]['profile_picture'] ??
                              'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                          doctorPhoneNumber: doctors[0]['phone'],
                          doctorId: doctors[0]['id'],
                        ))),
            onViewProfilePressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ViewDocProfile(doctorCard: doctors[0])));
            },
            onBookAppointmentPressed: () {},
          ),
          SizedBox(height: 16.0),
          if (doctors.length > 1) ...[
            DoctorCard(
              id: doctors[1]['id'],
              imageUrl: doctors[1]['profile_picture'] ??
                  'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
              name: 'Dr. ${doctors[1]['firstName']} ${doctors[1]['lastName']}',
              profession: (doctors[1]['specialisation'] != null &&
                      doctors[1]['specialisation'].isNotEmpty)
                  ? doctors[1]['specialisation']
                  : 'General Practice',
              rating: 4.0,
              onChatPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChattingPage(
                            doctorId: doctors[1]['id'],
                            doctorName:
                                'Dr. ${doctors[1]['firstName']} ${doctors[1]['lastName']}',
                            doctorImage: doctors[1]['profile_picture'] ??
                                'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                            doctorPhoneNumber: doctors[1]['phone'],
                          ))),
              onViewProfilePressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewDocProfile(doctorCard: doctors[1])));
              },
              onBookAppointmentPressed: () {},
            ),
          ],
        ] else ...[
          SizedBox(
            height: 100,
            child: Center(child: Text('No doctors available')),
          )
        ]
      ],
    );
  }
}
