import 'package:flutter/material.dart';
import 'package:market_doctor/main.dart';
import 'package:market_doctor/pages/patient/advertisement_carousel.dart';
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';
import 'package:market_doctor/pages/patient/cases_page.dart';
import 'package:market_doctor/pages/patient/doctor_view.dart';
import 'package:market_doctor/pages/patient/patient_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:market_doctor/pages/user_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:market_doctor/pages/patient/doctor_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:market_doctor/pages/patient/view_doc_profile.dart';
import 'package:google_fonts/google_fonts.dart';

class PatientHome extends StatelessWidget {
  final int cases = 0;
  final int doctorsOnline = 0;
  final int users = 0;
  

  // // Add the required parameters
  // final String patientId;
  // final String patientName;

  // // Constructor to accept patientId and patientName
  // const PatientHome({Key? key, required this.patientId, required this.patientName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map? patientData = Provider.of<DataStore>(context).patientData;

    if (patientData == null) {
      return PopScope(canPop: false, child: ChooseUserTypePage());
    } else {
      return PopScope(
        canPop: false,
        child: Scaffold(
          appBar: PatientAppBar(),
          body: PatientHomeBody(),
          bottomNavigationBar: PatientBottomNavBar(),
        ),
      );
    }
  }
}

class PatientHomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Advertisement carousel
          Container(
            margin: EdgeInsets.only(bottom: 16.0),
  child: Row(
  children: [
    Expanded(
      child: SizedBox(
        height: 40,  // Adjust the height as needed
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search doctor, field, drugs",
            hintStyle: GoogleFonts.nunito(
              textStyle: TextStyle(
                fontSize: 14,  // Adjust the font size as needed
                fontWeight: FontWeight.normal,  // Change the weight if necessary
                color: Colors.grey,  // Change the color if you want a different hint color
              ),
            ),
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10), // Reduce vertical padding
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
          // Remaining widgets...
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Cases icon
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientCasesPage()));
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
                          FontAwesomeIcons.hospital,
                          size: 40,
                          color: Colors.blue, // Blue icon
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Hospitals',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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
                          FontAwesomeIcons.stethoscope,
                          size: 40,
                          color: Colors.blue, // Blue icon
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Doctors', style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),),
                  ],
                ),
              ),
              SizedBox(width: 5.0),
              // Patients icon
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientCasesPage()));
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
                          FontAwesomeIcons.pills,
                          size: 40,
                          color: Colors.blue, // Blue icon
                        ),
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text('Pharmacy',
                        style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ),
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
              child: Row(children: [
                AdvertisementCarousel(),
              ])),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Popular Doctors',
                 style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DoctorView()));
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: const Color.fromARGB(0, 202, 23, 23),
                ),
                child: Text(
                  'See all',
                   style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                 
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
    final String baseUrl =
        dotenv.env['API_URL']!; // Ensure this is correctly set
    final Uri url = Uri.parse(
        '$baseUrl/api/users?filters[role][\$eq]=3&populate=*&pagination[pageSize]=2&pagination[start]=0');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        doctors = data.map((doctor) {
          String fullImageUrl =
              'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg'; // Default image with base URL

          // Check if profile_picture is not null and has a valid URL
          if (doctor['profile_picture'] != null
              // && doctor['profile_picture']['formats'] != null &&
              //     doctor['profile_picture']['formats']['thumbnail'] != null &&
              //     doctor['profile_picture']['formats']['thumbnail']['url'] != null
              ) {
            fullImageUrl = '${doctor['profile_picture']}';
          }

          doctor['full_image_url'] = fullImageUrl;
          return doctor;
        }).toList();
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
            imageUrl: doctors[0]['full_image_url'], // Use full_image_url
            name: 'Dr. ${doctors[0]['firstName']} ${doctors[0]['lastName']}',
            profession: doctors[0]['specialisation'] ?? 'General Practice',
            rating: doctors[0]['total_overall_rating'] != null
                ? doctors[0]['total_overall_rating'] /
                    (doctors[0]['total_raters'] ?? 1)
                : 0,
            onChatPressed: () {},
            onViewProfilePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewDocProfile(doctorCard: doctors[0]),
                ),
              );
            },
            onBookAppointmentPressed: () {},
          ),
          SizedBox(height: 16.0),
          if (doctors.length > 1) ...[
            DoctorCard(
              imageUrl: doctors[1]['full_image_url'], // Use full_image_url
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
                        ViewDocProfile(doctorCard: doctors[1]),
                  ),
                );
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
