import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:market_doctor/data_store.dart';
import 'package:provider/provider.dart';
import 'package:market_doctor/pages/doctor/bottom_nav_bar.dart';
import 'package:market_doctor/pages/doctor/chatting_page.dart';
import 'package:market_doctor/pages/chew_or_patient_card.dart';
import 'package:market_doctor/pages/doctor/doctor_appbar.dart';
import 'package:http/http.dart' as http;

class DoctorsChats extends StatefulWidget {
  @override
  DoctorsChatsState createState() => DoctorsChatsState();
}

class DoctorsChatsState extends State<DoctorsChats> {
  List<dynamic> chews = [];
  List<dynamic> patients = [];
  bool isChewLoading = true;
  bool isPatientLoading = true;
  bool _isChewsSelected = true;

  @override
  void initState() {
    super.initState();
    if (chews.isEmpty) {
      fetchChews();
    }
    if (patients.isEmpty) {
      fetchPatients();
    }
  }

  Future<void> fetchChews() async {
    int doc = context.read<DataStore>().doctorData?['id'];
    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse('$baseUrl/api/getchatsfor');
    try {
      final response = await http.post(url, headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'id': doc, 'role': 4}));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          chews = data;
          isChewLoading = false;
        });
      } else {
        throw Exception('Failed to load CHEWs');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to load CHEWs',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> fetchPatients() async {
    int doc = context.read<DataStore>().doctorData?['id'];
    final String baseUrl = dotenv.env['API_URL']!;
    final Uri url = Uri.parse('$baseUrl/api/getchatsfor');
    try {
      final response = await http.post(url, headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'id': doc, 'role': 5}));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          patients = data;
          isPatientLoading = false;
        });
      } else {
        throw Exception('Failed to load Patients');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to load Patients',
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
      appBar: DoctorApp(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isChewsSelected ? Colors.blue : Colors.white,
                      foregroundColor:
                          _isChewsSelected ? Colors.white : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isChewsSelected = true;
                      });
                    },
                    child: Text('CHEWs'),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_isChewsSelected
                          ? Colors.blue
                          : Colors.white,
                      foregroundColor: !_isChewsSelected
                          ? Colors.white
                          : Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isChewsSelected = false;
                      });
                    },
                    child: Text('Patients'),
                  ),
                ),
              ],
            ),
            Expanded(
              child: _isChewsSelected
                  ? ChewsWidget(isLoading: isChewLoading, chews: chews)
                  : PatientsWidget(isLoading: isPatientLoading, patients: patients),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DoctorBottomNavBar(),
    );
  }
}

class ChewsWidget extends StatelessWidget {
  final bool isLoading;
  final List<dynamic> chews;

  ChewsWidget({required this.isLoading, required this.chews});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          if (isLoading)
            SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (chews.isNotEmpty)
            Flexible(
              child: ListView.separated(
                itemCount: chews.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.0),
                itemBuilder: (context, index) {
                  final chew = chews[index];
                  return ChewOrPatientCard(
                    id: chew['id'],
                    imageUrl: chew['profile_picture'] ??
                        'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                    name: '${chew['firstName']} ${chew['lastName']}',
                    onChatPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChattingPage(
                                  guestId: chew['id'],
                                  guestName:
                                      '${chew['firstName']} ${chew['lastName']}',
                                  guestImage: chew['profile_picture'] ??
                                      'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                                  guestPhoneNumber: chew['phone'],
                                ))),
                  );
                },
              ),
            )
          else
            SizedBox(
              height: 100,
              child: Center(child: Text('No CHEWs available')),
            ),
        ],
      ),
    );
  }
}

class PatientsWidget extends StatelessWidget {
  final bool isLoading;
  final List<dynamic> patients;

  PatientsWidget({required this.isLoading, required this.patients});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          if (isLoading)
            SizedBox(
              height: 200,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (patients.isNotEmpty)
            Flexible(
              child: ListView.separated(
                itemCount: patients.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.0),
                itemBuilder: (context, index) {
                  final chew = patients[index];
                  return ChewOrPatientCard(
                    id: chew['id'],
                    imageUrl: chew['profile_picture'] ??
                        'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                    name: '${chew['firstName']} ${chew['lastName']}',
                    onChatPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChattingPage(
                                  guestId: chew['id'],
                                  guestName:
                                      '${chew['firstName']} ${chew['lastName']}',
                                  guestImage: chew['profile_picture'] ??
                                      'https://res.cloudinary.com/dqkofl9se/image/upload/v1727171512/Mobklinic/qq_jz1abw.jpg',
                                  guestPhoneNumber: chew['phone'],
                                ))),
                  );
                },
              ),
            )
          else
            SizedBox(
              height: 100,
              child: Center(child: Text('No CHEWs available')),
            ),
        ],
      ),
    );
  }
}
