import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:market_doctor/pages/patient/bottom_nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Market Doctor',  // System-level app title (metadata)
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ContactPage(),
    );
  }
}

class ContactPage extends StatelessWidget {
  final String phoneNumber = '+234 906 522 6485';

  // Function to launch the dialer with the provided phone number
  void _launchDialer(String number) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $number';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Market Doctor',
          style: TextStyle(
            color: Colors.white, // Make AppBar title white
          ),
        ),
        backgroundColor: Colors.blue, // AppBar background color
        iconTheme: IconThemeData(color: Colors.white), // Icons in AppBar (if any) will also be white
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                shadowColor: Colors.grey[400],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[800], // Background color for the card
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 40,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Contact Market Doctor',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // White text color for card title
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '22 Raufu Williams Cres, Surulere, Lagos 101241, Lagos, Nigeria',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[300]),
                      ),
                      SizedBox(height: 20),
                      Divider(color: Colors.white54),
                      SizedBox(height: 10),
                      Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => _launchDialer(phoneNumber),
                        child: Text(
                          phoneNumber,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: PatientBottomNavBar(),
    );
  }
}
