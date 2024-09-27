import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/chew/bottom_nav_bar.dart';
import 'package:market_doctor/pages/chew/cases_page.dart';
import 'package:market_doctor/pages/chew/doctor_view.dart';
import 'package:market_doctor/pages/chew/chew_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/pages/chew/doctor_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_doctor/pages/chew/view_doc_profile.dart';
import 'package:market_doctor/pages/patient/advertisement_carousel.dart';
import 'package:market_doctor/pages/user_type.dart';
import 'package:provider/provider.dart';

class ChewHome extends StatelessWidget {
  final int cases = 0;
  final int doctorsOnline = 0;
  final int users = 0;

  @override
  Widget build(BuildContext context) {
    Map? chewData = Provider.of<DataStore>(context).chewData;

    if (chewData == null) {
      return PopScope(canPop: false, child: ChooseUserTypePage());
    } else {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: ChewAppBar(),
          body: ChewHomeBody(),
          bottomNavigationBar: BottomNavBar(),
        ),
      );
    }
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
                  child: SizedBox(
                    height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search doctor, field, drugs",
                          hintStyle: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10), // Reduce vertical padding
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
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    'Search',
                    style: GoogleFonts.nunito(
                      textStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Cases icon
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
                        padding: EdgeInsets.all(28.0),
                        color: Colors.lightBlue[50],
                        child: Icon(
                          FontAwesomeIcons
                              .briefcaseMedical, // Medical case with a +
                          size: 40,
                          color: Colors.blue, // Blue icon
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Cases',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(width: 5.0),
              // Doctors icon
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
                        padding: EdgeInsets.all(28.0),
                        color: Colors.lightBlue[50], // Light blue background
                        child: Icon(
                          FontAwesomeIcons.stethoscope, // Stethoscope icon
                          size: 40,
                          color: Colors.blue, // Blue icon
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Doctors',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(width: 5.0),
              // Patients icon
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
                        padding: EdgeInsets.all(28.0),
                        color: Colors.lightBlue[50], // Light blue background
                        child: Icon(
                          FontAwesomeIcons.userGroup, // Patients icon
                          size: 40,
                          color: Colors.blue, // Blue icon
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Patients',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            height: 170,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                AdvertisementCarousel()
              ],
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DoctorView()));
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
            imageUrl: doctors[0]['profile_picture'] ??
                'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
            name: 'Dr. ${doctors[0]['firstName']} ${doctors[0]['lastName']}',
            profession: (doctors[0]['specialisation'] != null &&
                    doctors[0]['specialisation'].isNotEmpty)
                ? doctors[0]['specialisation']
                : 'General Practice',
            rating: 4.5,
            onChatPressed: () {},
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
              imageUrl: doctors[1]['profile_picture'] ??
                  'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
              name: 'Dr. ${doctors[1]['firstName']} ${doctors[1]['lastName']}',
              profession: (doctors[1]['specialisation'] != null &&
                      doctors[1]['specialisation'].isNotEmpty)
                  ? doctors[1]['specialisation']
                  : 'General Practice',
              rating: 4.0,
              onChatPressed: () {},
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
